
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc f0 64 18 80       	mov    $0x801864f0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 32 10 80       	mov    $0x80103260,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 c0 76 10 80       	push   $0x801076c0
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 95 45 00 00       	call   801045f0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 76 10 80       	push   $0x801076c7
80100097:	50                   	push   %eax
80100098:	e8 43 44 00 00       	call   801044e0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave
801000c2:	c3                   	ret
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 27 46 00 00       	call   80104710 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 e9 46 00 00       	call   80104850 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ae 43 00 00       	call   80104520 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 df 21 00 00       	call   80102370 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 ce 76 10 80       	push   $0x801076ce
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 fd 43 00 00       	call   801045c0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave
  iderw(b);
801001d4:	e9 97 21 00 00       	jmp    80102370 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 df 76 10 80       	push   $0x801076df
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 bc 43 00 00       	call   801045c0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 6c 43 00 00       	call   80104580 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 f0 44 00 00       	call   80104710 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2c                	jne    8010025c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 53 54             	mov    0x54(%ebx),%edx
80100233:	8b 43 50             	mov    0x50(%ebx),%eax
80100236:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
80100239:	8b 53 54             	mov    0x54(%ebx),%edx
8010023c:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010023f:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 e2 45 00 00       	jmp    80104850 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 e6 76 10 80       	push   $0x801076e6
80100276:	e8 05 01 00 00       	call   80100380 <panic>
8010027b:	66 90                	xchg   %ax,%ax
8010027d:	66 90                	xchg   %ax,%ax
8010027f:	90                   	nop

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 37 16 00 00       	call   801018d0 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 6b 44 00 00       	call   80104710 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 ae 3f 00 00       	call   80104280 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 a9 38 00 00       	call   80103b90 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 55 45 00 00       	call   80104850 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 ec 14 00 00       	call   801017f0 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 ff 44 00 00       	call   80104850 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 96 14 00 00       	call   801017f0 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli
  cons.locking = 0;
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 62 27 00 00       	call   80102b00 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 ed 76 10 80       	push   $0x801076ed
801003a7:	e8 04 03 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 fb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 a1 7e 10 80 	movl   $0x80107ea1,(%esp)
801003bc:	e8 ef 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 43 42 00 00       	call   80104610 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 01 77 10 80       	push   $0x80107701
801003dd:	e8 ce 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
80100409:	3d 00 01 00 00       	cmp    $0x100,%eax
8010040e:	0f 84 cc 00 00 00    	je     801004e0 <consputc.part.0+0xe0>
    uartputc(c);
80100414:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100417:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010041c:	89 c3                	mov    %eax,%ebx
8010041e:	50                   	push   %eax
8010041f:	e8 0c 5b 00 00       	call   80105f30 <uartputc>
80100424:	b8 0e 00 00 00       	mov    $0xe,%eax
80100429:	89 fa                	mov    %edi,%edx
8010042b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042c:	be d5 03 00 00       	mov    $0x3d5,%esi
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100434:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100437:	89 fa                	mov    %edi,%edx
80100439:	b8 0f 00 00 00       	mov    $0xf,%eax
8010043e:	c1 e1 08             	shl    $0x8,%ecx
80100441:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100442:	89 f2                	mov    %esi,%edx
80100444:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100445:	0f b6 c0             	movzbl %al,%eax
  if(c == '\n')
80100448:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	75 76                	jne    801004c8 <consputc.part.0+0xc8>
    pos += 80 - pos%80;
80100452:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100457:	f7 e2                	mul    %edx
80100459:	c1 ea 06             	shr    $0x6,%edx
8010045c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010045f:	c1 e0 04             	shl    $0x4,%eax
80100462:	8d 70 50             	lea    0x50(%eax),%esi
  if(pos < 0 || pos > 25*80)
80100465:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
8010046b:	0f 8f 2f 01 00 00    	jg     801005a0 <consputc.part.0+0x1a0>
  if((pos/80) >= 24){  // Scroll up.
80100471:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100477:	0f 8f c3 00 00 00    	jg     80100540 <consputc.part.0+0x140>
  outb(CRTPORT+1, pos>>8);
8010047d:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
8010047f:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100486:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100489:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010048c:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100491:	b8 0e 00 00 00       	mov    $0xe,%eax
80100496:	89 da                	mov    %ebx,%edx
80100498:	ee                   	out    %al,(%dx)
80100499:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010049e:	89 f8                	mov    %edi,%eax
801004a0:	89 ca                	mov    %ecx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b8 0f 00 00 00       	mov    $0xf,%eax
801004a8:	89 da                	mov    %ebx,%edx
801004aa:	ee                   	out    %al,(%dx)
801004ab:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004af:	89 ca                	mov    %ecx,%edx
801004b1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004b2:	b8 20 07 00 00       	mov    $0x720,%eax
801004b7:	66 89 06             	mov    %ax,(%esi)
}
801004ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004bd:	5b                   	pop    %ebx
801004be:	5e                   	pop    %esi
801004bf:	5f                   	pop    %edi
801004c0:	5d                   	pop    %ebp
801004c1:	c3                   	ret
801004c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801004c8:	0f b6 db             	movzbl %bl,%ebx
801004cb:	8d 70 01             	lea    0x1(%eax),%esi
801004ce:	80 cf 07             	or     $0x7,%bh
801004d1:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801004d8:	80 
801004d9:	eb 8a                	jmp    80100465 <consputc.part.0+0x65>
801004db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801004df:	90                   	nop
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e0:	83 ec 0c             	sub    $0xc,%esp
801004e3:	be d4 03 00 00       	mov    $0x3d4,%esi
801004e8:	6a 08                	push   $0x8
801004ea:	e8 41 5a 00 00       	call   80105f30 <uartputc>
801004ef:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f6:	e8 35 5a 00 00       	call   80105f30 <uartputc>
801004fb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100502:	e8 29 5a 00 00       	call   80105f30 <uartputc>
80100507:	b8 0e 00 00 00       	mov    $0xe,%eax
8010050c:	89 f2                	mov    %esi,%edx
8010050e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010050f:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100514:	89 da                	mov    %ebx,%edx
80100516:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100517:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010051a:	89 f2                	mov    %esi,%edx
8010051c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100521:	c1 e1 08             	shl    $0x8,%ecx
80100524:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100525:	89 da                	mov    %ebx,%edx
80100527:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100528:	0f b6 f0             	movzbl %al,%esi
    if(pos > 0) --pos;
8010052b:	83 c4 10             	add    $0x10,%esp
8010052e:	09 ce                	or     %ecx,%esi
80100530:	74 5e                	je     80100590 <consputc.part.0+0x190>
80100532:	83 ee 01             	sub    $0x1,%esi
80100535:	e9 2b ff ff ff       	jmp    80100465 <consputc.part.0+0x65>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 ca 43 00 00       	call   80104930 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 25 43 00 00       	call   801048a0 <memset>
  outb(CRTPORT+1, pos);
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 06 ff ff ff       	jmp    8010048c <consputc.part.0+0x8c>
80100586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058d:	8d 76 00             	lea    0x0(%esi),%esi
80100590:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
80100594:	be 00 80 0b 80       	mov    $0x800b8000,%esi
80100599:	31 ff                	xor    %edi,%edi
8010059b:	e9 ec fe ff ff       	jmp    8010048c <consputc.part.0+0x8c>
    panic("pos under/overflow");
801005a0:	83 ec 0c             	sub    $0xc,%esp
801005a3:	68 05 77 10 80       	push   $0x80107705
801005a8:	e8 d3 fd ff ff       	call   80100380 <panic>
801005ad:	8d 76 00             	lea    0x0(%esi),%esi

801005b0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005b0:	55                   	push   %ebp
801005b1:	89 e5                	mov    %esp,%ebp
801005b3:	57                   	push   %edi
801005b4:	56                   	push   %esi
801005b5:	53                   	push   %ebx
801005b6:	83 ec 18             	sub    $0x18,%esp
801005b9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005bc:	ff 75 08             	push   0x8(%ebp)
801005bf:	e8 0c 13 00 00       	call   801018d0 <iunlock>
  acquire(&cons.lock);
801005c4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005cb:	e8 40 41 00 00       	call   80104710 <acquire>
  for(i = 0; i < n; i++)
801005d0:	83 c4 10             	add    $0x10,%esp
801005d3:	85 f6                	test   %esi,%esi
801005d5:	7e 25                	jle    801005fc <consolewrite+0x4c>
801005d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005da:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005dd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff);
801005e3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005e6:	85 d2                	test   %edx,%edx
801005e8:	74 06                	je     801005f0 <consolewrite+0x40>
  asm volatile("cli");
801005ea:	fa                   	cli
    for(;;)
801005eb:	eb fe                	jmp    801005eb <consolewrite+0x3b>
801005ed:	8d 76 00             	lea    0x0(%esi),%esi
801005f0:	e8 0b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005f5:	83 c3 01             	add    $0x1,%ebx
801005f8:	39 df                	cmp    %ebx,%edi
801005fa:	75 e1                	jne    801005dd <consolewrite+0x2d>
  release(&cons.lock);
801005fc:	83 ec 0c             	sub    $0xc,%esp
801005ff:	68 20 ff 10 80       	push   $0x8010ff20
80100604:	e8 47 42 00 00       	call   80104850 <release>
  ilock(ip);
80100609:	58                   	pop    %eax
8010060a:	ff 75 08             	push   0x8(%ebp)
8010060d:	e8 de 11 00 00       	call   801017f0 <ilock>

  return n;
}
80100612:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100615:	89 f0                	mov    %esi,%eax
80100617:	5b                   	pop    %ebx
80100618:	5e                   	pop    %esi
80100619:	5f                   	pop    %edi
8010061a:	5d                   	pop    %ebp
8010061b:	c3                   	ret
8010061c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100620 <printint>:
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	57                   	push   %edi
80100624:	56                   	push   %esi
80100625:	89 c6                	mov    %eax,%esi
80100627:	53                   	push   %ebx
80100628:	89 d3                	mov    %edx,%ebx
8010062a:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010062d:	85 c9                	test   %ecx,%ecx
8010062f:	74 04                	je     80100635 <printint+0x15>
80100631:	85 c0                	test   %eax,%eax
80100633:	78 63                	js     80100698 <printint+0x78>
    x = xx;
80100635:	89 f1                	mov    %esi,%ecx
80100637:	31 c0                	xor    %eax,%eax
  i = 0;
80100639:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010063c:	31 f6                	xor    %esi,%esi
8010063e:	66 90                	xchg   %ax,%ax
    buf[i++] = digits[x % base];
80100640:	89 c8                	mov    %ecx,%eax
80100642:	31 d2                	xor    %edx,%edx
80100644:	89 f7                	mov    %esi,%edi
80100646:	f7 f3                	div    %ebx
80100648:	8d 76 01             	lea    0x1(%esi),%esi
8010064b:	0f b6 92 30 77 10 80 	movzbl -0x7fef88d0(%edx),%edx
80100652:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
80100656:	89 ca                	mov    %ecx,%edx
80100658:	89 c1                	mov    %eax,%ecx
8010065a:	39 da                	cmp    %ebx,%edx
8010065c:	73 e2                	jae    80100640 <printint+0x20>
  if(sign)
8010065e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100661:	85 c0                	test   %eax,%eax
80100663:	74 07                	je     8010066c <printint+0x4c>
    buf[i++] = '-';
80100665:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
    buf[i++] = digits[x % base];
8010066a:	89 f7                	mov    %esi,%edi
8010066c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010066f:	01 df                	add    %ebx,%edi
  if(panicked){
80100671:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i]);
80100677:	0f be 07             	movsbl (%edi),%eax
  if(panicked){
8010067a:	85 d2                	test   %edx,%edx
8010067c:	74 0a                	je     80100688 <printint+0x68>
8010067e:	fa                   	cli
    for(;;)
8010067f:	eb fe                	jmp    8010067f <printint+0x5f>
80100681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100688:	e8 73 fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
8010068d:	8d 47 ff             	lea    -0x1(%edi),%eax
80100690:	39 df                	cmp    %ebx,%edi
80100692:	74 0c                	je     801006a0 <printint+0x80>
80100694:	89 c7                	mov    %eax,%edi
80100696:	eb d9                	jmp    80100671 <printint+0x51>
80100698:	89 c8                	mov    %ecx,%eax
    x = -xx;
8010069a:	89 f1                	mov    %esi,%ecx
8010069c:	f7 d9                	neg    %ecx
8010069e:	eb 99                	jmp    80100639 <printint+0x19>
}
801006a0:	83 c4 2c             	add    $0x2c,%esp
801006a3:	5b                   	pop    %ebx
801006a4:	5e                   	pop    %esi
801006a5:	5f                   	pop    %edi
801006a6:	5d                   	pop    %ebp
801006a7:	c3                   	ret
801006a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006b9:	8b 3d 54 ff 10 80    	mov    0x8010ff54,%edi
  if (fmt == 0)
801006bf:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
801006c2:	85 ff                	test   %edi,%edi
801006c4:	0f 85 36 01 00 00    	jne    80100800 <cprintf+0x150>
  if (fmt == 0)
801006ca:	85 f6                	test   %esi,%esi
801006cc:	0f 84 e0 01 00 00    	je     801008b2 <cprintf+0x202>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d2:	0f b6 06             	movzbl (%esi),%eax
801006d5:	85 c0                	test   %eax,%eax
801006d7:	74 6b                	je     80100744 <cprintf+0x94>
  argp = (uint*)(void*)(&fmt + 1);
801006d9:	8d 55 0c             	lea    0xc(%ebp),%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006dc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801006df:	31 db                	xor    %ebx,%ebx
801006e1:	89 d7                	mov    %edx,%edi
    if(c != '%'){
801006e3:	83 f8 25             	cmp    $0x25,%eax
801006e6:	0f 85 dc 00 00 00    	jne    801007c8 <cprintf+0x118>
    c = fmt[++i] & 0xff;
801006ec:	83 c3 01             	add    $0x1,%ebx
801006ef:	0f b6 0c 1e          	movzbl (%esi,%ebx,1),%ecx
    if(c == 0)
801006f3:	85 c9                	test   %ecx,%ecx
801006f5:	74 42                	je     80100739 <cprintf+0x89>
    switch(c){
801006f7:	83 f9 70             	cmp    $0x70,%ecx
801006fa:	0f 84 99 00 00 00    	je     80100799 <cprintf+0xe9>
80100700:	7f 4e                	jg     80100750 <cprintf+0xa0>
80100702:	83 f9 25             	cmp    $0x25,%ecx
80100705:	0f 84 cd 00 00 00    	je     801007d8 <cprintf+0x128>
8010070b:	83 f9 64             	cmp    $0x64,%ecx
8010070e:	0f 85 24 01 00 00    	jne    80100838 <cprintf+0x188>
      printint(*argp++, 10, 1);
80100714:	8d 47 04             	lea    0x4(%edi),%eax
80100717:	b9 01 00 00 00       	mov    $0x1,%ecx
8010071c:	ba 0a 00 00 00       	mov    $0xa,%edx
80100721:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100724:	8b 07                	mov    (%edi),%eax
80100726:	e8 f5 fe ff ff       	call   80100620 <printint>
8010072b:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010072e:	83 c3 01             	add    $0x1,%ebx
80100731:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100735:	85 c0                	test   %eax,%eax
80100737:	75 aa                	jne    801006e3 <cprintf+0x33>
80100739:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
8010073c:	85 ff                	test   %edi,%edi
8010073e:	0f 85 df 00 00 00    	jne    80100823 <cprintf+0x173>
}
80100744:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100747:	5b                   	pop    %ebx
80100748:	5e                   	pop    %esi
80100749:	5f                   	pop    %edi
8010074a:	5d                   	pop    %ebp
8010074b:	c3                   	ret
8010074c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100750:	83 f9 73             	cmp    $0x73,%ecx
80100753:	75 3b                	jne    80100790 <cprintf+0xe0>
      if((s = (char*)*argp++) == 0)
80100755:	8b 17                	mov    (%edi),%edx
80100757:	8d 47 04             	lea    0x4(%edi),%eax
8010075a:	85 d2                	test   %edx,%edx
8010075c:	0f 85 0e 01 00 00    	jne    80100870 <cprintf+0x1c0>
80100762:	b9 28 00 00 00       	mov    $0x28,%ecx
        s = "(null)";
80100767:	bf 18 77 10 80       	mov    $0x80107718,%edi
8010076c:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010076f:	89 fb                	mov    %edi,%ebx
80100771:	89 f7                	mov    %esi,%edi
80100773:	89 c6                	mov    %eax,%esi
80100775:	0f be c1             	movsbl %cl,%eax
  if(panicked){
80100778:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
8010077e:	85 d2                	test   %edx,%edx
80100780:	0f 84 fe 00 00 00    	je     80100884 <cprintf+0x1d4>
80100786:	fa                   	cli
    for(;;)
80100787:	eb fe                	jmp    80100787 <cprintf+0xd7>
80100789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100790:	83 f9 78             	cmp    $0x78,%ecx
80100793:	0f 85 9f 00 00 00    	jne    80100838 <cprintf+0x188>
      printint(*argp++, 16, 0);
80100799:	8d 47 04             	lea    0x4(%edi),%eax
8010079c:	31 c9                	xor    %ecx,%ecx
8010079e:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007a3:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
801007a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007a9:	8b 07                	mov    (%edi),%eax
801007ab:	e8 70 fe ff ff       	call   80100620 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007b0:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
801007b4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007b7:	85 c0                	test   %eax,%eax
801007b9:	0f 85 24 ff ff ff    	jne    801006e3 <cprintf+0x33>
801007bf:	e9 75 ff ff ff       	jmp    80100739 <cprintf+0x89>
801007c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007c8:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007ce:	85 c9                	test   %ecx,%ecx
801007d0:	74 15                	je     801007e7 <cprintf+0x137>
801007d2:	fa                   	cli
    for(;;)
801007d3:	eb fe                	jmp    801007d3 <cprintf+0x123>
801007d5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007d8:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007de:	85 c9                	test   %ecx,%ecx
801007e0:	75 7e                	jne    80100860 <cprintf+0x1b0>
801007e2:	b8 25 00 00 00       	mov    $0x25,%eax
801007e7:	e8 14 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007ec:	83 c3 01             	add    $0x1,%ebx
801007ef:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007f3:	85 c0                	test   %eax,%eax
801007f5:	0f 85 e8 fe ff ff    	jne    801006e3 <cprintf+0x33>
801007fb:	e9 39 ff ff ff       	jmp    80100739 <cprintf+0x89>
    acquire(&cons.lock);
80100800:	83 ec 0c             	sub    $0xc,%esp
80100803:	68 20 ff 10 80       	push   $0x8010ff20
80100808:	e8 03 3f 00 00       	call   80104710 <acquire>
  if (fmt == 0)
8010080d:	83 c4 10             	add    $0x10,%esp
80100810:	85 f6                	test   %esi,%esi
80100812:	0f 84 9a 00 00 00    	je     801008b2 <cprintf+0x202>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100818:	0f b6 06             	movzbl (%esi),%eax
8010081b:	85 c0                	test   %eax,%eax
8010081d:	0f 85 b6 fe ff ff    	jne    801006d9 <cprintf+0x29>
    release(&cons.lock);
80100823:	83 ec 0c             	sub    $0xc,%esp
80100826:	68 20 ff 10 80       	push   $0x8010ff20
8010082b:	e8 20 40 00 00       	call   80104850 <release>
80100830:	83 c4 10             	add    $0x10,%esp
80100833:	e9 0c ff ff ff       	jmp    80100744 <cprintf+0x94>
  if(panicked){
80100838:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
8010083e:	85 d2                	test   %edx,%edx
80100840:	75 26                	jne    80100868 <cprintf+0x1b8>
80100842:	b8 25 00 00 00       	mov    $0x25,%eax
80100847:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010084a:	e8 b1 fb ff ff       	call   80100400 <consputc.part.0>
8010084f:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100854:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80100857:	85 c0                	test   %eax,%eax
80100859:	74 4b                	je     801008a6 <cprintf+0x1f6>
8010085b:	fa                   	cli
    for(;;)
8010085c:	eb fe                	jmp    8010085c <cprintf+0x1ac>
8010085e:	66 90                	xchg   %ax,%ax
80100860:	fa                   	cli
80100861:	eb fe                	jmp    80100861 <cprintf+0x1b1>
80100863:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100867:	90                   	nop
80100868:	fa                   	cli
80100869:	eb fe                	jmp    80100869 <cprintf+0x1b9>
8010086b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010086f:	90                   	nop
      for(; *s; s++)
80100870:	0f b6 0a             	movzbl (%edx),%ecx
      if((s = (char*)*argp++) == 0)
80100873:	89 d7                	mov    %edx,%edi
      for(; *s; s++)
80100875:	84 c9                	test   %cl,%cl
80100877:	0f 85 ef fe ff ff    	jne    8010076c <cprintf+0xbc>
      if((s = (char*)*argp++) == 0)
8010087d:	89 c7                	mov    %eax,%edi
8010087f:	e9 aa fe ff ff       	jmp    8010072e <cprintf+0x7e>
80100884:	e8 77 fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100889:	0f be 43 01          	movsbl 0x1(%ebx),%eax
8010088d:	83 c3 01             	add    $0x1,%ebx
80100890:	84 c0                	test   %al,%al
80100892:	0f 85 e0 fe ff ff    	jne    80100778 <cprintf+0xc8>
      if((s = (char*)*argp++) == 0)
80100898:	89 f0                	mov    %esi,%eax
8010089a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010089d:	89 fe                	mov    %edi,%esi
8010089f:	89 c7                	mov    %eax,%edi
801008a1:	e9 88 fe ff ff       	jmp    8010072e <cprintf+0x7e>
801008a6:	89 c8                	mov    %ecx,%eax
801008a8:	e8 53 fb ff ff       	call   80100400 <consputc.part.0>
801008ad:	e9 7c fe ff ff       	jmp    8010072e <cprintf+0x7e>
    panic("null fmt");
801008b2:	83 ec 0c             	sub    $0xc,%esp
801008b5:	68 1f 77 10 80       	push   $0x8010771f
801008ba:	e8 c1 fa ff ff       	call   80100380 <panic>
801008bf:	90                   	nop

801008c0 <consoleintr>:
{
801008c0:	55                   	push   %ebp
801008c1:	89 e5                	mov    %esp,%ebp
801008c3:	57                   	push   %edi
801008c4:	56                   	push   %esi
  int c, doprocdump = 0;
801008c5:	31 f6                	xor    %esi,%esi
{
801008c7:	53                   	push   %ebx
801008c8:	83 ec 18             	sub    $0x18,%esp
801008cb:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
801008ce:	68 20 ff 10 80       	push   $0x8010ff20
801008d3:	e8 38 3e 00 00       	call   80104710 <acquire>
  while((c = getc()) >= 0){
801008d8:	83 c4 10             	add    $0x10,%esp
801008db:	eb 1a                	jmp    801008f7 <consoleintr+0x37>
801008dd:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008e0:	83 fb 08             	cmp    $0x8,%ebx
801008e3:	0f 84 d7 00 00 00    	je     801009c0 <consoleintr+0x100>
801008e9:	83 fb 10             	cmp    $0x10,%ebx
801008ec:	0f 85 2d 01 00 00    	jne    80100a1f <consoleintr+0x15f>
801008f2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008f7:	ff d7                	call   *%edi
801008f9:	89 c3                	mov    %eax,%ebx
801008fb:	85 c0                	test   %eax,%eax
801008fd:	0f 88 e5 00 00 00    	js     801009e8 <consoleintr+0x128>
    switch(c){
80100903:	83 fb 15             	cmp    $0x15,%ebx
80100906:	74 7a                	je     80100982 <consoleintr+0xc2>
80100908:	7e d6                	jle    801008e0 <consoleintr+0x20>
8010090a:	83 fb 7f             	cmp    $0x7f,%ebx
8010090d:	0f 84 ad 00 00 00    	je     801009c0 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100913:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100918:	89 c2                	mov    %eax,%edx
8010091a:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
80100920:	83 fa 7f             	cmp    $0x7f,%edx
80100923:	77 d2                	ja     801008f7 <consoleintr+0x37>
  if(panicked){
80100925:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
8010092b:	8d 48 01             	lea    0x1(%eax),%ecx
8010092e:	83 e0 7f             	and    $0x7f,%eax
80100931:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
80100937:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  if(panicked){
8010093d:	85 d2                	test   %edx,%edx
8010093f:	0f 85 47 01 00 00    	jne    80100a8c <consoleintr+0x1cc>
80100945:	89 d8                	mov    %ebx,%eax
80100947:	e8 b4 fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010094c:	83 fb 0a             	cmp    $0xa,%ebx
8010094f:	0f 84 18 01 00 00    	je     80100a6d <consoleintr+0x1ad>
80100955:	83 fb 04             	cmp    $0x4,%ebx
80100958:	0f 84 0f 01 00 00    	je     80100a6d <consoleintr+0x1ad>
8010095e:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80100963:	83 e8 80             	sub    $0xffffff80,%eax
80100966:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
8010096c:	75 89                	jne    801008f7 <consoleintr+0x37>
8010096e:	e9 ff 00 00 00       	jmp    80100a72 <consoleintr+0x1b2>
80100973:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100977:	90                   	nop
80100978:	b8 00 01 00 00       	mov    $0x100,%eax
8010097d:	e8 7e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
80100982:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100987:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010098d:	0f 84 64 ff ff ff    	je     801008f7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100993:	83 e8 01             	sub    $0x1,%eax
80100996:	89 c2                	mov    %eax,%edx
80100998:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
8010099b:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
801009a2:	0f 84 4f ff ff ff    	je     801008f7 <consoleintr+0x37>
  if(panicked){
801009a8:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
801009ae:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
801009b3:	85 d2                	test   %edx,%edx
801009b5:	74 c1                	je     80100978 <consoleintr+0xb8>
801009b7:	fa                   	cli
    for(;;)
801009b8:	eb fe                	jmp    801009b8 <consoleintr+0xf8>
801009ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(input.e != input.w){
801009c0:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009c5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009cb:	0f 84 26 ff ff ff    	je     801008f7 <consoleintr+0x37>
        input.e--;
801009d1:	83 e8 01             	sub    $0x1,%eax
801009d4:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
801009d9:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
801009de:	85 c0                	test   %eax,%eax
801009e0:	74 22                	je     80100a04 <consoleintr+0x144>
801009e2:	fa                   	cli
    for(;;)
801009e3:	eb fe                	jmp    801009e3 <consoleintr+0x123>
801009e5:	8d 76 00             	lea    0x0(%esi),%esi
  release(&cons.lock);
801009e8:	83 ec 0c             	sub    $0xc,%esp
801009eb:	68 20 ff 10 80       	push   $0x8010ff20
801009f0:	e8 5b 3e 00 00       	call   80104850 <release>
  if(doprocdump) {
801009f5:	83 c4 10             	add    $0x10,%esp
801009f8:	85 f6                	test   %esi,%esi
801009fa:	75 17                	jne    80100a13 <consoleintr+0x153>
}
801009fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009ff:	5b                   	pop    %ebx
80100a00:	5e                   	pop    %esi
80100a01:	5f                   	pop    %edi
80100a02:	5d                   	pop    %ebp
80100a03:	c3                   	ret
80100a04:	b8 00 01 00 00       	mov    $0x100,%eax
80100a09:	e8 f2 f9 ff ff       	call   80100400 <consputc.part.0>
80100a0e:	e9 e4 fe ff ff       	jmp    801008f7 <consoleintr+0x37>
80100a13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a16:	5b                   	pop    %ebx
80100a17:	5e                   	pop    %esi
80100a18:	5f                   	pop    %edi
80100a19:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a1a:	e9 01 3a 00 00       	jmp    80104420 <procdump>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100a1f:	85 db                	test   %ebx,%ebx
80100a21:	0f 84 d0 fe ff ff    	je     801008f7 <consoleintr+0x37>
80100a27:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100a2c:	89 c2                	mov    %eax,%edx
80100a2e:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
80100a34:	83 fa 7f             	cmp    $0x7f,%edx
80100a37:	0f 87 ba fe ff ff    	ja     801008f7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a3d:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
80100a40:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
80100a46:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100a49:	83 fb 0d             	cmp    $0xd,%ebx
80100a4c:	0f 85 df fe ff ff    	jne    80100931 <consoleintr+0x71>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a52:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
80100a58:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
  if(panicked){
80100a5f:	85 d2                	test   %edx,%edx
80100a61:	75 29                	jne    80100a8c <consoleintr+0x1cc>
80100a63:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a68:	e8 93 f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a6d:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a72:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a75:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a7a:	68 00 ff 10 80       	push   $0x8010ff00
80100a7f:	e8 bc 38 00 00       	call   80104340 <wakeup>
80100a84:	83 c4 10             	add    $0x10,%esp
80100a87:	e9 6b fe ff ff       	jmp    801008f7 <consoleintr+0x37>
80100a8c:	fa                   	cli
    for(;;)
80100a8d:	eb fe                	jmp    80100a8d <consoleintr+0x1cd>
80100a8f:	90                   	nop

80100a90 <consoleinit>:

void
consoleinit(void)
{
80100a90:	55                   	push   %ebp
80100a91:	89 e5                	mov    %esp,%ebp
80100a93:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a96:	68 28 77 10 80       	push   $0x80107728
80100a9b:	68 20 ff 10 80       	push   $0x8010ff20
80100aa0:	e8 4b 3b 00 00       	call   801045f0 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100aa5:	c7 05 0c 09 11 80 b0 	movl   $0x801005b0,0x8011090c
80100aac:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100aaf:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100ab6:	02 10 80 
  cons.locking = 1;
80100ab9:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100ac0:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100ac3:	58                   	pop    %eax
80100ac4:	5a                   	pop    %edx
80100ac5:	6a 00                	push   $0x0
80100ac7:	6a 01                	push   $0x1
80100ac9:	e8 32 1a 00 00       	call   80102500 <ioapicenable>
}
80100ace:	83 c4 10             	add    $0x10,%esp
80100ad1:	c9                   	leave
80100ad2:	c3                   	ret
80100ad3:	66 90                	xchg   %ax,%ax
80100ad5:	66 90                	xchg   %ax,%ax
80100ad7:	66 90                	xchg   %ax,%ax
80100ad9:	66 90                	xchg   %ax,%ax
80100adb:	66 90                	xchg   %ax,%ax
80100add:	66 90                	xchg   %ax,%ax
80100adf:	90                   	nop

80100ae0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ae0:	55                   	push   %ebp
80100ae1:	89 e5                	mov    %esp,%ebp
80100ae3:	57                   	push   %edi
80100ae4:	56                   	push   %esi
80100ae5:	53                   	push   %ebx
80100ae6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100aec:	e8 9f 30 00 00       	call   80103b90 <myproc>
80100af1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100af7:	e8 74 24 00 00       	call   80102f70 <begin_op>

  if((ip = namei(path)) == 0){
80100afc:	83 ec 0c             	sub    $0xc,%esp
80100aff:	ff 75 08             	push   0x8(%ebp)
80100b02:	e8 19 16 00 00       	call   80102120 <namei>
80100b07:	83 c4 10             	add    $0x10,%esp
80100b0a:	85 c0                	test   %eax,%eax
80100b0c:	0f 84 30 03 00 00    	je     80100e42 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100b12:	83 ec 0c             	sub    $0xc,%esp
80100b15:	89 c7                	mov    %eax,%edi
80100b17:	50                   	push   %eax
80100b18:	e8 d3 0c 00 00       	call   801017f0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b1d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100b23:	6a 34                	push   $0x34
80100b25:	6a 00                	push   $0x0
80100b27:	50                   	push   %eax
80100b28:	57                   	push   %edi
80100b29:	e8 d2 0f 00 00       	call   80101b00 <readi>
80100b2e:	83 c4 20             	add    $0x20,%esp
80100b31:	83 f8 34             	cmp    $0x34,%eax
80100b34:	0f 85 01 01 00 00    	jne    80100c3b <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b3a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b41:	45 4c 46 
80100b44:	0f 85 f1 00 00 00    	jne    80100c3b <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b4a:	e8 71 65 00 00       	call   801070c0 <setupkvm>
80100b4f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b55:	85 c0                	test   %eax,%eax
80100b57:	0f 84 de 00 00 00    	je     80100c3b <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b5d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b64:	00 
80100b65:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b6b:	0f 84 a1 02 00 00    	je     80100e12 <exec+0x332>
  sz = 0;
80100b71:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b78:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b7b:	31 db                	xor    %ebx,%ebx
80100b7d:	e9 8c 00 00 00       	jmp    80100c0e <exec+0x12e>
80100b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100b88:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b8f:	75 6c                	jne    80100bfd <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80100b91:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b97:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b9d:	0f 82 87 00 00 00    	jb     80100c2a <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ba3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ba9:	72 7f                	jb     80100c2a <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bab:	83 ec 04             	sub    $0x4,%esp
80100bae:	50                   	push   %eax
80100baf:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100bb5:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bbb:	e8 30 63 00 00       	call   80106ef0 <allocuvm>
80100bc0:	83 c4 10             	add    $0x10,%esp
80100bc3:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bc9:	85 c0                	test   %eax,%eax
80100bcb:	74 5d                	je     80100c2a <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100bcd:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bd3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bd8:	75 50                	jne    80100c2a <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bda:	83 ec 0c             	sub    $0xc,%esp
80100bdd:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100be3:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100be9:	57                   	push   %edi
80100bea:	50                   	push   %eax
80100beb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bf1:	e8 2a 62 00 00       	call   80106e20 <loaduvm>
80100bf6:	83 c4 20             	add    $0x20,%esp
80100bf9:	85 c0                	test   %eax,%eax
80100bfb:	78 2d                	js     80100c2a <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bfd:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100c04:	83 c3 01             	add    $0x1,%ebx
80100c07:	83 c6 20             	add    $0x20,%esi
80100c0a:	39 d8                	cmp    %ebx,%eax
80100c0c:	7e 52                	jle    80100c60 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c0e:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c14:	6a 20                	push   $0x20
80100c16:	56                   	push   %esi
80100c17:	50                   	push   %eax
80100c18:	57                   	push   %edi
80100c19:	e8 e2 0e 00 00       	call   80101b00 <readi>
80100c1e:	83 c4 10             	add    $0x10,%esp
80100c21:	83 f8 20             	cmp    $0x20,%eax
80100c24:	0f 84 5e ff ff ff    	je     80100b88 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100c2a:	83 ec 0c             	sub    $0xc,%esp
80100c2d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c33:	e8 08 64 00 00       	call   80107040 <freevm>
  if(ip){
80100c38:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100c3b:	83 ec 0c             	sub    $0xc,%esp
80100c3e:	57                   	push   %edi
80100c3f:	e8 3c 0e 00 00       	call   80101a80 <iunlockput>
    end_op();
80100c44:	e8 97 23 00 00       	call   80102fe0 <end_op>
80100c49:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100c51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c54:	5b                   	pop    %ebx
80100c55:	5e                   	pop    %esi
80100c56:	5f                   	pop    %edi
80100c57:	5d                   	pop    %ebp
80100c58:	c3                   	ret
80100c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80100c60:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c66:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100c6c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c72:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100c78:	83 ec 0c             	sub    $0xc,%esp
80100c7b:	57                   	push   %edi
80100c7c:	e8 ff 0d 00 00       	call   80101a80 <iunlockput>
  end_op();
80100c81:	e8 5a 23 00 00       	call   80102fe0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c86:	83 c4 0c             	add    $0xc,%esp
80100c89:	53                   	push   %ebx
80100c8a:	56                   	push   %esi
80100c8b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c91:	56                   	push   %esi
80100c92:	e8 59 62 00 00       	call   80106ef0 <allocuvm>
80100c97:	83 c4 10             	add    $0x10,%esp
80100c9a:	89 c7                	mov    %eax,%edi
80100c9c:	85 c0                	test   %eax,%eax
80100c9e:	0f 84 86 00 00 00    	je     80100d2a <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ca4:	83 ec 08             	sub    $0x8,%esp
80100ca7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100cad:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100caf:	50                   	push   %eax
80100cb0:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100cb1:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cb3:	e8 a8 64 00 00       	call   80107160 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cbb:	83 c4 10             	add    $0x10,%esp
80100cbe:	8b 10                	mov    (%eax),%edx
80100cc0:	85 d2                	test   %edx,%edx
80100cc2:	0f 84 56 01 00 00    	je     80100e1e <exec+0x33e>
80100cc8:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100cce:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100cd1:	eb 23                	jmp    80100cf6 <exec+0x216>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
80100cd8:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80100cdb:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80100ce2:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100ce8:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100ceb:	85 d2                	test   %edx,%edx
80100ced:	74 51                	je     80100d40 <exec+0x260>
    if(argc >= MAXARG)
80100cef:	83 f8 20             	cmp    $0x20,%eax
80100cf2:	74 36                	je     80100d2a <exec+0x24a>
  for(argc = 0; argv[argc]; argc++) {
80100cf4:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cf6:	83 ec 0c             	sub    $0xc,%esp
80100cf9:	52                   	push   %edx
80100cfa:	e8 91 3d 00 00       	call   80104a90 <strlen>
80100cff:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d01:	58                   	pop    %eax
80100d02:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d05:	83 eb 01             	sub    $0x1,%ebx
80100d08:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d0b:	e8 80 3d 00 00       	call   80104a90 <strlen>
80100d10:	83 c0 01             	add    $0x1,%eax
80100d13:	50                   	push   %eax
80100d14:	ff 34 b7             	push   (%edi,%esi,4)
80100d17:	53                   	push   %ebx
80100d18:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d1e:	e8 ad 68 00 00       	call   801075d0 <copyout>
80100d23:	83 c4 20             	add    $0x20,%esp
80100d26:	85 c0                	test   %eax,%eax
80100d28:	79 ae                	jns    80100cd8 <exec+0x1f8>
    freevm(pgdir);
80100d2a:	83 ec 0c             	sub    $0xc,%esp
80100d2d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d33:	e8 08 63 00 00       	call   80107040 <freevm>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	e9 0c ff ff ff       	jmp    80100c4c <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d40:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80100d47:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d4d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d53:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80100d56:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100d59:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100d60:	00 00 00 00 
  ustack[1] = argc;
80100d64:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
80100d6a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d71:	ff ff ff 
  ustack[1] = argc;
80100d74:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d7a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
80100d7c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d7e:	29 d0                	sub    %edx,%eax
80100d80:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d86:	56                   	push   %esi
80100d87:	51                   	push   %ecx
80100d88:	53                   	push   %ebx
80100d89:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d8f:	e8 3c 68 00 00       	call   801075d0 <copyout>
80100d94:	83 c4 10             	add    $0x10,%esp
80100d97:	85 c0                	test   %eax,%eax
80100d99:	78 8f                	js     80100d2a <exec+0x24a>
  for(last=s=path; *s; s++)
80100d9b:	8b 45 08             	mov    0x8(%ebp),%eax
80100d9e:	8b 55 08             	mov    0x8(%ebp),%edx
80100da1:	0f b6 00             	movzbl (%eax),%eax
80100da4:	84 c0                	test   %al,%al
80100da6:	74 17                	je     80100dbf <exec+0x2df>
80100da8:	89 d1                	mov    %edx,%ecx
80100daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80100db0:	83 c1 01             	add    $0x1,%ecx
80100db3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100db5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100db8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100dbb:	84 c0                	test   %al,%al
80100dbd:	75 f1                	jne    80100db0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100dbf:	83 ec 04             	sub    $0x4,%esp
80100dc2:	6a 10                	push   $0x10
80100dc4:	52                   	push   %edx
80100dc5:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100dcb:	8d 46 6c             	lea    0x6c(%esi),%eax
80100dce:	50                   	push   %eax
80100dcf:	e8 7c 3c 00 00       	call   80104a50 <safestrcpy>
  curproc->pgdir = pgdir;
80100dd4:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dda:	89 f0                	mov    %esi,%eax
80100ddc:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
80100ddf:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80100de1:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100de4:	89 c1                	mov    %eax,%ecx
80100de6:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dec:	8b 40 18             	mov    0x18(%eax),%eax
80100def:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100df2:	8b 41 18             	mov    0x18(%ecx),%eax
80100df5:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100df8:	89 0c 24             	mov    %ecx,(%esp)
80100dfb:	e8 90 5e 00 00       	call   80106c90 <switchuvm>
  freevm(oldpgdir);
80100e00:	89 34 24             	mov    %esi,(%esp)
80100e03:	e8 38 62 00 00       	call   80107040 <freevm>
  return 0;
80100e08:	83 c4 10             	add    $0x10,%esp
80100e0b:	31 c0                	xor    %eax,%eax
80100e0d:	e9 3f fe ff ff       	jmp    80100c51 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e12:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100e17:	31 f6                	xor    %esi,%esi
80100e19:	e9 5a fe ff ff       	jmp    80100c78 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
80100e1e:	be 10 00 00 00       	mov    $0x10,%esi
80100e23:	ba 04 00 00 00       	mov    $0x4,%edx
80100e28:	b8 03 00 00 00       	mov    $0x3,%eax
80100e2d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e34:	00 00 00 
80100e37:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100e3d:	e9 17 ff ff ff       	jmp    80100d59 <exec+0x279>
    end_op();
80100e42:	e8 99 21 00 00       	call   80102fe0 <end_op>
    cprintf("exec: fail\n");
80100e47:	83 ec 0c             	sub    $0xc,%esp
80100e4a:	68 41 77 10 80       	push   $0x80107741
80100e4f:	e8 5c f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100e54:	83 c4 10             	add    $0x10,%esp
80100e57:	e9 f0 fd ff ff       	jmp    80100c4c <exec+0x16c>
80100e5c:	66 90                	xchg   %ax,%ax
80100e5e:	66 90                	xchg   %ax,%ax

80100e60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e60:	55                   	push   %ebp
80100e61:	89 e5                	mov    %esp,%ebp
80100e63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e66:	68 4d 77 10 80       	push   $0x8010774d
80100e6b:	68 60 ff 10 80       	push   $0x8010ff60
80100e70:	e8 7b 37 00 00       	call   801045f0 <initlock>
}
80100e75:	83 c4 10             	add    $0x10,%esp
80100e78:	c9                   	leave
80100e79:	c3                   	ret
80100e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e80:	55                   	push   %ebp
80100e81:	89 e5                	mov    %esp,%ebp
80100e83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e84:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e8c:	68 60 ff 10 80       	push   $0x8010ff60
80100e91:	e8 7a 38 00 00       	call   80104710 <acquire>
80100e96:	83 c4 10             	add    $0x10,%esp
80100e99:	eb 10                	jmp    80100eab <filealloc+0x2b>
80100e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e9f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ea0:	83 c3 18             	add    $0x18,%ebx
80100ea3:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100ea9:	74 25                	je     80100ed0 <filealloc+0x50>
    if(f->ref == 0){
80100eab:	8b 43 04             	mov    0x4(%ebx),%eax
80100eae:	85 c0                	test   %eax,%eax
80100eb0:	75 ee                	jne    80100ea0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100eb2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100eb5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100ebc:	68 60 ff 10 80       	push   $0x8010ff60
80100ec1:	e8 8a 39 00 00       	call   80104850 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ec6:	89 d8                	mov    %ebx,%eax
      return f;
80100ec8:	83 c4 10             	add    $0x10,%esp
}
80100ecb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ece:	c9                   	leave
80100ecf:	c3                   	ret
  release(&ftable.lock);
80100ed0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ed3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ed5:	68 60 ff 10 80       	push   $0x8010ff60
80100eda:	e8 71 39 00 00       	call   80104850 <release>
}
80100edf:	89 d8                	mov    %ebx,%eax
  return 0;
80100ee1:	83 c4 10             	add    $0x10,%esp
}
80100ee4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ee7:	c9                   	leave
80100ee8:	c3                   	ret
80100ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	53                   	push   %ebx
80100ef4:	83 ec 10             	sub    $0x10,%esp
80100ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100efa:	68 60 ff 10 80       	push   $0x8010ff60
80100eff:	e8 0c 38 00 00       	call   80104710 <acquire>
  if(f->ref < 1)
80100f04:	8b 43 04             	mov    0x4(%ebx),%eax
80100f07:	83 c4 10             	add    $0x10,%esp
80100f0a:	85 c0                	test   %eax,%eax
80100f0c:	7e 1a                	jle    80100f28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f17:	68 60 ff 10 80       	push   $0x8010ff60
80100f1c:	e8 2f 39 00 00       	call   80104850 <release>
  return f;
}
80100f21:	89 d8                	mov    %ebx,%eax
80100f23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f26:	c9                   	leave
80100f27:	c3                   	ret
    panic("filedup");
80100f28:	83 ec 0c             	sub    $0xc,%esp
80100f2b:	68 54 77 10 80       	push   $0x80107754
80100f30:	e8 4b f4 ff ff       	call   80100380 <panic>
80100f35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	57                   	push   %edi
80100f44:	56                   	push   %esi
80100f45:	53                   	push   %ebx
80100f46:	83 ec 28             	sub    $0x28,%esp
80100f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f4c:	68 60 ff 10 80       	push   $0x8010ff60
80100f51:	e8 ba 37 00 00       	call   80104710 <acquire>
  if(f->ref < 1)
80100f56:	8b 53 04             	mov    0x4(%ebx),%edx
80100f59:	83 c4 10             	add    $0x10,%esp
80100f5c:	85 d2                	test   %edx,%edx
80100f5e:	0f 8e a5 00 00 00    	jle    80101009 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f64:	83 ea 01             	sub    $0x1,%edx
80100f67:	89 53 04             	mov    %edx,0x4(%ebx)
80100f6a:	75 44                	jne    80100fb0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f6c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f70:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f73:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f75:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f7b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f7e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f81:	8b 43 10             	mov    0x10(%ebx),%eax
80100f84:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f87:	68 60 ff 10 80       	push   $0x8010ff60
80100f8c:	e8 bf 38 00 00       	call   80104850 <release>

  if(ff.type == FD_PIPE)
80100f91:	83 c4 10             	add    $0x10,%esp
80100f94:	83 ff 01             	cmp    $0x1,%edi
80100f97:	74 57                	je     80100ff0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f99:	83 ff 02             	cmp    $0x2,%edi
80100f9c:	74 2a                	je     80100fc8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fa1:	5b                   	pop    %ebx
80100fa2:	5e                   	pop    %esi
80100fa3:	5f                   	pop    %edi
80100fa4:	5d                   	pop    %ebp
80100fa5:	c3                   	ret
80100fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fad:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100fb0:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100fb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fba:	5b                   	pop    %ebx
80100fbb:	5e                   	pop    %esi
80100fbc:	5f                   	pop    %edi
80100fbd:	5d                   	pop    %ebp
    release(&ftable.lock);
80100fbe:	e9 8d 38 00 00       	jmp    80104850 <release>
80100fc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100fc7:	90                   	nop
    begin_op();
80100fc8:	e8 a3 1f 00 00       	call   80102f70 <begin_op>
    iput(ff.ip);
80100fcd:	83 ec 0c             	sub    $0xc,%esp
80100fd0:	ff 75 e0             	push   -0x20(%ebp)
80100fd3:	e8 48 09 00 00       	call   80101920 <iput>
    end_op();
80100fd8:	83 c4 10             	add    $0x10,%esp
}
80100fdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fde:	5b                   	pop    %ebx
80100fdf:	5e                   	pop    %esi
80100fe0:	5f                   	pop    %edi
80100fe1:	5d                   	pop    %ebp
    end_op();
80100fe2:	e9 f9 1f 00 00       	jmp    80102fe0 <end_op>
80100fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fee:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100ff0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ff4:	83 ec 08             	sub    $0x8,%esp
80100ff7:	53                   	push   %ebx
80100ff8:	56                   	push   %esi
80100ff9:	e8 32 27 00 00       	call   80103730 <pipeclose>
80100ffe:	83 c4 10             	add    $0x10,%esp
}
80101001:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101004:	5b                   	pop    %ebx
80101005:	5e                   	pop    %esi
80101006:	5f                   	pop    %edi
80101007:	5d                   	pop    %ebp
80101008:	c3                   	ret
    panic("fileclose");
80101009:	83 ec 0c             	sub    $0xc,%esp
8010100c:	68 5c 77 10 80       	push   $0x8010775c
80101011:	e8 6a f3 ff ff       	call   80100380 <panic>
80101016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010101d:	8d 76 00             	lea    0x0(%esi),%esi

80101020 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	53                   	push   %ebx
80101024:	83 ec 04             	sub    $0x4,%esp
80101027:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010102a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010102d:	75 31                	jne    80101060 <filestat+0x40>
    ilock(f->ip);
8010102f:	83 ec 0c             	sub    $0xc,%esp
80101032:	ff 73 10             	push   0x10(%ebx)
80101035:	e8 b6 07 00 00       	call   801017f0 <ilock>
    stati(f->ip, st);
8010103a:	58                   	pop    %eax
8010103b:	5a                   	pop    %edx
8010103c:	ff 75 0c             	push   0xc(%ebp)
8010103f:	ff 73 10             	push   0x10(%ebx)
80101042:	e8 89 0a 00 00       	call   80101ad0 <stati>
    iunlock(f->ip);
80101047:	59                   	pop    %ecx
80101048:	ff 73 10             	push   0x10(%ebx)
8010104b:	e8 80 08 00 00       	call   801018d0 <iunlock>
    return 0;
  }
  return -1;
}
80101050:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101053:	83 c4 10             	add    $0x10,%esp
80101056:	31 c0                	xor    %eax,%eax
}
80101058:	c9                   	leave
80101059:	c3                   	ret
8010105a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101060:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101063:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101068:	c9                   	leave
80101069:	c3                   	ret
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101070 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101070:	55                   	push   %ebp
80101071:	89 e5                	mov    %esp,%ebp
80101073:	57                   	push   %edi
80101074:	56                   	push   %esi
80101075:	53                   	push   %ebx
80101076:	83 ec 0c             	sub    $0xc,%esp
80101079:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010107c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010107f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101082:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101086:	74 60                	je     801010e8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101088:	8b 03                	mov    (%ebx),%eax
8010108a:	83 f8 01             	cmp    $0x1,%eax
8010108d:	74 41                	je     801010d0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010108f:	83 f8 02             	cmp    $0x2,%eax
80101092:	75 5b                	jne    801010ef <fileread+0x7f>
    ilock(f->ip);
80101094:	83 ec 0c             	sub    $0xc,%esp
80101097:	ff 73 10             	push   0x10(%ebx)
8010109a:	e8 51 07 00 00       	call   801017f0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010109f:	57                   	push   %edi
801010a0:	ff 73 14             	push   0x14(%ebx)
801010a3:	56                   	push   %esi
801010a4:	ff 73 10             	push   0x10(%ebx)
801010a7:	e8 54 0a 00 00       	call   80101b00 <readi>
801010ac:	83 c4 20             	add    $0x20,%esp
801010af:	89 c6                	mov    %eax,%esi
801010b1:	85 c0                	test   %eax,%eax
801010b3:	7e 03                	jle    801010b8 <fileread+0x48>
      f->off += r;
801010b5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010b8:	83 ec 0c             	sub    $0xc,%esp
801010bb:	ff 73 10             	push   0x10(%ebx)
801010be:	e8 0d 08 00 00       	call   801018d0 <iunlock>
    return r;
801010c3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801010c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c9:	89 f0                	mov    %esi,%eax
801010cb:	5b                   	pop    %ebx
801010cc:	5e                   	pop    %esi
801010cd:	5f                   	pop    %edi
801010ce:	5d                   	pop    %ebp
801010cf:	c3                   	ret
    return piperead(f->pipe, addr, n);
801010d0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010d3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d9:	5b                   	pop    %ebx
801010da:	5e                   	pop    %esi
801010db:	5f                   	pop    %edi
801010dc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010dd:	e9 0e 28 00 00       	jmp    801038f0 <piperead>
801010e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010e8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010ed:	eb d7                	jmp    801010c6 <fileread+0x56>
  panic("fileread");
801010ef:	83 ec 0c             	sub    $0xc,%esp
801010f2:	68 66 77 10 80       	push   $0x80107766
801010f7:	e8 84 f2 ff ff       	call   80100380 <panic>
801010fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101100 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	56                   	push   %esi
80101105:	53                   	push   %ebx
80101106:	83 ec 1c             	sub    $0x1c,%esp
80101109:	8b 45 0c             	mov    0xc(%ebp),%eax
8010110c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010110f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101112:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101115:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101119:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010111c:	0f 84 bb 00 00 00    	je     801011dd <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
80101122:	8b 03                	mov    (%ebx),%eax
80101124:	83 f8 01             	cmp    $0x1,%eax
80101127:	0f 84 bf 00 00 00    	je     801011ec <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010112d:	83 f8 02             	cmp    $0x2,%eax
80101130:	0f 85 c8 00 00 00    	jne    801011fe <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101136:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101139:	31 f6                	xor    %esi,%esi
    while(i < n){
8010113b:	85 c0                	test   %eax,%eax
8010113d:	7f 30                	jg     8010116f <filewrite+0x6f>
8010113f:	e9 94 00 00 00       	jmp    801011d8 <filewrite+0xd8>
80101144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101148:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010114b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
8010114e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101151:	ff 73 10             	push   0x10(%ebx)
80101154:	e8 77 07 00 00       	call   801018d0 <iunlock>
      end_op();
80101159:	e8 82 1e 00 00       	call   80102fe0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010115e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101161:	83 c4 10             	add    $0x10,%esp
80101164:	39 c7                	cmp    %eax,%edi
80101166:	75 5c                	jne    801011c4 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101168:	01 fe                	add    %edi,%esi
    while(i < n){
8010116a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010116d:	7e 69                	jle    801011d8 <filewrite+0xd8>
      int n1 = n - i;
8010116f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80101172:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80101177:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80101179:	39 c7                	cmp    %eax,%edi
8010117b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010117e:	e8 ed 1d 00 00       	call   80102f70 <begin_op>
      ilock(f->ip);
80101183:	83 ec 0c             	sub    $0xc,%esp
80101186:	ff 73 10             	push   0x10(%ebx)
80101189:	e8 62 06 00 00       	call   801017f0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010118e:	57                   	push   %edi
8010118f:	ff 73 14             	push   0x14(%ebx)
80101192:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101195:	01 f0                	add    %esi,%eax
80101197:	50                   	push   %eax
80101198:	ff 73 10             	push   0x10(%ebx)
8010119b:	e8 60 0a 00 00       	call   80101c00 <writei>
801011a0:	83 c4 20             	add    $0x20,%esp
801011a3:	85 c0                	test   %eax,%eax
801011a5:	7f a1                	jg     80101148 <filewrite+0x48>
801011a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801011aa:	83 ec 0c             	sub    $0xc,%esp
801011ad:	ff 73 10             	push   0x10(%ebx)
801011b0:	e8 1b 07 00 00       	call   801018d0 <iunlock>
      end_op();
801011b5:	e8 26 1e 00 00       	call   80102fe0 <end_op>
      if(r < 0)
801011ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011bd:	83 c4 10             	add    $0x10,%esp
801011c0:	85 c0                	test   %eax,%eax
801011c2:	75 14                	jne    801011d8 <filewrite+0xd8>
        panic("short filewrite");
801011c4:	83 ec 0c             	sub    $0xc,%esp
801011c7:	68 6f 77 10 80       	push   $0x8010776f
801011cc:	e8 af f1 ff ff       	call   80100380 <panic>
801011d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801011d8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801011db:	74 05                	je     801011e2 <filewrite+0xe2>
    return -1;
801011dd:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
801011e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011e5:	89 f0                	mov    %esi,%eax
801011e7:	5b                   	pop    %ebx
801011e8:	5e                   	pop    %esi
801011e9:	5f                   	pop    %edi
801011ea:	5d                   	pop    %ebp
801011eb:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
801011ec:	8b 43 0c             	mov    0xc(%ebx),%eax
801011ef:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011f5:	5b                   	pop    %ebx
801011f6:	5e                   	pop    %esi
801011f7:	5f                   	pop    %edi
801011f8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011f9:	e9 d2 25 00 00       	jmp    801037d0 <pipewrite>
  panic("filewrite");
801011fe:	83 ec 0c             	sub    $0xc,%esp
80101201:	68 75 77 10 80       	push   $0x80107775
80101206:	e8 75 f1 ff ff       	call   80100380 <panic>
8010120b:	66 90                	xchg   %ax,%ax
8010120d:	66 90                	xchg   %ax,%ax
8010120f:	90                   	nop

80101210 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	57                   	push   %edi
80101214:	56                   	push   %esi
80101215:	53                   	push   %ebx
80101216:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101219:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
8010121f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101222:	85 c9                	test   %ecx,%ecx
80101224:	0f 84 8c 00 00 00    	je     801012b6 <balloc+0xa6>
8010122a:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
8010122c:	89 f8                	mov    %edi,%eax
8010122e:	83 ec 08             	sub    $0x8,%esp
80101231:	89 fe                	mov    %edi,%esi
80101233:	c1 f8 0c             	sar    $0xc,%eax
80101236:	03 05 cc 25 11 80    	add    0x801125cc,%eax
8010123c:	50                   	push   %eax
8010123d:	ff 75 dc             	push   -0x24(%ebp)
80101240:	e8 8b ee ff ff       	call   801000d0 <bread>
80101245:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101248:	83 c4 10             	add    $0x10,%esp
8010124b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010124e:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101253:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101256:	31 c0                	xor    %eax,%eax
80101258:	eb 32                	jmp    8010128c <balloc+0x7c>
8010125a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101260:	89 c1                	mov    %eax,%ecx
80101262:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101267:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
8010126a:	83 e1 07             	and    $0x7,%ecx
8010126d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010126f:	89 c1                	mov    %eax,%ecx
80101271:	c1 f9 03             	sar    $0x3,%ecx
80101274:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80101279:	89 fa                	mov    %edi,%edx
8010127b:	85 df                	test   %ebx,%edi
8010127d:	74 49                	je     801012c8 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010127f:	83 c0 01             	add    $0x1,%eax
80101282:	83 c6 01             	add    $0x1,%esi
80101285:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010128a:	74 07                	je     80101293 <balloc+0x83>
8010128c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010128f:	39 d6                	cmp    %edx,%esi
80101291:	72 cd                	jb     80101260 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101293:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101296:	83 ec 0c             	sub    $0xc,%esp
80101299:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010129c:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
801012a2:	e8 49 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012a7:	83 c4 10             	add    $0x10,%esp
801012aa:	3b 3d b4 25 11 80    	cmp    0x801125b4,%edi
801012b0:	0f 82 76 ff ff ff    	jb     8010122c <balloc+0x1c>
  }
  panic("balloc: out of blocks");
801012b6:	83 ec 0c             	sub    $0xc,%esp
801012b9:	68 7f 77 10 80       	push   $0x8010777f
801012be:	e8 bd f0 ff ff       	call   80100380 <panic>
801012c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012c7:	90                   	nop
        bp->data[bi/8] |= m;  // Mark block in use.
801012c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012cb:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012ce:	09 da                	or     %ebx,%edx
801012d0:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012d4:	57                   	push   %edi
801012d5:	e8 76 1e 00 00       	call   80103150 <log_write>
        brelse(bp);
801012da:	89 3c 24             	mov    %edi,(%esp)
801012dd:	e8 0e ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012e2:	58                   	pop    %eax
801012e3:	5a                   	pop    %edx
801012e4:	56                   	push   %esi
801012e5:	ff 75 dc             	push   -0x24(%ebp)
801012e8:	e8 e3 ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801012ed:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801012f0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012f2:	8d 40 5c             	lea    0x5c(%eax),%eax
801012f5:	68 00 02 00 00       	push   $0x200
801012fa:	6a 00                	push   $0x0
801012fc:	50                   	push   %eax
801012fd:	e8 9e 35 00 00       	call   801048a0 <memset>
  log_write(bp);
80101302:	89 1c 24             	mov    %ebx,(%esp)
80101305:	e8 46 1e 00 00       	call   80103150 <log_write>
  brelse(bp);
8010130a:	89 1c 24             	mov    %ebx,(%esp)
8010130d:	e8 de ee ff ff       	call   801001f0 <brelse>
}
80101312:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101315:	89 f0                	mov    %esi,%eax
80101317:	5b                   	pop    %ebx
80101318:	5e                   	pop    %esi
80101319:	5f                   	pop    %edi
8010131a:	5d                   	pop    %ebp
8010131b:	c3                   	ret
8010131c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101320 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101320:	55                   	push   %ebp
80101321:	89 e5                	mov    %esp,%ebp
80101323:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101324:	31 ff                	xor    %edi,%edi
{
80101326:	56                   	push   %esi
80101327:	89 c6                	mov    %eax,%esi
80101329:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010132a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010132f:	83 ec 28             	sub    $0x28,%esp
80101332:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101335:	68 60 09 11 80       	push   $0x80110960
8010133a:	e8 d1 33 00 00       	call   80104710 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010133f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101342:	83 c4 10             	add    $0x10,%esp
80101345:	eb 1b                	jmp    80101362 <iget+0x42>
80101347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101350:	39 33                	cmp    %esi,(%ebx)
80101352:	74 6c                	je     801013c0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101354:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010135a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101360:	74 26                	je     80101388 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101362:	8b 43 08             	mov    0x8(%ebx),%eax
80101365:	85 c0                	test   %eax,%eax
80101367:	7f e7                	jg     80101350 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101369:	85 ff                	test   %edi,%edi
8010136b:	75 e7                	jne    80101354 <iget+0x34>
8010136d:	85 c0                	test   %eax,%eax
8010136f:	75 76                	jne    801013e7 <iget+0xc7>
80101371:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101373:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101379:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
8010137f:	75 e1                	jne    80101362 <iget+0x42>
80101381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101388:	85 ff                	test   %edi,%edi
8010138a:	74 79                	je     80101405 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010138c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010138f:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80101391:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80101394:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
8010139b:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
801013a2:	68 60 09 11 80       	push   $0x80110960
801013a7:	e8 a4 34 00 00       	call   80104850 <release>

  return ip;
801013ac:	83 c4 10             	add    $0x10,%esp
}
801013af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013b2:	89 f8                	mov    %edi,%eax
801013b4:	5b                   	pop    %ebx
801013b5:	5e                   	pop    %esi
801013b6:	5f                   	pop    %edi
801013b7:	5d                   	pop    %ebp
801013b8:	c3                   	ret
801013b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013c0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013c3:	75 8f                	jne    80101354 <iget+0x34>
      ip->ref++;
801013c5:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
801013c8:	83 ec 0c             	sub    $0xc,%esp
      return ip;
801013cb:	89 df                	mov    %ebx,%edi
      ip->ref++;
801013cd:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801013d0:	68 60 09 11 80       	push   $0x80110960
801013d5:	e8 76 34 00 00       	call   80104850 <release>
      return ip;
801013da:	83 c4 10             	add    $0x10,%esp
}
801013dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e0:	89 f8                	mov    %edi,%eax
801013e2:	5b                   	pop    %ebx
801013e3:	5e                   	pop    %esi
801013e4:	5f                   	pop    %edi
801013e5:	5d                   	pop    %ebp
801013e6:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013e7:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013ed:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013f3:	74 10                	je     80101405 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f5:	8b 43 08             	mov    0x8(%ebx),%eax
801013f8:	85 c0                	test   %eax,%eax
801013fa:	0f 8f 50 ff ff ff    	jg     80101350 <iget+0x30>
80101400:	e9 68 ff ff ff       	jmp    8010136d <iget+0x4d>
    panic("iget: no inodes");
80101405:	83 ec 0c             	sub    $0xc,%esp
80101408:	68 95 77 10 80       	push   $0x80107795
8010140d:	e8 6e ef ff ff       	call   80100380 <panic>
80101412:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101420 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101420:	55                   	push   %ebp
80101421:	89 e5                	mov    %esp,%ebp
80101423:	57                   	push   %edi
80101424:	56                   	push   %esi
80101425:	89 c6                	mov    %eax,%esi
80101427:	53                   	push   %ebx
80101428:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010142b:	83 fa 0b             	cmp    $0xb,%edx
8010142e:	0f 86 8c 00 00 00    	jbe    801014c0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101434:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101437:	83 fb 7f             	cmp    $0x7f,%ebx
8010143a:	0f 87 a2 00 00 00    	ja     801014e2 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101440:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101446:	85 c0                	test   %eax,%eax
80101448:	74 5e                	je     801014a8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010144a:	83 ec 08             	sub    $0x8,%esp
8010144d:	50                   	push   %eax
8010144e:	ff 36                	push   (%esi)
80101450:	e8 7b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101455:	83 c4 10             	add    $0x10,%esp
80101458:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010145c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010145e:	8b 3b                	mov    (%ebx),%edi
80101460:	85 ff                	test   %edi,%edi
80101462:	74 1c                	je     80101480 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101464:	83 ec 0c             	sub    $0xc,%esp
80101467:	52                   	push   %edx
80101468:	e8 83 ed ff ff       	call   801001f0 <brelse>
8010146d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101470:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101473:	89 f8                	mov    %edi,%eax
80101475:	5b                   	pop    %ebx
80101476:	5e                   	pop    %esi
80101477:	5f                   	pop    %edi
80101478:	5d                   	pop    %ebp
80101479:	c3                   	ret
8010147a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101480:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101483:	8b 06                	mov    (%esi),%eax
80101485:	e8 86 fd ff ff       	call   80101210 <balloc>
      log_write(bp);
8010148a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010148d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101490:	89 03                	mov    %eax,(%ebx)
80101492:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101494:	52                   	push   %edx
80101495:	e8 b6 1c 00 00       	call   80103150 <log_write>
8010149a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010149d:	83 c4 10             	add    $0x10,%esp
801014a0:	eb c2                	jmp    80101464 <bmap+0x44>
801014a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014a8:	8b 06                	mov    (%esi),%eax
801014aa:	e8 61 fd ff ff       	call   80101210 <balloc>
801014af:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014b5:	eb 93                	jmp    8010144a <bmap+0x2a>
801014b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014be:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801014c0:	8d 5a 14             	lea    0x14(%edx),%ebx
801014c3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801014c7:	85 ff                	test   %edi,%edi
801014c9:	75 a5                	jne    80101470 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014cb:	8b 00                	mov    (%eax),%eax
801014cd:	e8 3e fd ff ff       	call   80101210 <balloc>
801014d2:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
801014d6:	89 c7                	mov    %eax,%edi
}
801014d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014db:	5b                   	pop    %ebx
801014dc:	89 f8                	mov    %edi,%eax
801014de:	5e                   	pop    %esi
801014df:	5f                   	pop    %edi
801014e0:	5d                   	pop    %ebp
801014e1:	c3                   	ret
  panic("bmap: out of range");
801014e2:	83 ec 0c             	sub    $0xc,%esp
801014e5:	68 a5 77 10 80       	push   $0x801077a5
801014ea:	e8 91 ee ff ff       	call   80100380 <panic>
801014ef:	90                   	nop

801014f0 <bfree>:
{
801014f0:	55                   	push   %ebp
801014f1:	89 e5                	mov    %esp,%ebp
801014f3:	57                   	push   %edi
801014f4:	56                   	push   %esi
801014f5:	89 c6                	mov    %eax,%esi
801014f7:	53                   	push   %ebx
801014f8:	89 d3                	mov    %edx,%ebx
801014fa:	83 ec 14             	sub    $0x14,%esp
  bp = bread(dev, 1);
801014fd:	6a 01                	push   $0x1
801014ff:	50                   	push   %eax
80101500:	e8 cb eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101505:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101508:	89 c7                	mov    %eax,%edi
  memmove(sb, bp->data, sizeof(*sb));
8010150a:	83 c0 5c             	add    $0x5c,%eax
8010150d:	6a 1c                	push   $0x1c
8010150f:	50                   	push   %eax
80101510:	68 b4 25 11 80       	push   $0x801125b4
80101515:	e8 16 34 00 00       	call   80104930 <memmove>
  brelse(bp);
8010151a:	89 3c 24             	mov    %edi,(%esp)
8010151d:	e8 ce ec ff ff       	call   801001f0 <brelse>
  bp = bread(dev, BBLOCK(b, sb));
80101522:	58                   	pop    %eax
80101523:	89 d8                	mov    %ebx,%eax
80101525:	5a                   	pop    %edx
80101526:	c1 e8 0c             	shr    $0xc,%eax
80101529:	03 05 cc 25 11 80    	add    0x801125cc,%eax
8010152f:	50                   	push   %eax
80101530:	56                   	push   %esi
80101531:	e8 9a eb ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
80101536:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101538:	c1 fb 03             	sar    $0x3,%ebx
8010153b:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
8010153e:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101540:	83 e1 07             	and    $0x7,%ecx
80101543:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101548:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
8010154e:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101550:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
80101555:	85 c1                	test   %eax,%ecx
80101557:	74 24                	je     8010157d <bfree+0x8d>
  bp->data[bi/8] &= ~m;
80101559:	f7 d0                	not    %eax
  log_write(bp);
8010155b:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
8010155e:	21 c8                	and    %ecx,%eax
80101560:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
80101564:	56                   	push   %esi
80101565:	e8 e6 1b 00 00       	call   80103150 <log_write>
  brelse(bp);
8010156a:	89 34 24             	mov    %esi,(%esp)
8010156d:	e8 7e ec ff ff       	call   801001f0 <brelse>
}
80101572:	83 c4 10             	add    $0x10,%esp
80101575:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101578:	5b                   	pop    %ebx
80101579:	5e                   	pop    %esi
8010157a:	5f                   	pop    %edi
8010157b:	5d                   	pop    %ebp
8010157c:	c3                   	ret
    panic("freeing free block");
8010157d:	83 ec 0c             	sub    $0xc,%esp
80101580:	68 b8 77 10 80       	push   $0x801077b8
80101585:	e8 f6 ed ff ff       	call   80100380 <panic>
8010158a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101590 <readsb>:
{
80101590:	55                   	push   %ebp
80101591:	89 e5                	mov    %esp,%ebp
80101593:	56                   	push   %esi
80101594:	53                   	push   %ebx
80101595:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101598:	83 ec 08             	sub    $0x8,%esp
8010159b:	6a 01                	push   $0x1
8010159d:	ff 75 08             	push   0x8(%ebp)
801015a0:	e8 2b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015a5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015a8:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015aa:	8d 40 5c             	lea    0x5c(%eax),%eax
801015ad:	6a 1c                	push   $0x1c
801015af:	50                   	push   %eax
801015b0:	56                   	push   %esi
801015b1:	e8 7a 33 00 00       	call   80104930 <memmove>
  brelse(bp);
801015b6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801015b9:	83 c4 10             	add    $0x10,%esp
}
801015bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015bf:	5b                   	pop    %ebx
801015c0:	5e                   	pop    %esi
801015c1:	5d                   	pop    %ebp
  brelse(bp);
801015c2:	e9 29 ec ff ff       	jmp    801001f0 <brelse>
801015c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015ce:	66 90                	xchg   %ax,%ax

801015d0 <iinit>:
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	53                   	push   %ebx
801015d4:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
801015d9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801015dc:	68 cb 77 10 80       	push   $0x801077cb
801015e1:	68 60 09 11 80       	push   $0x80110960
801015e6:	e8 05 30 00 00       	call   801045f0 <initlock>
  for(i = 0; i < NINODE; i++) {
801015eb:	83 c4 10             	add    $0x10,%esp
801015ee:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015f0:	83 ec 08             	sub    $0x8,%esp
801015f3:	68 d2 77 10 80       	push   $0x801077d2
801015f8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801015f9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801015ff:	e8 dc 2e 00 00       	call   801044e0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101604:	83 c4 10             	add    $0x10,%esp
80101607:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
8010160d:	75 e1                	jne    801015f0 <iinit+0x20>
  bp = bread(dev, 1);
8010160f:	83 ec 08             	sub    $0x8,%esp
80101612:	6a 01                	push   $0x1
80101614:	ff 75 08             	push   0x8(%ebp)
80101617:	e8 b4 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010161c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010161f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101621:	8d 40 5c             	lea    0x5c(%eax),%eax
80101624:	6a 1c                	push   $0x1c
80101626:	50                   	push   %eax
80101627:	68 b4 25 11 80       	push   $0x801125b4
8010162c:	e8 ff 32 00 00       	call   80104930 <memmove>
  brelse(bp);
80101631:	89 1c 24             	mov    %ebx,(%esp)
80101634:	e8 b7 eb ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101639:	ff 35 cc 25 11 80    	push   0x801125cc
8010163f:	ff 35 c8 25 11 80    	push   0x801125c8
80101645:	ff 35 c4 25 11 80    	push   0x801125c4
8010164b:	ff 35 c0 25 11 80    	push   0x801125c0
80101651:	ff 35 bc 25 11 80    	push   0x801125bc
80101657:	ff 35 b8 25 11 80    	push   0x801125b8
8010165d:	ff 35 b4 25 11 80    	push   0x801125b4
80101663:	68 38 78 10 80       	push   $0x80107838
80101668:	e8 43 f0 ff ff       	call   801006b0 <cprintf>
}
8010166d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101670:	83 c4 30             	add    $0x30,%esp
80101673:	c9                   	leave
80101674:	c3                   	ret
80101675:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <ialloc>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	57                   	push   %edi
80101684:	56                   	push   %esi
80101685:	53                   	push   %ebx
80101686:	83 ec 1c             	sub    $0x1c,%esp
80101689:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010168c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101693:	8b 75 08             	mov    0x8(%ebp),%esi
80101696:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101699:	0f 86 91 00 00 00    	jbe    80101730 <ialloc+0xb0>
8010169f:	bf 01 00 00 00       	mov    $0x1,%edi
801016a4:	eb 21                	jmp    801016c7 <ialloc+0x47>
801016a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016ad:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801016b0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801016b3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
801016b6:	53                   	push   %ebx
801016b7:	e8 34 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801016bc:	83 c4 10             	add    $0x10,%esp
801016bf:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
801016c5:	73 69                	jae    80101730 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801016c7:	89 f8                	mov    %edi,%eax
801016c9:	83 ec 08             	sub    $0x8,%esp
801016cc:	c1 e8 03             	shr    $0x3,%eax
801016cf:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801016d5:	50                   	push   %eax
801016d6:	56                   	push   %esi
801016d7:	e8 f4 e9 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801016dc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801016df:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801016e1:	89 f8                	mov    %edi,%eax
801016e3:	83 e0 07             	and    $0x7,%eax
801016e6:	c1 e0 06             	shl    $0x6,%eax
801016e9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801016ed:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016f1:	75 bd                	jne    801016b0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016f3:	83 ec 04             	sub    $0x4,%esp
801016f6:	6a 40                	push   $0x40
801016f8:	6a 00                	push   $0x0
801016fa:	51                   	push   %ecx
801016fb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016fe:	e8 9d 31 00 00       	call   801048a0 <memset>
      dip->type = type;
80101703:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101707:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010170a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010170d:	89 1c 24             	mov    %ebx,(%esp)
80101710:	e8 3b 1a 00 00       	call   80103150 <log_write>
      brelse(bp);
80101715:	89 1c 24             	mov    %ebx,(%esp)
80101718:	e8 d3 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010171d:	83 c4 10             	add    $0x10,%esp
}
80101720:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101723:	89 fa                	mov    %edi,%edx
}
80101725:	5b                   	pop    %ebx
      return iget(dev, inum);
80101726:	89 f0                	mov    %esi,%eax
}
80101728:	5e                   	pop    %esi
80101729:	5f                   	pop    %edi
8010172a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010172b:	e9 f0 fb ff ff       	jmp    80101320 <iget>
  panic("ialloc: no inodes");
80101730:	83 ec 0c             	sub    $0xc,%esp
80101733:	68 d8 77 10 80       	push   $0x801077d8
80101738:	e8 43 ec ff ff       	call   80100380 <panic>
8010173d:	8d 76 00             	lea    0x0(%esi),%esi

80101740 <iupdate>:
{
80101740:	55                   	push   %ebp
80101741:	89 e5                	mov    %esp,%ebp
80101743:	56                   	push   %esi
80101744:	53                   	push   %ebx
80101745:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101748:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010174b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010174e:	83 ec 08             	sub    $0x8,%esp
80101751:	c1 e8 03             	shr    $0x3,%eax
80101754:	03 05 c8 25 11 80    	add    0x801125c8,%eax
8010175a:	50                   	push   %eax
8010175b:	ff 73 a4             	push   -0x5c(%ebx)
8010175e:	e8 6d e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101763:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101767:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010176a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010176c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010176f:	83 e0 07             	and    $0x7,%eax
80101772:	c1 e0 06             	shl    $0x6,%eax
80101775:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101779:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010177c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101780:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101783:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101787:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010178b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010178f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101793:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101797:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010179a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010179d:	6a 34                	push   $0x34
8010179f:	53                   	push   %ebx
801017a0:	50                   	push   %eax
801017a1:	e8 8a 31 00 00       	call   80104930 <memmove>
  log_write(bp);
801017a6:	89 34 24             	mov    %esi,(%esp)
801017a9:	e8 a2 19 00 00       	call   80103150 <log_write>
  brelse(bp);
801017ae:	89 75 08             	mov    %esi,0x8(%ebp)
801017b1:	83 c4 10             	add    $0x10,%esp
}
801017b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b7:	5b                   	pop    %ebx
801017b8:	5e                   	pop    %esi
801017b9:	5d                   	pop    %ebp
  brelse(bp);
801017ba:	e9 31 ea ff ff       	jmp    801001f0 <brelse>
801017bf:	90                   	nop

801017c0 <idup>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	53                   	push   %ebx
801017c4:	83 ec 10             	sub    $0x10,%esp
801017c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801017ca:	68 60 09 11 80       	push   $0x80110960
801017cf:	e8 3c 2f 00 00       	call   80104710 <acquire>
  ip->ref++;
801017d4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017d8:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801017df:	e8 6c 30 00 00       	call   80104850 <release>
}
801017e4:	89 d8                	mov    %ebx,%eax
801017e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017e9:	c9                   	leave
801017ea:	c3                   	ret
801017eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017ef:	90                   	nop

801017f0 <ilock>:
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	56                   	push   %esi
801017f4:	53                   	push   %ebx
801017f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017f8:	85 db                	test   %ebx,%ebx
801017fa:	0f 84 b7 00 00 00    	je     801018b7 <ilock+0xc7>
80101800:	8b 53 08             	mov    0x8(%ebx),%edx
80101803:	85 d2                	test   %edx,%edx
80101805:	0f 8e ac 00 00 00    	jle    801018b7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010180b:	83 ec 0c             	sub    $0xc,%esp
8010180e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101811:	50                   	push   %eax
80101812:	e8 09 2d 00 00       	call   80104520 <acquiresleep>
  if(ip->valid == 0){
80101817:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010181a:	83 c4 10             	add    $0x10,%esp
8010181d:	85 c0                	test   %eax,%eax
8010181f:	74 0f                	je     80101830 <ilock+0x40>
}
80101821:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101824:	5b                   	pop    %ebx
80101825:	5e                   	pop    %esi
80101826:	5d                   	pop    %ebp
80101827:	c3                   	ret
80101828:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010182f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101830:	8b 43 04             	mov    0x4(%ebx),%eax
80101833:	83 ec 08             	sub    $0x8,%esp
80101836:	c1 e8 03             	shr    $0x3,%eax
80101839:	03 05 c8 25 11 80    	add    0x801125c8,%eax
8010183f:	50                   	push   %eax
80101840:	ff 33                	push   (%ebx)
80101842:	e8 89 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101847:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010184a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010184c:	8b 43 04             	mov    0x4(%ebx),%eax
8010184f:	83 e0 07             	and    $0x7,%eax
80101852:	c1 e0 06             	shl    $0x6,%eax
80101855:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101859:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010185c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010185f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101863:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101867:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010186b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010186f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101873:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101877:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010187b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010187e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101881:	6a 34                	push   $0x34
80101883:	50                   	push   %eax
80101884:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101887:	50                   	push   %eax
80101888:	e8 a3 30 00 00       	call   80104930 <memmove>
    brelse(bp);
8010188d:	89 34 24             	mov    %esi,(%esp)
80101890:	e8 5b e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101895:	83 c4 10             	add    $0x10,%esp
80101898:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010189d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801018a4:	0f 85 77 ff ff ff    	jne    80101821 <ilock+0x31>
      panic("ilock: no type");
801018aa:	83 ec 0c             	sub    $0xc,%esp
801018ad:	68 f0 77 10 80       	push   $0x801077f0
801018b2:	e8 c9 ea ff ff       	call   80100380 <panic>
    panic("ilock");
801018b7:	83 ec 0c             	sub    $0xc,%esp
801018ba:	68 ea 77 10 80       	push   $0x801077ea
801018bf:	e8 bc ea ff ff       	call   80100380 <panic>
801018c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018cf:	90                   	nop

801018d0 <iunlock>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	56                   	push   %esi
801018d4:	53                   	push   %ebx
801018d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801018d8:	85 db                	test   %ebx,%ebx
801018da:	74 28                	je     80101904 <iunlock+0x34>
801018dc:	83 ec 0c             	sub    $0xc,%esp
801018df:	8d 73 0c             	lea    0xc(%ebx),%esi
801018e2:	56                   	push   %esi
801018e3:	e8 d8 2c 00 00       	call   801045c0 <holdingsleep>
801018e8:	83 c4 10             	add    $0x10,%esp
801018eb:	85 c0                	test   %eax,%eax
801018ed:	74 15                	je     80101904 <iunlock+0x34>
801018ef:	8b 43 08             	mov    0x8(%ebx),%eax
801018f2:	85 c0                	test   %eax,%eax
801018f4:	7e 0e                	jle    80101904 <iunlock+0x34>
  releasesleep(&ip->lock);
801018f6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018ff:	e9 7c 2c 00 00       	jmp    80104580 <releasesleep>
    panic("iunlock");
80101904:	83 ec 0c             	sub    $0xc,%esp
80101907:	68 ff 77 10 80       	push   $0x801077ff
8010190c:	e8 6f ea ff ff       	call   80100380 <panic>
80101911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101918:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010191f:	90                   	nop

80101920 <iput>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	57                   	push   %edi
80101924:	56                   	push   %esi
80101925:	53                   	push   %ebx
80101926:	83 ec 28             	sub    $0x28,%esp
80101929:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010192c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010192f:	57                   	push   %edi
80101930:	e8 eb 2b 00 00       	call   80104520 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101935:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101938:	83 c4 10             	add    $0x10,%esp
8010193b:	85 d2                	test   %edx,%edx
8010193d:	74 07                	je     80101946 <iput+0x26>
8010193f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101944:	74 32                	je     80101978 <iput+0x58>
  releasesleep(&ip->lock);
80101946:	83 ec 0c             	sub    $0xc,%esp
80101949:	57                   	push   %edi
8010194a:	e8 31 2c 00 00       	call   80104580 <releasesleep>
  acquire(&icache.lock);
8010194f:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101956:	e8 b5 2d 00 00       	call   80104710 <acquire>
  ip->ref--;
8010195b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010195f:	83 c4 10             	add    $0x10,%esp
80101962:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
80101969:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010196c:	5b                   	pop    %ebx
8010196d:	5e                   	pop    %esi
8010196e:	5f                   	pop    %edi
8010196f:	5d                   	pop    %ebp
  release(&icache.lock);
80101970:	e9 db 2e 00 00       	jmp    80104850 <release>
80101975:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101978:	83 ec 0c             	sub    $0xc,%esp
8010197b:	68 60 09 11 80       	push   $0x80110960
80101980:	e8 8b 2d 00 00       	call   80104710 <acquire>
    int r = ip->ref;
80101985:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101988:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010198f:	e8 bc 2e 00 00       	call   80104850 <release>
    if(r == 1){
80101994:	83 c4 10             	add    $0x10,%esp
80101997:	83 fe 01             	cmp    $0x1,%esi
8010199a:	75 aa                	jne    80101946 <iput+0x26>
8010199c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801019a2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019a5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801019a8:	89 df                	mov    %ebx,%edi
801019aa:	89 cb                	mov    %ecx,%ebx
801019ac:	eb 09                	jmp    801019b7 <iput+0x97>
801019ae:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801019b0:	83 c6 04             	add    $0x4,%esi
801019b3:	39 de                	cmp    %ebx,%esi
801019b5:	74 19                	je     801019d0 <iput+0xb0>
    if(ip->addrs[i]){
801019b7:	8b 16                	mov    (%esi),%edx
801019b9:	85 d2                	test   %edx,%edx
801019bb:	74 f3                	je     801019b0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801019bd:	8b 07                	mov    (%edi),%eax
801019bf:	e8 2c fb ff ff       	call   801014f0 <bfree>
      ip->addrs[i] = 0;
801019c4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801019ca:	eb e4                	jmp    801019b0 <iput+0x90>
801019cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801019d0:	89 fb                	mov    %edi,%ebx
801019d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019d5:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801019db:	85 c0                	test   %eax,%eax
801019dd:	75 2d                	jne    80101a0c <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801019df:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801019e2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801019e9:	53                   	push   %ebx
801019ea:	e8 51 fd ff ff       	call   80101740 <iupdate>
      ip->type = 0;
801019ef:	31 c0                	xor    %eax,%eax
801019f1:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019f5:	89 1c 24             	mov    %ebx,(%esp)
801019f8:	e8 43 fd ff ff       	call   80101740 <iupdate>
      ip->valid = 0;
801019fd:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101a04:	83 c4 10             	add    $0x10,%esp
80101a07:	e9 3a ff ff ff       	jmp    80101946 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a0c:	83 ec 08             	sub    $0x8,%esp
80101a0f:	50                   	push   %eax
80101a10:	ff 33                	push   (%ebx)
80101a12:	e8 b9 e6 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
80101a17:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a1a:	83 c4 10             	add    $0x10,%esp
80101a1d:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a23:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101a26:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a29:	89 cf                	mov    %ecx,%edi
80101a2b:	eb 0a                	jmp    80101a37 <iput+0x117>
80101a2d:	8d 76 00             	lea    0x0(%esi),%esi
80101a30:	83 c6 04             	add    $0x4,%esi
80101a33:	39 fe                	cmp    %edi,%esi
80101a35:	74 0f                	je     80101a46 <iput+0x126>
      if(a[j])
80101a37:	8b 16                	mov    (%esi),%edx
80101a39:	85 d2                	test   %edx,%edx
80101a3b:	74 f3                	je     80101a30 <iput+0x110>
        bfree(ip->dev, a[j]);
80101a3d:	8b 03                	mov    (%ebx),%eax
80101a3f:	e8 ac fa ff ff       	call   801014f0 <bfree>
80101a44:	eb ea                	jmp    80101a30 <iput+0x110>
    brelse(bp);
80101a46:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101a49:	83 ec 0c             	sub    $0xc,%esp
80101a4c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a4f:	50                   	push   %eax
80101a50:	e8 9b e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a55:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a5b:	8b 03                	mov    (%ebx),%eax
80101a5d:	e8 8e fa ff ff       	call   801014f0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a62:	83 c4 10             	add    $0x10,%esp
80101a65:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a6c:	00 00 00 
80101a6f:	e9 6b ff ff ff       	jmp    801019df <iput+0xbf>
80101a74:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a7f:	90                   	nop

80101a80 <iunlockput>:
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	56                   	push   %esi
80101a84:	53                   	push   %ebx
80101a85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a88:	85 db                	test   %ebx,%ebx
80101a8a:	74 34                	je     80101ac0 <iunlockput+0x40>
80101a8c:	83 ec 0c             	sub    $0xc,%esp
80101a8f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a92:	56                   	push   %esi
80101a93:	e8 28 2b 00 00       	call   801045c0 <holdingsleep>
80101a98:	83 c4 10             	add    $0x10,%esp
80101a9b:	85 c0                	test   %eax,%eax
80101a9d:	74 21                	je     80101ac0 <iunlockput+0x40>
80101a9f:	8b 43 08             	mov    0x8(%ebx),%eax
80101aa2:	85 c0                	test   %eax,%eax
80101aa4:	7e 1a                	jle    80101ac0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101aa6:	83 ec 0c             	sub    $0xc,%esp
80101aa9:	56                   	push   %esi
80101aaa:	e8 d1 2a 00 00       	call   80104580 <releasesleep>
  iput(ip);
80101aaf:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101ab2:	83 c4 10             	add    $0x10,%esp
}
80101ab5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ab8:	5b                   	pop    %ebx
80101ab9:	5e                   	pop    %esi
80101aba:	5d                   	pop    %ebp
  iput(ip);
80101abb:	e9 60 fe ff ff       	jmp    80101920 <iput>
    panic("iunlock");
80101ac0:	83 ec 0c             	sub    $0xc,%esp
80101ac3:	68 ff 77 10 80       	push   $0x801077ff
80101ac8:	e8 b3 e8 ff ff       	call   80100380 <panic>
80101acd:	8d 76 00             	lea    0x0(%esi),%esi

80101ad0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ad0:	55                   	push   %ebp
80101ad1:	89 e5                	mov    %esp,%ebp
80101ad3:	8b 55 08             	mov    0x8(%ebp),%edx
80101ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101ad9:	8b 0a                	mov    (%edx),%ecx
80101adb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101ade:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ae1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ae4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101ae8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101aeb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101aef:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101af3:	8b 52 58             	mov    0x58(%edx),%edx
80101af6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101af9:	5d                   	pop    %ebp
80101afa:	c3                   	ret
80101afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aff:	90                   	nop

80101b00 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101b00:	55                   	push   %ebp
80101b01:	89 e5                	mov    %esp,%ebp
80101b03:	57                   	push   %edi
80101b04:	56                   	push   %esi
80101b05:	53                   	push   %ebx
80101b06:	83 ec 1c             	sub    $0x1c,%esp
80101b09:	8b 75 08             	mov    0x8(%ebp),%esi
80101b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b0f:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b12:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80101b17:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101b1a:	89 75 d8             	mov    %esi,-0x28(%ebp)
80101b1d:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101b20:	0f 84 aa 00 00 00    	je     80101bd0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b26:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101b29:	8b 56 58             	mov    0x58(%esi),%edx
80101b2c:	39 fa                	cmp    %edi,%edx
80101b2e:	0f 82 bd 00 00 00    	jb     80101bf1 <readi+0xf1>
80101b34:	89 f9                	mov    %edi,%ecx
80101b36:	31 db                	xor    %ebx,%ebx
80101b38:	01 c1                	add    %eax,%ecx
80101b3a:	0f 92 c3             	setb   %bl
80101b3d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101b40:	0f 82 ab 00 00 00    	jb     80101bf1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b46:	89 d3                	mov    %edx,%ebx
80101b48:	29 fb                	sub    %edi,%ebx
80101b4a:	39 ca                	cmp    %ecx,%edx
80101b4c:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b4f:	85 c0                	test   %eax,%eax
80101b51:	74 73                	je     80101bc6 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101b53:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101b56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b60:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b63:	89 fa                	mov    %edi,%edx
80101b65:	c1 ea 09             	shr    $0x9,%edx
80101b68:	89 d8                	mov    %ebx,%eax
80101b6a:	e8 b1 f8 ff ff       	call   80101420 <bmap>
80101b6f:	83 ec 08             	sub    $0x8,%esp
80101b72:	50                   	push   %eax
80101b73:	ff 33                	push   (%ebx)
80101b75:	e8 56 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b7a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b7d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b82:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b84:	89 f8                	mov    %edi,%eax
80101b86:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b8b:	29 f3                	sub    %esi,%ebx
80101b8d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b8f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b93:	39 d9                	cmp    %ebx,%ecx
80101b95:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b98:	83 c4 0c             	add    $0xc,%esp
80101b9b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b9c:	01 de                	add    %ebx,%esi
80101b9e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101ba0:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101ba3:	50                   	push   %eax
80101ba4:	ff 75 e0             	push   -0x20(%ebp)
80101ba7:	e8 84 2d 00 00       	call   80104930 <memmove>
    brelse(bp);
80101bac:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101baf:	89 14 24             	mov    %edx,(%esp)
80101bb2:	e8 39 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bb7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101bba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101bbd:	83 c4 10             	add    $0x10,%esp
80101bc0:	39 de                	cmp    %ebx,%esi
80101bc2:	72 9c                	jb     80101b60 <readi+0x60>
80101bc4:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80101bc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bc9:	5b                   	pop    %ebx
80101bca:	5e                   	pop    %esi
80101bcb:	5f                   	pop    %edi
80101bcc:	5d                   	pop    %ebp
80101bcd:	c3                   	ret
80101bce:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101bd0:	0f bf 56 52          	movswl 0x52(%esi),%edx
80101bd4:	66 83 fa 09          	cmp    $0x9,%dx
80101bd8:	77 17                	ja     80101bf1 <readi+0xf1>
80101bda:	8b 14 d5 00 09 11 80 	mov    -0x7feef700(,%edx,8),%edx
80101be1:	85 d2                	test   %edx,%edx
80101be3:	74 0c                	je     80101bf1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101be5:	89 45 10             	mov    %eax,0x10(%ebp)
}
80101be8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101beb:	5b                   	pop    %ebx
80101bec:	5e                   	pop    %esi
80101bed:	5f                   	pop    %edi
80101bee:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101bef:	ff e2                	jmp    *%edx
      return -1;
80101bf1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bf6:	eb ce                	jmp    80101bc6 <readi+0xc6>
80101bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bff:	90                   	nop

80101c00 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c00:	55                   	push   %ebp
80101c01:	89 e5                	mov    %esp,%ebp
80101c03:	57                   	push   %edi
80101c04:	56                   	push   %esi
80101c05:	53                   	push   %ebx
80101c06:	83 ec 1c             	sub    $0x1c,%esp
80101c09:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101c0f:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c12:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c17:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101c1a:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101c1d:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101c20:	0f 84 ca 00 00 00    	je     80101cf0 <writei+0xf0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c26:	39 78 58             	cmp    %edi,0x58(%eax)
80101c29:	0f 82 fa 00 00 00    	jb     80101d29 <writei+0x129>
80101c2f:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101c32:	31 c9                	xor    %ecx,%ecx
80101c34:	89 f2                	mov    %esi,%edx
80101c36:	01 fa                	add    %edi,%edx
80101c38:	0f 92 c1             	setb   %cl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c3b:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101c41:	0f 87 e2 00 00 00    	ja     80101d29 <writei+0x129>
80101c47:	85 c9                	test   %ecx,%ecx
80101c49:	0f 85 da 00 00 00    	jne    80101d29 <writei+0x129>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c4f:	85 f6                	test   %esi,%esi
80101c51:	0f 84 86 00 00 00    	je     80101cdd <writei+0xdd>
80101c57:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101c5e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c68:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101c6b:	89 fa                	mov    %edi,%edx
80101c6d:	c1 ea 09             	shr    $0x9,%edx
80101c70:	89 f0                	mov    %esi,%eax
80101c72:	e8 a9 f7 ff ff       	call   80101420 <bmap>
80101c77:	83 ec 08             	sub    $0x8,%esp
80101c7a:	50                   	push   %eax
80101c7b:	ff 36                	push   (%esi)
80101c7d:	e8 4e e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c82:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101c85:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c88:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c8d:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c8f:	89 f8                	mov    %edi,%eax
80101c91:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c96:	29 d3                	sub    %edx,%ebx
80101c98:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c9a:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c9e:	39 d9                	cmp    %ebx,%ecx
80101ca0:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ca3:	83 c4 0c             	add    $0xc,%esp
80101ca6:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ca7:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101ca9:	ff 75 dc             	push   -0x24(%ebp)
80101cac:	50                   	push   %eax
80101cad:	e8 7e 2c 00 00       	call   80104930 <memmove>
    log_write(bp);
80101cb2:	89 34 24             	mov    %esi,(%esp)
80101cb5:	e8 96 14 00 00       	call   80103150 <log_write>
    brelse(bp);
80101cba:	89 34 24             	mov    %esi,(%esp)
80101cbd:	e8 2e e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cc2:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101cc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101cc8:	83 c4 10             	add    $0x10,%esp
80101ccb:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101cce:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101cd1:	39 d8                	cmp    %ebx,%eax
80101cd3:	72 93                	jb     80101c68 <writei+0x68>
  }

  if(n > 0 && off > ip->size){
80101cd5:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cd8:	39 78 58             	cmp    %edi,0x58(%eax)
80101cdb:	72 3b                	jb     80101d18 <writei+0x118>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101cdd:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101ce0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ce3:	5b                   	pop    %ebx
80101ce4:	5e                   	pop    %esi
80101ce5:	5f                   	pop    %edi
80101ce6:	5d                   	pop    %ebp
80101ce7:	c3                   	ret
80101ce8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cef:	90                   	nop
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101cf0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101cf4:	66 83 f8 09          	cmp    $0x9,%ax
80101cf8:	77 2f                	ja     80101d29 <writei+0x129>
80101cfa:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101d01:	85 c0                	test   %eax,%eax
80101d03:	74 24                	je     80101d29 <writei+0x129>
    return devsw[ip->major].write(ip, src, n);
80101d05:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101d08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d0b:	5b                   	pop    %ebx
80101d0c:	5e                   	pop    %esi
80101d0d:	5f                   	pop    %edi
80101d0e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101d0f:	ff e0                	jmp    *%eax
80101d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101d18:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101d1b:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101d1e:	50                   	push   %eax
80101d1f:	e8 1c fa ff ff       	call   80101740 <iupdate>
80101d24:	83 c4 10             	add    $0x10,%esp
80101d27:	eb b4                	jmp    80101cdd <writei+0xdd>
      return -1;
80101d29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d2e:	eb b0                	jmp    80101ce0 <writei+0xe0>

80101d30 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d30:	55                   	push   %ebp
80101d31:	89 e5                	mov    %esp,%ebp
80101d33:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d36:	6a 0e                	push   $0xe
80101d38:	ff 75 0c             	push   0xc(%ebp)
80101d3b:	ff 75 08             	push   0x8(%ebp)
80101d3e:	e8 5d 2c 00 00       	call   801049a0 <strncmp>
}
80101d43:	c9                   	leave
80101d44:	c3                   	ret
80101d45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d50 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d50:	55                   	push   %ebp
80101d51:	89 e5                	mov    %esp,%ebp
80101d53:	57                   	push   %edi
80101d54:	56                   	push   %esi
80101d55:	53                   	push   %ebx
80101d56:	83 ec 1c             	sub    $0x1c,%esp
80101d59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d5c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d61:	0f 85 85 00 00 00    	jne    80101dec <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d67:	8b 53 58             	mov    0x58(%ebx),%edx
80101d6a:	31 ff                	xor    %edi,%edi
80101d6c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d6f:	85 d2                	test   %edx,%edx
80101d71:	74 3e                	je     80101db1 <dirlookup+0x61>
80101d73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d77:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d78:	6a 10                	push   $0x10
80101d7a:	57                   	push   %edi
80101d7b:	56                   	push   %esi
80101d7c:	53                   	push   %ebx
80101d7d:	e8 7e fd ff ff       	call   80101b00 <readi>
80101d82:	83 c4 10             	add    $0x10,%esp
80101d85:	83 f8 10             	cmp    $0x10,%eax
80101d88:	75 55                	jne    80101ddf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d8a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d8f:	74 18                	je     80101da9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d91:	83 ec 04             	sub    $0x4,%esp
80101d94:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d97:	6a 0e                	push   $0xe
80101d99:	50                   	push   %eax
80101d9a:	ff 75 0c             	push   0xc(%ebp)
80101d9d:	e8 fe 2b 00 00       	call   801049a0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101da2:	83 c4 10             	add    $0x10,%esp
80101da5:	85 c0                	test   %eax,%eax
80101da7:	74 17                	je     80101dc0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101da9:	83 c7 10             	add    $0x10,%edi
80101dac:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101daf:	72 c7                	jb     80101d78 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101db1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101db4:	31 c0                	xor    %eax,%eax
}
80101db6:	5b                   	pop    %ebx
80101db7:	5e                   	pop    %esi
80101db8:	5f                   	pop    %edi
80101db9:	5d                   	pop    %ebp
80101dba:	c3                   	ret
80101dbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101dbf:	90                   	nop
      if(poff)
80101dc0:	8b 45 10             	mov    0x10(%ebp),%eax
80101dc3:	85 c0                	test   %eax,%eax
80101dc5:	74 05                	je     80101dcc <dirlookup+0x7c>
        *poff = off;
80101dc7:	8b 45 10             	mov    0x10(%ebp),%eax
80101dca:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101dcc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101dd0:	8b 03                	mov    (%ebx),%eax
80101dd2:	e8 49 f5 ff ff       	call   80101320 <iget>
}
80101dd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dda:	5b                   	pop    %ebx
80101ddb:	5e                   	pop    %esi
80101ddc:	5f                   	pop    %edi
80101ddd:	5d                   	pop    %ebp
80101dde:	c3                   	ret
      panic("dirlookup read");
80101ddf:	83 ec 0c             	sub    $0xc,%esp
80101de2:	68 19 78 10 80       	push   $0x80107819
80101de7:	e8 94 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101dec:	83 ec 0c             	sub    $0xc,%esp
80101def:	68 07 78 10 80       	push   $0x80107807
80101df4:	e8 87 e5 ff ff       	call   80100380 <panic>
80101df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e00 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e00:	55                   	push   %ebp
80101e01:	89 e5                	mov    %esp,%ebp
80101e03:	57                   	push   %edi
80101e04:	56                   	push   %esi
80101e05:	53                   	push   %ebx
80101e06:	89 c3                	mov    %eax,%ebx
80101e08:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101e0b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101e0e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e11:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101e14:	0f 84 64 01 00 00    	je     80101f7e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e1a:	e8 71 1d 00 00       	call   80103b90 <myproc>
  acquire(&icache.lock);
80101e1f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101e22:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101e25:	68 60 09 11 80       	push   $0x80110960
80101e2a:	e8 e1 28 00 00       	call   80104710 <acquire>
  ip->ref++;
80101e2f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e33:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101e3a:	e8 11 2a 00 00       	call   80104850 <release>
80101e3f:	83 c4 10             	add    $0x10,%esp
80101e42:	eb 07                	jmp    80101e4b <namex+0x4b>
80101e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e48:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e4b:	0f b6 03             	movzbl (%ebx),%eax
80101e4e:	3c 2f                	cmp    $0x2f,%al
80101e50:	74 f6                	je     80101e48 <namex+0x48>
  if(*path == 0)
80101e52:	84 c0                	test   %al,%al
80101e54:	0f 84 06 01 00 00    	je     80101f60 <namex+0x160>
  while(*path != '/' && *path != 0)
80101e5a:	0f b6 03             	movzbl (%ebx),%eax
80101e5d:	84 c0                	test   %al,%al
80101e5f:	0f 84 10 01 00 00    	je     80101f75 <namex+0x175>
80101e65:	89 df                	mov    %ebx,%edi
80101e67:	3c 2f                	cmp    $0x2f,%al
80101e69:	0f 84 06 01 00 00    	je     80101f75 <namex+0x175>
80101e6f:	90                   	nop
80101e70:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e74:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e77:	3c 2f                	cmp    $0x2f,%al
80101e79:	74 04                	je     80101e7f <namex+0x7f>
80101e7b:	84 c0                	test   %al,%al
80101e7d:	75 f1                	jne    80101e70 <namex+0x70>
  len = path - s;
80101e7f:	89 f8                	mov    %edi,%eax
80101e81:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e83:	83 f8 0d             	cmp    $0xd,%eax
80101e86:	0f 8e ac 00 00 00    	jle    80101f38 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e8c:	83 ec 04             	sub    $0x4,%esp
80101e8f:	6a 0e                	push   $0xe
80101e91:	53                   	push   %ebx
    path++;
80101e92:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e94:	ff 75 e4             	push   -0x1c(%ebp)
80101e97:	e8 94 2a 00 00       	call   80104930 <memmove>
80101e9c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e9f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101ea2:	75 0c                	jne    80101eb0 <namex+0xb0>
80101ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ea8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101eab:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101eae:	74 f8                	je     80101ea8 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101eb0:	83 ec 0c             	sub    $0xc,%esp
80101eb3:	56                   	push   %esi
80101eb4:	e8 37 f9 ff ff       	call   801017f0 <ilock>
    if(ip->type != T_DIR){
80101eb9:	83 c4 10             	add    $0x10,%esp
80101ebc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101ec1:	0f 85 cd 00 00 00    	jne    80101f94 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101ec7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eca:	85 c0                	test   %eax,%eax
80101ecc:	74 09                	je     80101ed7 <namex+0xd7>
80101ece:	80 3b 00             	cmpb   $0x0,(%ebx)
80101ed1:	0f 84 34 01 00 00    	je     8010200b <namex+0x20b>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101ed7:	83 ec 04             	sub    $0x4,%esp
80101eda:	6a 00                	push   $0x0
80101edc:	ff 75 e4             	push   -0x1c(%ebp)
80101edf:	56                   	push   %esi
80101ee0:	e8 6b fe ff ff       	call   80101d50 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ee5:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101ee8:	83 c4 10             	add    $0x10,%esp
80101eeb:	89 c7                	mov    %eax,%edi
80101eed:	85 c0                	test   %eax,%eax
80101eef:	0f 84 e1 00 00 00    	je     80101fd6 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ef5:	83 ec 0c             	sub    $0xc,%esp
80101ef8:	52                   	push   %edx
80101ef9:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101efc:	e8 bf 26 00 00       	call   801045c0 <holdingsleep>
80101f01:	83 c4 10             	add    $0x10,%esp
80101f04:	85 c0                	test   %eax,%eax
80101f06:	0f 84 3f 01 00 00    	je     8010204b <namex+0x24b>
80101f0c:	8b 56 08             	mov    0x8(%esi),%edx
80101f0f:	85 d2                	test   %edx,%edx
80101f11:	0f 8e 34 01 00 00    	jle    8010204b <namex+0x24b>
  releasesleep(&ip->lock);
80101f17:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f1a:	83 ec 0c             	sub    $0xc,%esp
80101f1d:	52                   	push   %edx
80101f1e:	e8 5d 26 00 00       	call   80104580 <releasesleep>
  iput(ip);
80101f23:	89 34 24             	mov    %esi,(%esp)
80101f26:	89 fe                	mov    %edi,%esi
80101f28:	e8 f3 f9 ff ff       	call   80101920 <iput>
80101f2d:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101f30:	e9 16 ff ff ff       	jmp    80101e4b <namex+0x4b>
80101f35:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101f38:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f3b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101f3e:	83 ec 04             	sub    $0x4,%esp
80101f41:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101f44:	50                   	push   %eax
80101f45:	53                   	push   %ebx
    name[len] = 0;
80101f46:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101f48:	ff 75 e4             	push   -0x1c(%ebp)
80101f4b:	e8 e0 29 00 00       	call   80104930 <memmove>
    name[len] = 0;
80101f50:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f53:	83 c4 10             	add    $0x10,%esp
80101f56:	c6 02 00             	movb   $0x0,(%edx)
80101f59:	e9 41 ff ff ff       	jmp    80101e9f <namex+0x9f>
80101f5e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f60:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f63:	85 c0                	test   %eax,%eax
80101f65:	0f 85 d0 00 00 00    	jne    8010203b <namex+0x23b>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f6e:	89 f0                	mov    %esi,%eax
80101f70:	5b                   	pop    %ebx
80101f71:	5e                   	pop    %esi
80101f72:	5f                   	pop    %edi
80101f73:	5d                   	pop    %ebp
80101f74:	c3                   	ret
  while(*path != '/' && *path != 0)
80101f75:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f78:	89 df                	mov    %ebx,%edi
80101f7a:	31 c0                	xor    %eax,%eax
80101f7c:	eb c0                	jmp    80101f3e <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f7e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f83:	b8 01 00 00 00       	mov    $0x1,%eax
80101f88:	e8 93 f3 ff ff       	call   80101320 <iget>
80101f8d:	89 c6                	mov    %eax,%esi
80101f8f:	e9 b7 fe ff ff       	jmp    80101e4b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f94:	83 ec 0c             	sub    $0xc,%esp
80101f97:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f9a:	53                   	push   %ebx
80101f9b:	e8 20 26 00 00       	call   801045c0 <holdingsleep>
80101fa0:	83 c4 10             	add    $0x10,%esp
80101fa3:	85 c0                	test   %eax,%eax
80101fa5:	0f 84 a0 00 00 00    	je     8010204b <namex+0x24b>
80101fab:	8b 46 08             	mov    0x8(%esi),%eax
80101fae:	85 c0                	test   %eax,%eax
80101fb0:	0f 8e 95 00 00 00    	jle    8010204b <namex+0x24b>
  releasesleep(&ip->lock);
80101fb6:	83 ec 0c             	sub    $0xc,%esp
80101fb9:	53                   	push   %ebx
80101fba:	e8 c1 25 00 00       	call   80104580 <releasesleep>
  iput(ip);
80101fbf:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101fc2:	31 f6                	xor    %esi,%esi
  iput(ip);
80101fc4:	e8 57 f9 ff ff       	call   80101920 <iput>
      return 0;
80101fc9:	83 c4 10             	add    $0x10,%esp
}
80101fcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fcf:	89 f0                	mov    %esi,%eax
80101fd1:	5b                   	pop    %ebx
80101fd2:	5e                   	pop    %esi
80101fd3:	5f                   	pop    %edi
80101fd4:	5d                   	pop    %ebp
80101fd5:	c3                   	ret
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fd6:	83 ec 0c             	sub    $0xc,%esp
80101fd9:	52                   	push   %edx
80101fda:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101fdd:	e8 de 25 00 00       	call   801045c0 <holdingsleep>
80101fe2:	83 c4 10             	add    $0x10,%esp
80101fe5:	85 c0                	test   %eax,%eax
80101fe7:	74 62                	je     8010204b <namex+0x24b>
80101fe9:	8b 4e 08             	mov    0x8(%esi),%ecx
80101fec:	85 c9                	test   %ecx,%ecx
80101fee:	7e 5b                	jle    8010204b <namex+0x24b>
  releasesleep(&ip->lock);
80101ff0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ff3:	83 ec 0c             	sub    $0xc,%esp
80101ff6:	52                   	push   %edx
80101ff7:	e8 84 25 00 00       	call   80104580 <releasesleep>
  iput(ip);
80101ffc:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101fff:	31 f6                	xor    %esi,%esi
  iput(ip);
80102001:	e8 1a f9 ff ff       	call   80101920 <iput>
      return 0;
80102006:	83 c4 10             	add    $0x10,%esp
80102009:	eb c1                	jmp    80101fcc <namex+0x1cc>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010200b:	83 ec 0c             	sub    $0xc,%esp
8010200e:	8d 5e 0c             	lea    0xc(%esi),%ebx
80102011:	53                   	push   %ebx
80102012:	e8 a9 25 00 00       	call   801045c0 <holdingsleep>
80102017:	83 c4 10             	add    $0x10,%esp
8010201a:	85 c0                	test   %eax,%eax
8010201c:	74 2d                	je     8010204b <namex+0x24b>
8010201e:	8b 7e 08             	mov    0x8(%esi),%edi
80102021:	85 ff                	test   %edi,%edi
80102023:	7e 26                	jle    8010204b <namex+0x24b>
  releasesleep(&ip->lock);
80102025:	83 ec 0c             	sub    $0xc,%esp
80102028:	53                   	push   %ebx
80102029:	e8 52 25 00 00       	call   80104580 <releasesleep>
}
8010202e:	83 c4 10             	add    $0x10,%esp
}
80102031:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102034:	89 f0                	mov    %esi,%eax
80102036:	5b                   	pop    %ebx
80102037:	5e                   	pop    %esi
80102038:	5f                   	pop    %edi
80102039:	5d                   	pop    %ebp
8010203a:	c3                   	ret
    iput(ip);
8010203b:	83 ec 0c             	sub    $0xc,%esp
8010203e:	56                   	push   %esi
      return 0;
8010203f:	31 f6                	xor    %esi,%esi
    iput(ip);
80102041:	e8 da f8 ff ff       	call   80101920 <iput>
    return 0;
80102046:	83 c4 10             	add    $0x10,%esp
80102049:	eb 81                	jmp    80101fcc <namex+0x1cc>
    panic("iunlock");
8010204b:	83 ec 0c             	sub    $0xc,%esp
8010204e:	68 ff 77 10 80       	push   $0x801077ff
80102053:	e8 28 e3 ff ff       	call   80100380 <panic>
80102058:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010205f:	90                   	nop

80102060 <dirlink>:
{
80102060:	55                   	push   %ebp
80102061:	89 e5                	mov    %esp,%ebp
80102063:	57                   	push   %edi
80102064:	56                   	push   %esi
80102065:	53                   	push   %ebx
80102066:	83 ec 20             	sub    $0x20,%esp
80102069:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010206c:	6a 00                	push   $0x0
8010206e:	ff 75 0c             	push   0xc(%ebp)
80102071:	53                   	push   %ebx
80102072:	e8 d9 fc ff ff       	call   80101d50 <dirlookup>
80102077:	83 c4 10             	add    $0x10,%esp
8010207a:	85 c0                	test   %eax,%eax
8010207c:	75 67                	jne    801020e5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010207e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102081:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102084:	85 ff                	test   %edi,%edi
80102086:	74 29                	je     801020b1 <dirlink+0x51>
80102088:	31 ff                	xor    %edi,%edi
8010208a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010208d:	eb 09                	jmp    80102098 <dirlink+0x38>
8010208f:	90                   	nop
80102090:	83 c7 10             	add    $0x10,%edi
80102093:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102096:	73 19                	jae    801020b1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102098:	6a 10                	push   $0x10
8010209a:	57                   	push   %edi
8010209b:	56                   	push   %esi
8010209c:	53                   	push   %ebx
8010209d:	e8 5e fa ff ff       	call   80101b00 <readi>
801020a2:	83 c4 10             	add    $0x10,%esp
801020a5:	83 f8 10             	cmp    $0x10,%eax
801020a8:	75 4e                	jne    801020f8 <dirlink+0x98>
    if(de.inum == 0)
801020aa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801020af:	75 df                	jne    80102090 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
801020b1:	83 ec 04             	sub    $0x4,%esp
801020b4:	8d 45 da             	lea    -0x26(%ebp),%eax
801020b7:	6a 0e                	push   $0xe
801020b9:	ff 75 0c             	push   0xc(%ebp)
801020bc:	50                   	push   %eax
801020bd:	e8 2e 29 00 00       	call   801049f0 <strncpy>
  de.inum = inum;
801020c2:	8b 45 10             	mov    0x10(%ebp),%eax
801020c5:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020c9:	6a 10                	push   $0x10
801020cb:	57                   	push   %edi
801020cc:	56                   	push   %esi
801020cd:	53                   	push   %ebx
801020ce:	e8 2d fb ff ff       	call   80101c00 <writei>
801020d3:	83 c4 20             	add    $0x20,%esp
801020d6:	83 f8 10             	cmp    $0x10,%eax
801020d9:	75 2a                	jne    80102105 <dirlink+0xa5>
  return 0;
801020db:	31 c0                	xor    %eax,%eax
}
801020dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020e0:	5b                   	pop    %ebx
801020e1:	5e                   	pop    %esi
801020e2:	5f                   	pop    %edi
801020e3:	5d                   	pop    %ebp
801020e4:	c3                   	ret
    iput(ip);
801020e5:	83 ec 0c             	sub    $0xc,%esp
801020e8:	50                   	push   %eax
801020e9:	e8 32 f8 ff ff       	call   80101920 <iput>
    return -1;
801020ee:	83 c4 10             	add    $0x10,%esp
801020f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020f6:	eb e5                	jmp    801020dd <dirlink+0x7d>
      panic("dirlink read");
801020f8:	83 ec 0c             	sub    $0xc,%esp
801020fb:	68 28 78 10 80       	push   $0x80107828
80102100:	e8 7b e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102105:	83 ec 0c             	sub    $0xc,%esp
80102108:	68 4e 7e 10 80       	push   $0x80107e4e
8010210d:	e8 6e e2 ff ff       	call   80100380 <panic>
80102112:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102120 <namei>:

struct inode*
namei(char *path)
{
80102120:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102121:	31 d2                	xor    %edx,%edx
{
80102123:	89 e5                	mov    %esp,%ebp
80102125:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102128:	8b 45 08             	mov    0x8(%ebp),%eax
8010212b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010212e:	e8 cd fc ff ff       	call   80101e00 <namex>
}
80102133:	c9                   	leave
80102134:	c3                   	ret
80102135:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010213c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102140 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102140:	55                   	push   %ebp
  return namex(path, 1, name);
80102141:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102146:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102148:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010214b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010214e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010214f:	e9 ac fc ff ff       	jmp    80101e00 <namex>
80102154:	66 90                	xchg   %ax,%ax
80102156:	66 90                	xchg   %ax,%ax
80102158:	66 90                	xchg   %ax,%ax
8010215a:	66 90                	xchg   %ax,%ax
8010215c:	66 90                	xchg   %ax,%ax
8010215e:	66 90                	xchg   %ax,%ax

80102160 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102160:	55                   	push   %ebp
80102161:	89 e5                	mov    %esp,%ebp
80102163:	57                   	push   %edi
80102164:	56                   	push   %esi
80102165:	53                   	push   %ebx
80102166:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102169:	85 c0                	test   %eax,%eax
8010216b:	0f 84 b4 00 00 00    	je     80102225 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102171:	8b 70 08             	mov    0x8(%eax),%esi
80102174:	89 c3                	mov    %eax,%ebx
80102176:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010217c:	0f 87 96 00 00 00    	ja     80102218 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102182:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010218e:	66 90                	xchg   %ax,%ax
80102190:	89 ca                	mov    %ecx,%edx
80102192:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102193:	83 e0 c0             	and    $0xffffffc0,%eax
80102196:	3c 40                	cmp    $0x40,%al
80102198:	75 f6                	jne    80102190 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010219a:	31 ff                	xor    %edi,%edi
8010219c:	ba f6 03 00 00       	mov    $0x3f6,%edx
801021a1:	89 f8                	mov    %edi,%eax
801021a3:	ee                   	out    %al,(%dx)
801021a4:	b8 01 00 00 00       	mov    $0x1,%eax
801021a9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801021ae:	ee                   	out    %al,(%dx)
801021af:	ba f3 01 00 00       	mov    $0x1f3,%edx
801021b4:	89 f0                	mov    %esi,%eax
801021b6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801021b7:	89 f0                	mov    %esi,%eax
801021b9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801021be:	c1 f8 08             	sar    $0x8,%eax
801021c1:	ee                   	out    %al,(%dx)
801021c2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801021c7:	89 f8                	mov    %edi,%eax
801021c9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801021ca:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801021ce:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021d3:	c1 e0 04             	shl    $0x4,%eax
801021d6:	83 e0 10             	and    $0x10,%eax
801021d9:	83 c8 e0             	or     $0xffffffe0,%eax
801021dc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801021dd:	f6 03 04             	testb  $0x4,(%ebx)
801021e0:	75 16                	jne    801021f8 <idestart+0x98>
801021e2:	b8 20 00 00 00       	mov    $0x20,%eax
801021e7:	89 ca                	mov    %ecx,%edx
801021e9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801021ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021ed:	5b                   	pop    %ebx
801021ee:	5e                   	pop    %esi
801021ef:	5f                   	pop    %edi
801021f0:	5d                   	pop    %ebp
801021f1:	c3                   	ret
801021f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021f8:	b8 30 00 00 00       	mov    $0x30,%eax
801021fd:	89 ca                	mov    %ecx,%edx
801021ff:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102200:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102205:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102208:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010220d:	fc                   	cld
8010220e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102210:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102213:	5b                   	pop    %ebx
80102214:	5e                   	pop    %esi
80102215:	5f                   	pop    %edi
80102216:	5d                   	pop    %ebp
80102217:	c3                   	ret
    panic("incorrect blockno");
80102218:	83 ec 0c             	sub    $0xc,%esp
8010221b:	68 94 78 10 80       	push   $0x80107894
80102220:	e8 5b e1 ff ff       	call   80100380 <panic>
    panic("idestart");
80102225:	83 ec 0c             	sub    $0xc,%esp
80102228:	68 8b 78 10 80       	push   $0x8010788b
8010222d:	e8 4e e1 ff ff       	call   80100380 <panic>
80102232:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102240 <ideinit>:
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102246:	68 a6 78 10 80       	push   $0x801078a6
8010224b:	68 00 26 11 80       	push   $0x80112600
80102250:	e8 9b 23 00 00       	call   801045f0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102255:	58                   	pop    %eax
80102256:	a1 a4 27 18 80       	mov    0x801827a4,%eax
8010225b:	5a                   	pop    %edx
8010225c:	83 e8 01             	sub    $0x1,%eax
8010225f:	50                   	push   %eax
80102260:	6a 0e                	push   $0xe
80102262:	e8 99 02 00 00       	call   80102500 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102267:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010226a:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
8010226f:	90                   	nop
80102270:	89 ca                	mov    %ecx,%edx
80102272:	ec                   	in     (%dx),%al
80102273:	83 e0 c0             	and    $0xffffffc0,%eax
80102276:	3c 40                	cmp    $0x40,%al
80102278:	75 f6                	jne    80102270 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010227a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010227f:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102284:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102285:	89 ca                	mov    %ecx,%edx
80102287:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102288:	84 c0                	test   %al,%al
8010228a:	75 1e                	jne    801022aa <ideinit+0x6a>
8010228c:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80102291:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010229d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i=0; i<1000; i++){
801022a0:	83 e9 01             	sub    $0x1,%ecx
801022a3:	74 0f                	je     801022b4 <ideinit+0x74>
801022a5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801022a6:	84 c0                	test   %al,%al
801022a8:	74 f6                	je     801022a0 <ideinit+0x60>
      havedisk1 = 1;
801022aa:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
801022b1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022b4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801022b9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022be:	ee                   	out    %al,(%dx)
}
801022bf:	c9                   	leave
801022c0:	c3                   	ret
801022c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022cf:	90                   	nop

801022d0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801022d0:	55                   	push   %ebp
801022d1:	89 e5                	mov    %esp,%ebp
801022d3:	57                   	push   %edi
801022d4:	56                   	push   %esi
801022d5:	53                   	push   %ebx
801022d6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801022d9:	68 00 26 11 80       	push   $0x80112600
801022de:	e8 2d 24 00 00       	call   80104710 <acquire>

  if((b = idequeue) == 0){
801022e3:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
801022e9:	83 c4 10             	add    $0x10,%esp
801022ec:	85 db                	test   %ebx,%ebx
801022ee:	74 63                	je     80102353 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801022f0:	8b 43 58             	mov    0x58(%ebx),%eax
801022f3:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801022f8:	8b 33                	mov    (%ebx),%esi
801022fa:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102300:	75 2f                	jne    80102331 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102302:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102307:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010230e:	66 90                	xchg   %ax,%ax
80102310:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102311:	89 c1                	mov    %eax,%ecx
80102313:	83 e1 c0             	and    $0xffffffc0,%ecx
80102316:	80 f9 40             	cmp    $0x40,%cl
80102319:	75 f5                	jne    80102310 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010231b:	a8 21                	test   $0x21,%al
8010231d:	75 12                	jne    80102331 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010231f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102322:	b9 80 00 00 00       	mov    $0x80,%ecx
80102327:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010232c:	fc                   	cld
8010232d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010232f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102331:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102334:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102337:	83 ce 02             	or     $0x2,%esi
8010233a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010233c:	53                   	push   %ebx
8010233d:	e8 fe 1f 00 00       	call   80104340 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102342:	a1 e4 25 11 80       	mov    0x801125e4,%eax
80102347:	83 c4 10             	add    $0x10,%esp
8010234a:	85 c0                	test   %eax,%eax
8010234c:	74 05                	je     80102353 <ideintr+0x83>
    idestart(idequeue);
8010234e:	e8 0d fe ff ff       	call   80102160 <idestart>
    release(&idelock);
80102353:	83 ec 0c             	sub    $0xc,%esp
80102356:	68 00 26 11 80       	push   $0x80112600
8010235b:	e8 f0 24 00 00       	call   80104850 <release>

  release(&idelock);
}
80102360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102363:	5b                   	pop    %ebx
80102364:	5e                   	pop    %esi
80102365:	5f                   	pop    %edi
80102366:	5d                   	pop    %ebp
80102367:	c3                   	ret
80102368:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010236f:	90                   	nop

80102370 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102370:	55                   	push   %ebp
80102371:	89 e5                	mov    %esp,%ebp
80102373:	53                   	push   %ebx
80102374:	83 ec 10             	sub    $0x10,%esp
80102377:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010237a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010237d:	50                   	push   %eax
8010237e:	e8 3d 22 00 00       	call   801045c0 <holdingsleep>
80102383:	83 c4 10             	add    $0x10,%esp
80102386:	85 c0                	test   %eax,%eax
80102388:	0f 84 c3 00 00 00    	je     80102451 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010238e:	8b 03                	mov    (%ebx),%eax
80102390:	83 e0 06             	and    $0x6,%eax
80102393:	83 f8 02             	cmp    $0x2,%eax
80102396:	0f 84 a8 00 00 00    	je     80102444 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010239c:	8b 53 04             	mov    0x4(%ebx),%edx
8010239f:	85 d2                	test   %edx,%edx
801023a1:	74 0d                	je     801023b0 <iderw+0x40>
801023a3:	a1 e0 25 11 80       	mov    0x801125e0,%eax
801023a8:	85 c0                	test   %eax,%eax
801023aa:	0f 84 87 00 00 00    	je     80102437 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801023b0:	83 ec 0c             	sub    $0xc,%esp
801023b3:	68 00 26 11 80       	push   $0x80112600
801023b8:	e8 53 23 00 00       	call   80104710 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023bd:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
801023c2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023c9:	83 c4 10             	add    $0x10,%esp
801023cc:	85 c0                	test   %eax,%eax
801023ce:	74 60                	je     80102430 <iderw+0xc0>
801023d0:	89 c2                	mov    %eax,%edx
801023d2:	8b 40 58             	mov    0x58(%eax),%eax
801023d5:	85 c0                	test   %eax,%eax
801023d7:	75 f7                	jne    801023d0 <iderw+0x60>
801023d9:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801023dc:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801023de:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
801023e4:	74 3a                	je     80102420 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023e6:	8b 03                	mov    (%ebx),%eax
801023e8:	83 e0 06             	and    $0x6,%eax
801023eb:	83 f8 02             	cmp    $0x2,%eax
801023ee:	74 1b                	je     8010240b <iderw+0x9b>
    sleep(b, &idelock);
801023f0:	83 ec 08             	sub    $0x8,%esp
801023f3:	68 00 26 11 80       	push   $0x80112600
801023f8:	53                   	push   %ebx
801023f9:	e8 82 1e 00 00       	call   80104280 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023fe:	8b 03                	mov    (%ebx),%eax
80102400:	83 c4 10             	add    $0x10,%esp
80102403:	83 e0 06             	and    $0x6,%eax
80102406:	83 f8 02             	cmp    $0x2,%eax
80102409:	75 e5                	jne    801023f0 <iderw+0x80>
  }


  release(&idelock);
8010240b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102412:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102415:	c9                   	leave
  release(&idelock);
80102416:	e9 35 24 00 00       	jmp    80104850 <release>
8010241b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010241f:	90                   	nop
    idestart(b);
80102420:	89 d8                	mov    %ebx,%eax
80102422:	e8 39 fd ff ff       	call   80102160 <idestart>
80102427:	eb bd                	jmp    801023e6 <iderw+0x76>
80102429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102430:	ba e4 25 11 80       	mov    $0x801125e4,%edx
80102435:	eb a5                	jmp    801023dc <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102437:	83 ec 0c             	sub    $0xc,%esp
8010243a:	68 d5 78 10 80       	push   $0x801078d5
8010243f:	e8 3c df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102444:	83 ec 0c             	sub    $0xc,%esp
80102447:	68 c0 78 10 80       	push   $0x801078c0
8010244c:	e8 2f df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102451:	83 ec 0c             	sub    $0xc,%esp
80102454:	68 aa 78 10 80       	push   $0x801078aa
80102459:	e8 22 df ff ff       	call   80100380 <panic>
8010245e:	66 90                	xchg   %ax,%ax

80102460 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	56                   	push   %esi
80102464:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102465:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010246c:	00 c0 fe 
  ioapic->reg = reg;
8010246f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102476:	00 00 00 
  return ioapic->data;
80102479:	8b 15 34 26 11 80    	mov    0x80112634,%edx
8010247f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102482:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102488:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010248e:	0f b6 15 a0 27 18 80 	movzbl 0x801827a0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102495:	c1 ee 10             	shr    $0x10,%esi
80102498:	89 f0                	mov    %esi,%eax
8010249a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010249d:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
801024a0:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801024a3:	39 c2                	cmp    %eax,%edx
801024a5:	74 16                	je     801024bd <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801024a7:	83 ec 0c             	sub    $0xc,%esp
801024aa:	68 f4 78 10 80       	push   $0x801078f4
801024af:	e8 fc e1 ff ff       	call   801006b0 <cprintf>
  ioapic->reg = reg;
801024b4:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
801024ba:	83 c4 10             	add    $0x10,%esp
{
801024bd:	ba 10 00 00 00       	mov    $0x10,%edx
801024c2:	31 c0                	xor    %eax,%eax
801024c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
801024c8:	89 13                	mov    %edx,(%ebx)
801024ca:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
801024cd:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801024d3:	83 c0 01             	add    $0x1,%eax
801024d6:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
801024dc:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
801024df:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
801024e2:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
801024e5:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
801024e7:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
801024ed:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
801024f4:	39 c6                	cmp    %eax,%esi
801024f6:	7d d0                	jge    801024c8 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801024f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024fb:	5b                   	pop    %ebx
801024fc:	5e                   	pop    %esi
801024fd:	5d                   	pop    %ebp
801024fe:	c3                   	ret
801024ff:	90                   	nop

80102500 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102500:	55                   	push   %ebp
  ioapic->reg = reg;
80102501:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102507:	89 e5                	mov    %esp,%ebp
80102509:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010250c:	8d 50 20             	lea    0x20(%eax),%edx
8010250f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102513:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102515:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010251b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010251e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102521:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102524:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102526:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010252b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010252e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102531:	5d                   	pop    %ebp
80102532:	c3                   	ret
80102533:	66 90                	xchg   %ax,%ax
80102535:	66 90                	xchg   %ax,%ax
80102537:	66 90                	xchg   %ax,%ax
80102539:	66 90                	xchg   %ax,%ax
8010253b:	66 90                	xchg   %ax,%ax
8010253d:	66 90                	xchg   %ax,%ax
8010253f:	90                   	nop

80102540 <kfree>:
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char* v) {
80102540:	55                   	push   %ebp
80102541:	89 e5                	mov    %esp,%ebp
80102543:	53                   	push   %ebx
80102544:	83 ec 04             	sub    $0x4,%esp
80102547:	8b 45 08             	mov    0x8(%ebp),%eax
    struct run* r;

    if ((uint) v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010254a:	a9 ff 0f 00 00       	test   $0xfff,%eax
8010254f:	0f 85 cc 00 00 00    	jne    80102621 <kfree+0xe1>
80102555:	3d f0 64 18 80       	cmp    $0x801864f0,%eax
8010255a:	0f 82 c1 00 00 00    	jb     80102621 <kfree+0xe1>
80102560:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80102566:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
8010256c:	0f 87 af 00 00 00    	ja     80102621 <kfree+0xe1>
        panic("kfree");

    // Fill with junk to catch dangling refs.
    memset(v, 1, PGSIZE);
80102572:	83 ec 04             	sub    $0x4,%esp
80102575:	68 00 10 00 00       	push   $0x1000
8010257a:	6a 01                	push   $0x1
8010257c:	50                   	push   %eax
8010257d:	e8 1e 23 00 00       	call   801048a0 <memset>

    if (kmem.use_lock)
80102582:	8b 15 94 26 11 80    	mov    0x80112694,%edx
80102588:	83 c4 10             	add    $0x10,%esp
8010258b:	85 d2                	test   %edx,%edx
8010258d:	75 39                	jne    801025c8 <kfree+0x88>
//        r->next = kmem.freelist;
//        kmem.freelist = r;
//        free_frame_cnt++; // xv6 proj - cow
//    }else{
        r = &kmem.runs[(V2P(v) / PGSIZE)];
        r->next = kmem.freelist;
8010258f:	a1 98 26 11 80       	mov    0x80112698,%eax
        r = &kmem.runs[(V2P(v) / PGSIZE)];
80102594:	c1 eb 0c             	shr    $0xc,%ebx
        free_frame_cnt++; // xv6 proj - cow
80102597:	83 05 44 26 11 80 01 	addl   $0x1,0x80112644
        r->next = kmem.freelist;
8010259e:	83 c3 06             	add    $0x6,%ebx
801025a1:	89 04 dd 6c 26 11 80 	mov    %eax,-0x7feed994(,%ebx,8)
        r = &kmem.runs[(V2P(v) / PGSIZE)];
801025a8:	8d 04 dd 6c 26 11 80 	lea    -0x7feed994(,%ebx,8),%eax
        r->ref = 0;
801025af:	c7 04 dd 70 26 11 80 	movl   $0x0,-0x7feed990(,%ebx,8)
801025b6:	00 00 00 00 
        r = &kmem.runs[(V2P(v) / PGSIZE)];
801025ba:	a3 98 26 11 80       	mov    %eax,0x80112698
        kmem.freelist = r;
//    }
    if (kmem.use_lock)
        release(&kmem.lock);
}
801025bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025c2:	c9                   	leave
801025c3:	c3                   	ret
801025c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        acquire(&kmem.lock);
801025c8:	83 ec 0c             	sub    $0xc,%esp
        r = &kmem.runs[(V2P(v) / PGSIZE)];
801025cb:	c1 eb 0c             	shr    $0xc,%ebx
        acquire(&kmem.lock);
801025ce:	68 60 26 11 80       	push   $0x80112660
        r->next = kmem.freelist;
801025d3:	83 c3 06             	add    $0x6,%ebx
        acquire(&kmem.lock);
801025d6:	e8 35 21 00 00       	call   80104710 <acquire>
        r->next = kmem.freelist;
801025db:	a1 98 26 11 80       	mov    0x80112698,%eax
        free_frame_cnt++; // xv6 proj - cow
801025e0:	83 05 44 26 11 80 01 	addl   $0x1,0x80112644
    if (kmem.use_lock)
801025e7:	83 c4 10             	add    $0x10,%esp
        r->ref = 0;
801025ea:	c7 04 dd 70 26 11 80 	movl   $0x0,-0x7feed990(,%ebx,8)
801025f1:	00 00 00 00 
        r->next = kmem.freelist;
801025f5:	89 04 dd 6c 26 11 80 	mov    %eax,-0x7feed994(,%ebx,8)
        r = &kmem.runs[(V2P(v) / PGSIZE)];
801025fc:	8d 04 dd 6c 26 11 80 	lea    -0x7feed994(,%ebx,8),%eax
80102603:	a3 98 26 11 80       	mov    %eax,0x80112698
    if (kmem.use_lock)
80102608:	a1 94 26 11 80       	mov    0x80112694,%eax
8010260d:	85 c0                	test   %eax,%eax
8010260f:	74 ae                	je     801025bf <kfree+0x7f>
        release(&kmem.lock);
80102611:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
80102618:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010261b:	c9                   	leave
        release(&kmem.lock);
8010261c:	e9 2f 22 00 00       	jmp    80104850 <release>
        panic("kfree");
80102621:	83 ec 0c             	sub    $0xc,%esp
80102624:	68 26 79 10 80       	push   $0x80107926
80102629:	e8 52 dd ff ff       	call   80100380 <panic>
8010262e:	66 90                	xchg   %ax,%ax

80102630 <freerange>:
freerange(void* vstart, void* vend) {
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	56                   	push   %esi
80102634:	53                   	push   %ebx
    p = (char*) PGROUNDUP((uint) vstart);
80102635:	8b 45 08             	mov    0x8(%ebp),%eax
freerange(void* vstart, void* vend) {
80102638:	8b 75 0c             	mov    0xc(%ebp),%esi
    p = (char*) PGROUNDUP((uint) vstart);
8010263b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102641:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    for (; p + PGSIZE <= (char*) vend; p += PGSIZE)
80102647:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010264d:	39 de                	cmp    %ebx,%esi
8010264f:	72 23                	jb     80102674 <freerange+0x44>
80102651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        kfree(p);
80102658:	83 ec 0c             	sub    $0xc,%esp
8010265b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
    for (; p + PGSIZE <= (char*) vend; p += PGSIZE)
80102661:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        kfree(p);
80102667:	50                   	push   %eax
80102668:	e8 d3 fe ff ff       	call   80102540 <kfree>
    for (; p + PGSIZE <= (char*) vend; p += PGSIZE)
8010266d:	83 c4 10             	add    $0x10,%esp
80102670:	39 de                	cmp    %ebx,%esi
80102672:	73 e4                	jae    80102658 <freerange+0x28>
}
80102674:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102677:	5b                   	pop    %ebx
80102678:	5e                   	pop    %esi
80102679:	5d                   	pop    %ebp
8010267a:	c3                   	ret
8010267b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010267f:	90                   	nop

80102680 <kinit2>:
kinit2(void* vstart, void* vend) {
80102680:	55                   	push   %ebp
80102681:	89 e5                	mov    %esp,%ebp
80102683:	56                   	push   %esi
80102684:	53                   	push   %ebx
    p = (char*) PGROUNDUP((uint) vstart);
80102685:	8b 45 08             	mov    0x8(%ebp),%eax
kinit2(void* vstart, void* vend) {
80102688:	8b 75 0c             	mov    0xc(%ebp),%esi
    p = (char*) PGROUNDUP((uint) vstart);
8010268b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102691:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    for (; p + PGSIZE <= (char*) vend; p += PGSIZE)
80102697:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010269d:	39 de                	cmp    %ebx,%esi
8010269f:	72 23                	jb     801026c4 <kinit2+0x44>
801026a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        kfree(p);
801026a8:	83 ec 0c             	sub    $0xc,%esp
801026ab:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
    for (; p + PGSIZE <= (char*) vend; p += PGSIZE)
801026b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        kfree(p);
801026b7:	50                   	push   %eax
801026b8:	e8 83 fe ff ff       	call   80102540 <kfree>
    for (; p + PGSIZE <= (char*) vend; p += PGSIZE)
801026bd:	83 c4 10             	add    $0x10,%esp
801026c0:	39 de                	cmp    %ebx,%esi
801026c2:	73 e4                	jae    801026a8 <kinit2+0x28>
    kmem.use_lock = 1;
801026c4:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
801026cb:	00 00 00 
}
801026ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026d1:	5b                   	pop    %ebx
801026d2:	5e                   	pop    %esi
801026d3:	5d                   	pop    %ebp
801026d4:	c3                   	ret
801026d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801026e0 <kinit1>:
kinit1(void* vstart, void* vend) {
801026e0:	55                   	push   %ebp
801026e1:	89 e5                	mov    %esp,%ebp
801026e3:	56                   	push   %esi
801026e4:	53                   	push   %ebx
801026e5:	8b 75 0c             	mov    0xc(%ebp),%esi
    initlock(&kmem.lock, "kmem");
801026e8:	83 ec 08             	sub    $0x8,%esp
801026eb:	68 2c 79 10 80       	push   $0x8010792c
801026f0:	68 60 26 11 80       	push   $0x80112660
801026f5:	e8 f6 1e 00 00       	call   801045f0 <initlock>
    p = (char*) PGROUNDUP((uint) vstart);
801026fa:	8b 45 08             	mov    0x8(%ebp),%eax
    for (; p + PGSIZE <= (char*) vend; p += PGSIZE)
801026fd:	83 c4 10             	add    $0x10,%esp
    kmem.use_lock = 0;
80102700:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
80102707:	00 00 00 
    p = (char*) PGROUNDUP((uint) vstart);
8010270a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102710:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    for (; p + PGSIZE <= (char*) vend; p += PGSIZE)
80102716:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010271c:	39 de                	cmp    %ebx,%esi
8010271e:	72 1c                	jb     8010273c <kinit1+0x5c>
        kfree(p);
80102720:	83 ec 0c             	sub    $0xc,%esp
80102723:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
    for (; p + PGSIZE <= (char*) vend; p += PGSIZE)
80102729:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        kfree(p);
8010272f:	50                   	push   %eax
80102730:	e8 0b fe ff ff       	call   80102540 <kfree>
    for (; p + PGSIZE <= (char*) vend; p += PGSIZE)
80102735:	83 c4 10             	add    $0x10,%esp
80102738:	39 de                	cmp    %ebx,%esi
8010273a:	73 e4                	jae    80102720 <kinit1+0x40>
}
8010273c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010273f:	5b                   	pop    %ebx
80102740:	5e                   	pop    %esi
80102741:	5d                   	pop    %ebp
80102742:	c3                   	ret
80102743:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010274a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102750 <kalloc>:

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void) {
80102750:	55                   	push   %ebp
80102751:	89 e5                	mov    %esp,%ebp
80102753:	53                   	push   %ebx
80102754:	83 ec 04             	sub    $0x4,%esp
//            free_frame_cnt--; // xv6 proj - cow
//        }
//        if (kmem.use_lock) release(&kmem.lock);
//        return (char*) r;
//    }else {
        if (kmem.use_lock) acquire(&kmem.lock);
80102757:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
8010275d:	85 c9                	test   %ecx,%ecx
8010275f:	75 5f                	jne    801027c0 <kalloc+0x70>
        r = kmem.freelist;
80102761:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
        if (r) {
80102767:	85 db                	test   %ebx,%ebx
80102769:	0f 84 85 00 00 00    	je     801027f4 <kalloc+0xa4>
            kmem.freelist = r->next;
8010276f:	8b 03                	mov    (%ebx),%eax
            free_frame_cnt--; // xv6 proj - cow
80102771:	83 2d 44 26 11 80 01 	subl   $0x1,0x80112644
            kmem.freelist = r->next;
80102778:	a3 98 26 11 80       	mov    %eax,0x80112698
            r->ref = 1;
8010277d:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
        }
        if (kmem.use_lock) release(&kmem.lock);
80102784:	a1 94 26 11 80       	mov    0x80112694,%eax
80102789:	85 c0                	test   %eax,%eax
8010278b:	75 1b                	jne    801027a8 <kalloc+0x58>
        rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
8010278d:	81 eb 9c 26 11 80    	sub    $0x8011269c,%ebx
80102793:	c1 e3 09             	shl    $0x9,%ebx
80102796:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
        return rv;
//    }
}
8010279c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010279f:	c9                   	leave
801027a0:	c3                   	ret
801027a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (kmem.use_lock) release(&kmem.lock);
801027a8:	83 ec 0c             	sub    $0xc,%esp
801027ab:	68 60 26 11 80       	push   $0x80112660
801027b0:	e8 9b 20 00 00       	call   80104850 <release>
801027b5:	83 c4 10             	add    $0x10,%esp
801027b8:	eb d3                	jmp    8010278d <kalloc+0x3d>
801027ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (kmem.use_lock) acquire(&kmem.lock);
801027c0:	83 ec 0c             	sub    $0xc,%esp
801027c3:	68 60 26 11 80       	push   $0x80112660
801027c8:	e8 43 1f 00 00       	call   80104710 <acquire>
        r = kmem.freelist;
801027cd:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
        if (r) {
801027d3:	83 c4 10             	add    $0x10,%esp
801027d6:	85 db                	test   %ebx,%ebx
801027d8:	75 95                	jne    8010276f <kalloc+0x1f>
        if (kmem.use_lock) release(&kmem.lock);
801027da:	8b 15 94 26 11 80    	mov    0x80112694,%edx
801027e0:	85 d2                	test   %edx,%edx
801027e2:	74 10                	je     801027f4 <kalloc+0xa4>
801027e4:	83 ec 0c             	sub    $0xc,%esp
801027e7:	68 60 26 11 80       	push   $0x80112660
801027ec:	e8 5f 20 00 00       	call   80104850 <release>
801027f1:	83 c4 10             	add    $0x10,%esp
        rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
801027f4:	31 c0                	xor    %eax,%eax
801027f6:	eb a4                	jmp    8010279c <kalloc+0x4c>
801027f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ff:	90                   	nop

80102800 <kinc>:
//    rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
//    return rv;
//}

void
kinc(char* v) {
80102800:	55                   	push   %ebp
80102801:	89 e5                	mov    %esp,%ebp
80102803:	53                   	push   %ebx
80102804:	83 ec 04             	sub    $0x4,%esp
    struct run* r;

    if (kmem.use_lock)
80102807:	8b 15 94 26 11 80    	mov    0x80112694,%edx
kinc(char* v) {
8010280d:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (kmem.use_lock)
80102810:	85 d2                	test   %edx,%edx
80102812:	75 1c                	jne    80102830 <kinc+0x30>
        acquire(&kmem.lock);
    r = &kmem.runs[(V2P(v) / PGSIZE)];
80102814:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010281a:	c1 e8 0c             	shr    $0xc,%eax
    r->ref += 1;
8010281d:	83 04 c5 a0 26 11 80 	addl   $0x1,-0x7feed960(,%eax,8)
80102824:	01 
    if (kmem.use_lock)
        release(&kmem.lock);
}
80102825:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102828:	c9                   	leave
80102829:	c3                   	ret
8010282a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        acquire(&kmem.lock);
80102830:	83 ec 0c             	sub    $0xc,%esp
    r = &kmem.runs[(V2P(v) / PGSIZE)];
80102833:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
        acquire(&kmem.lock);
80102839:	68 60 26 11 80       	push   $0x80112660
    r = &kmem.runs[(V2P(v) / PGSIZE)];
8010283e:	c1 eb 0c             	shr    $0xc,%ebx
        acquire(&kmem.lock);
80102841:	e8 ca 1e 00 00       	call   80104710 <acquire>
    if (kmem.use_lock)
80102846:	a1 94 26 11 80       	mov    0x80112694,%eax
    r->ref += 1;
8010284b:	83 04 dd a0 26 11 80 	addl   $0x1,-0x7feed960(,%ebx,8)
80102852:	01 
    if (kmem.use_lock)
80102853:	83 c4 10             	add    $0x10,%esp
80102856:	85 c0                	test   %eax,%eax
80102858:	74 cb                	je     80102825 <kinc+0x25>
        release(&kmem.lock);
8010285a:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
80102861:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102864:	c9                   	leave
        release(&kmem.lock);
80102865:	e9 e6 1f 00 00       	jmp    80104850 <release>
8010286a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102870 <kdec>:

void
kdec(char* v) {
80102870:	55                   	push   %ebp
80102871:	89 e5                	mov    %esp,%ebp
80102873:	53                   	push   %ebx
80102874:	83 ec 04             	sub    $0x4,%esp
    struct run* r;

    if (kmem.use_lock)
80102877:	8b 15 94 26 11 80    	mov    0x80112694,%edx
kdec(char* v) {
8010287d:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (kmem.use_lock)
80102880:	85 d2                	test   %edx,%edx
80102882:	75 1c                	jne    801028a0 <kdec+0x30>
        acquire(&kmem.lock);
    r = &kmem.runs[(V2P(v) / PGSIZE)];
80102884:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010288a:	c1 e8 0c             	shr    $0xc,%eax
    r->ref -= 1;
8010288d:	83 2c c5 a0 26 11 80 	subl   $0x1,-0x7feed960(,%eax,8)
80102894:	01 
    if (kmem.use_lock)
        release(&kmem.lock);
}
80102895:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102898:	c9                   	leave
80102899:	c3                   	ret
8010289a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        acquire(&kmem.lock);
801028a0:	83 ec 0c             	sub    $0xc,%esp
    r = &kmem.runs[(V2P(v) / PGSIZE)];
801028a3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
        acquire(&kmem.lock);
801028a9:	68 60 26 11 80       	push   $0x80112660
    r = &kmem.runs[(V2P(v) / PGSIZE)];
801028ae:	c1 eb 0c             	shr    $0xc,%ebx
        acquire(&kmem.lock);
801028b1:	e8 5a 1e 00 00       	call   80104710 <acquire>
    if (kmem.use_lock)
801028b6:	a1 94 26 11 80       	mov    0x80112694,%eax
    r->ref -= 1;
801028bb:	83 2c dd a0 26 11 80 	subl   $0x1,-0x7feed960(,%ebx,8)
801028c2:	01 
    if (kmem.use_lock)
801028c3:	83 c4 10             	add    $0x10,%esp
801028c6:	85 c0                	test   %eax,%eax
801028c8:	74 cb                	je     80102895 <kdec+0x25>
        release(&kmem.lock);
801028ca:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
801028d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028d4:	c9                   	leave
        release(&kmem.lock);
801028d5:	e9 76 1f 00 00       	jmp    80104850 <release>
801028da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801028e0 <getRefs>:

int
getRefs(char* v) {
801028e0:	55                   	push   %ebp
801028e1:	89 e5                	mov    %esp,%ebp
    struct run* r;

    r = &kmem.runs[(V2P(v) / PGSIZE)];
801028e3:	8b 45 08             	mov    0x8(%ebp),%eax
    return r->ref;
}
801028e6:	5d                   	pop    %ebp
    r = &kmem.runs[(V2P(v) / PGSIZE)];
801028e7:	05 00 00 00 80       	add    $0x80000000,%eax
801028ec:	c1 e8 0c             	shr    $0xc,%eax
    return r->ref;
801028ef:	8b 04 c5 a0 26 11 80 	mov    -0x7feed960(,%eax,8),%eax
}
801028f6:	c3                   	ret
801028f7:	66 90                	xchg   %ax,%ax
801028f9:	66 90                	xchg   %ax,%ax
801028fb:	66 90                	xchg   %ax,%ax
801028fd:	66 90                	xchg   %ax,%ax
801028ff:	90                   	nop

80102900 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102900:	ba 64 00 00 00       	mov    $0x64,%edx
80102905:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102906:	a8 01                	test   $0x1,%al
80102908:	0f 84 c2 00 00 00    	je     801029d0 <kbdgetc+0xd0>
{
8010290e:	55                   	push   %ebp
8010290f:	ba 60 00 00 00       	mov    $0x60,%edx
80102914:	89 e5                	mov    %esp,%ebp
80102916:	53                   	push   %ebx
80102917:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102918:	8b 1d a0 26 18 80    	mov    0x801826a0,%ebx
  data = inb(KBDATAP);
8010291e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102921:	3c e0                	cmp    $0xe0,%al
80102923:	74 5b                	je     80102980 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102925:	89 da                	mov    %ebx,%edx
80102927:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010292a:	84 c0                	test   %al,%al
8010292c:	78 6a                	js     80102998 <kbdgetc+0x98>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010292e:	85 d2                	test   %edx,%edx
80102930:	74 09                	je     8010293b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102932:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102935:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102938:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010293b:	0f b6 91 60 7a 10 80 	movzbl -0x7fef85a0(%ecx),%edx
  shift ^= togglecode[data];
80102942:	0f b6 81 60 79 10 80 	movzbl -0x7fef86a0(%ecx),%eax
  shift |= shiftcode[data];
80102949:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010294b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010294d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010294f:	89 15 a0 26 18 80    	mov    %edx,0x801826a0
  c = charcode[shift & (CTL | SHIFT)][data];
80102955:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102958:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010295b:	8b 04 85 40 79 10 80 	mov    -0x7fef86c0(,%eax,4),%eax
80102962:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102966:	74 0b                	je     80102973 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102968:	8d 50 9f             	lea    -0x61(%eax),%edx
8010296b:	83 fa 19             	cmp    $0x19,%edx
8010296e:	77 48                	ja     801029b8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102970:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102973:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102976:	c9                   	leave
80102977:	c3                   	ret
80102978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010297f:	90                   	nop
    shift |= E0ESC;
80102980:	89 d8                	mov    %ebx,%eax
80102982:	83 c8 40             	or     $0x40,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102985:	a3 a0 26 18 80       	mov    %eax,0x801826a0
    return 0;
8010298a:	31 c0                	xor    %eax,%eax
}
8010298c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010298f:	c9                   	leave
80102990:	c3                   	ret
80102991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    data = (shift & E0ESC ? data : data & 0x7F);
80102998:	83 e0 7f             	and    $0x7f,%eax
8010299b:	85 d2                	test   %edx,%edx
8010299d:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
801029a0:	0f b6 81 60 7a 10 80 	movzbl -0x7fef85a0(%ecx),%eax
801029a7:	83 c8 40             	or     $0x40,%eax
801029aa:	0f b6 c0             	movzbl %al,%eax
801029ad:	f7 d0                	not    %eax
801029af:	21 d8                	and    %ebx,%eax
    return 0;
801029b1:	eb d2                	jmp    80102985 <kbdgetc+0x85>
801029b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029b7:	90                   	nop
    else if('A' <= c && c <= 'Z')
801029b8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801029bb:	8d 50 20             	lea    0x20(%eax),%edx
}
801029be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029c1:	c9                   	leave
      c += 'a' - 'A';
801029c2:	83 f9 1a             	cmp    $0x1a,%ecx
801029c5:	0f 42 c2             	cmovb  %edx,%eax
}
801029c8:	c3                   	ret
801029c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801029d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801029d5:	c3                   	ret
801029d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029dd:	8d 76 00             	lea    0x0(%esi),%esi

801029e0 <kbdintr>:

void
kbdintr(void)
{
801029e0:	55                   	push   %ebp
801029e1:	89 e5                	mov    %esp,%ebp
801029e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801029e6:	68 00 29 10 80       	push   $0x80102900
801029eb:	e8 d0 de ff ff       	call   801008c0 <consoleintr>
}
801029f0:	83 c4 10             	add    $0x10,%esp
801029f3:	c9                   	leave
801029f4:	c3                   	ret
801029f5:	66 90                	xchg   %ax,%ax
801029f7:	66 90                	xchg   %ax,%ax
801029f9:	66 90                	xchg   %ax,%ax
801029fb:	66 90                	xchg   %ax,%ax
801029fd:	66 90                	xchg   %ax,%ax
801029ff:	90                   	nop

80102a00 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102a00:	a1 a4 26 18 80       	mov    0x801826a4,%eax
80102a05:	85 c0                	test   %eax,%eax
80102a07:	0f 84 cb 00 00 00    	je     80102ad8 <lapicinit+0xd8>
  lapic[index] = value;
80102a0d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102a14:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a17:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a1a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102a21:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a24:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a27:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102a2e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102a31:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a34:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102a3b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102a3e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a41:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102a48:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a4b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a4e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102a55:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a58:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102a5b:	8b 50 30             	mov    0x30(%eax),%edx
80102a5e:	c1 ea 10             	shr    $0x10,%edx
80102a61:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102a67:	75 77                	jne    80102ae0 <lapicinit+0xe0>
  lapic[index] = value;
80102a69:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a70:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a73:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a76:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a7d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a80:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a83:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a8a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a8d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a90:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a97:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a9a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a9d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102aa4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aa7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102aaa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102ab1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102ab4:	8b 50 20             	mov    0x20(%eax),%edx
80102ab7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102abe:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102ac0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102ac6:	80 e6 10             	and    $0x10,%dh
80102ac9:	75 f5                	jne    80102ac0 <lapicinit+0xc0>
  lapic[index] = value;
80102acb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102ad2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ad5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102ad8:	c3                   	ret
80102ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102ae0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102ae7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102aea:	8b 50 20             	mov    0x20(%eax),%edx
}
80102aed:	e9 77 ff ff ff       	jmp    80102a69 <lapicinit+0x69>
80102af2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102b00 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102b00:	a1 a4 26 18 80       	mov    0x801826a4,%eax
80102b05:	85 c0                	test   %eax,%eax
80102b07:	74 07                	je     80102b10 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102b09:	8b 40 20             	mov    0x20(%eax),%eax
80102b0c:	c1 e8 18             	shr    $0x18,%eax
80102b0f:	c3                   	ret
    return 0;
80102b10:	31 c0                	xor    %eax,%eax
}
80102b12:	c3                   	ret
80102b13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102b20 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102b20:	a1 a4 26 18 80       	mov    0x801826a4,%eax
80102b25:	85 c0                	test   %eax,%eax
80102b27:	74 0d                	je     80102b36 <lapiceoi+0x16>
  lapic[index] = value;
80102b29:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b30:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b33:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102b36:	c3                   	ret
80102b37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b3e:	66 90                	xchg   %ax,%ax

80102b40 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102b40:	c3                   	ret
80102b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b4f:	90                   	nop

80102b50 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b50:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b51:	b8 0f 00 00 00       	mov    $0xf,%eax
80102b56:	ba 70 00 00 00       	mov    $0x70,%edx
80102b5b:	89 e5                	mov    %esp,%ebp
80102b5d:	53                   	push   %ebx
80102b5e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b64:	ee                   	out    %al,(%dx)
80102b65:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b6a:	ba 71 00 00 00       	mov    $0x71,%edx
80102b6f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b70:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80102b72:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102b75:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102b7b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b7d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80102b80:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102b82:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b85:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102b88:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102b8e:	a1 a4 26 18 80       	mov    0x801826a4,%eax
80102b93:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b99:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b9c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102ba3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ba6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ba9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102bb0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bb3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bb6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bbc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bbf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bc5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bc8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bd1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bd7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102bda:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bdd:	c9                   	leave
80102bde:	c3                   	ret
80102bdf:	90                   	nop

80102be0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102be0:	55                   	push   %ebp
80102be1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102be6:	ba 70 00 00 00       	mov    $0x70,%edx
80102beb:	89 e5                	mov    %esp,%ebp
80102bed:	57                   	push   %edi
80102bee:	56                   	push   %esi
80102bef:	53                   	push   %ebx
80102bf0:	83 ec 4c             	sub    $0x4c,%esp
80102bf3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bf4:	ba 71 00 00 00       	mov    $0x71,%edx
80102bf9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102bfa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bfd:	bf 70 00 00 00       	mov    $0x70,%edi
80102c02:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102c05:	8d 76 00             	lea    0x0(%esi),%esi
80102c08:	31 c0                	xor    %eax,%eax
80102c0a:	89 fa                	mov    %edi,%edx
80102c0c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c0d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102c12:	89 ca                	mov    %ecx,%edx
80102c14:	ec                   	in     (%dx),%al
80102c15:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c18:	89 fa                	mov    %edi,%edx
80102c1a:	b8 02 00 00 00       	mov    $0x2,%eax
80102c1f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c20:	89 ca                	mov    %ecx,%edx
80102c22:	ec                   	in     (%dx),%al
80102c23:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c26:	89 fa                	mov    %edi,%edx
80102c28:	b8 04 00 00 00       	mov    $0x4,%eax
80102c2d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c2e:	89 ca                	mov    %ecx,%edx
80102c30:	ec                   	in     (%dx),%al
80102c31:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c34:	89 fa                	mov    %edi,%edx
80102c36:	b8 07 00 00 00       	mov    $0x7,%eax
80102c3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c3c:	89 ca                	mov    %ecx,%edx
80102c3e:	ec                   	in     (%dx),%al
80102c3f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c42:	89 fa                	mov    %edi,%edx
80102c44:	b8 08 00 00 00       	mov    $0x8,%eax
80102c49:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c4a:	89 ca                	mov    %ecx,%edx
80102c4c:	ec                   	in     (%dx),%al
80102c4d:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c4f:	89 fa                	mov    %edi,%edx
80102c51:	b8 09 00 00 00       	mov    $0x9,%eax
80102c56:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c57:	89 ca                	mov    %ecx,%edx
80102c59:	ec                   	in     (%dx),%al
80102c5a:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c5d:	89 fa                	mov    %edi,%edx
80102c5f:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c64:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c65:	89 ca                	mov    %ecx,%edx
80102c67:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c68:	84 c0                	test   %al,%al
80102c6a:	78 9c                	js     80102c08 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102c6c:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102c70:	89 f2                	mov    %esi,%edx
80102c72:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102c75:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c78:	89 fa                	mov    %edi,%edx
80102c7a:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102c7d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102c81:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102c84:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102c87:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102c8b:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102c8e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102c92:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102c95:	31 c0                	xor    %eax,%eax
80102c97:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c98:	89 ca                	mov    %ecx,%edx
80102c9a:	ec                   	in     (%dx),%al
80102c9b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c9e:	89 fa                	mov    %edi,%edx
80102ca0:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102ca3:	b8 02 00 00 00       	mov    $0x2,%eax
80102ca8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ca9:	89 ca                	mov    %ecx,%edx
80102cab:	ec                   	in     (%dx),%al
80102cac:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102caf:	89 fa                	mov    %edi,%edx
80102cb1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102cb4:	b8 04 00 00 00       	mov    $0x4,%eax
80102cb9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cba:	89 ca                	mov    %ecx,%edx
80102cbc:	ec                   	in     (%dx),%al
80102cbd:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cc0:	89 fa                	mov    %edi,%edx
80102cc2:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102cc5:	b8 07 00 00 00       	mov    $0x7,%eax
80102cca:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ccb:	89 ca                	mov    %ecx,%edx
80102ccd:	ec                   	in     (%dx),%al
80102cce:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cd1:	89 fa                	mov    %edi,%edx
80102cd3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102cd6:	b8 08 00 00 00       	mov    $0x8,%eax
80102cdb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cdc:	89 ca                	mov    %ecx,%edx
80102cde:	ec                   	in     (%dx),%al
80102cdf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ce2:	89 fa                	mov    %edi,%edx
80102ce4:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ce7:	b8 09 00 00 00       	mov    $0x9,%eax
80102cec:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ced:	89 ca                	mov    %ecx,%edx
80102cef:	ec                   	in     (%dx),%al
80102cf0:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102cf3:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102cf6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102cf9:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102cfc:	6a 18                	push   $0x18
80102cfe:	50                   	push   %eax
80102cff:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102d02:	50                   	push   %eax
80102d03:	e8 d8 1b 00 00       	call   801048e0 <memcmp>
80102d08:	83 c4 10             	add    $0x10,%esp
80102d0b:	85 c0                	test   %eax,%eax
80102d0d:	0f 85 f5 fe ff ff    	jne    80102c08 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102d13:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102d17:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102d1a:	89 f0                	mov    %esi,%eax
80102d1c:	84 c0                	test   %al,%al
80102d1e:	75 78                	jne    80102d98 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102d20:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d23:	89 c2                	mov    %eax,%edx
80102d25:	83 e0 0f             	and    $0xf,%eax
80102d28:	c1 ea 04             	shr    $0x4,%edx
80102d2b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d2e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d31:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102d34:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d37:	89 c2                	mov    %eax,%edx
80102d39:	83 e0 0f             	and    $0xf,%eax
80102d3c:	c1 ea 04             	shr    $0x4,%edx
80102d3f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d42:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d45:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102d48:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d4b:	89 c2                	mov    %eax,%edx
80102d4d:	83 e0 0f             	and    $0xf,%eax
80102d50:	c1 ea 04             	shr    $0x4,%edx
80102d53:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d56:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d59:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102d5c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d5f:	89 c2                	mov    %eax,%edx
80102d61:	83 e0 0f             	and    $0xf,%eax
80102d64:	c1 ea 04             	shr    $0x4,%edx
80102d67:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d6a:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d6d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d70:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d73:	89 c2                	mov    %eax,%edx
80102d75:	83 e0 0f             	and    $0xf,%eax
80102d78:	c1 ea 04             	shr    $0x4,%edx
80102d7b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d7e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d81:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102d84:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d87:	89 c2                	mov    %eax,%edx
80102d89:	83 e0 0f             	and    $0xf,%eax
80102d8c:	c1 ea 04             	shr    $0x4,%edx
80102d8f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d92:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d95:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d98:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d9b:	89 03                	mov    %eax,(%ebx)
80102d9d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102da0:	89 43 04             	mov    %eax,0x4(%ebx)
80102da3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102da6:	89 43 08             	mov    %eax,0x8(%ebx)
80102da9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102dac:	89 43 0c             	mov    %eax,0xc(%ebx)
80102daf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102db2:	89 43 10             	mov    %eax,0x10(%ebx)
80102db5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102db8:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102dbb:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102dc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dc5:	5b                   	pop    %ebx
80102dc6:	5e                   	pop    %esi
80102dc7:	5f                   	pop    %edi
80102dc8:	5d                   	pop    %ebp
80102dc9:	c3                   	ret
80102dca:	66 90                	xchg   %ax,%ax
80102dcc:	66 90                	xchg   %ax,%ax
80102dce:	66 90                	xchg   %ax,%ax

80102dd0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102dd0:	8b 0d 08 27 18 80    	mov    0x80182708,%ecx
80102dd6:	85 c9                	test   %ecx,%ecx
80102dd8:	0f 8e 8a 00 00 00    	jle    80102e68 <install_trans+0x98>
{
80102dde:	55                   	push   %ebp
80102ddf:	89 e5                	mov    %esp,%ebp
80102de1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102de2:	31 ff                	xor    %edi,%edi
{
80102de4:	56                   	push   %esi
80102de5:	53                   	push   %ebx
80102de6:	83 ec 0c             	sub    $0xc,%esp
80102de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102df0:	a1 f4 26 18 80       	mov    0x801826f4,%eax
80102df5:	83 ec 08             	sub    $0x8,%esp
80102df8:	01 f8                	add    %edi,%eax
80102dfa:	83 c0 01             	add    $0x1,%eax
80102dfd:	50                   	push   %eax
80102dfe:	ff 35 04 27 18 80    	push   0x80182704
80102e04:	e8 c7 d2 ff ff       	call   801000d0 <bread>
80102e09:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e0b:	58                   	pop    %eax
80102e0c:	5a                   	pop    %edx
80102e0d:	ff 34 bd 0c 27 18 80 	push   -0x7fe7d8f4(,%edi,4)
80102e14:	ff 35 04 27 18 80    	push   0x80182704
  for (tail = 0; tail < log.lh.n; tail++) {
80102e1a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e1d:	e8 ae d2 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102e22:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e25:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102e27:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e2a:	68 00 02 00 00       	push   $0x200
80102e2f:	50                   	push   %eax
80102e30:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102e33:	50                   	push   %eax
80102e34:	e8 f7 1a 00 00       	call   80104930 <memmove>
    bwrite(dbuf);  // write dst to disk
80102e39:	89 1c 24             	mov    %ebx,(%esp)
80102e3c:	e8 6f d3 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102e41:	89 34 24             	mov    %esi,(%esp)
80102e44:	e8 a7 d3 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102e49:	89 1c 24             	mov    %ebx,(%esp)
80102e4c:	e8 9f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e51:	83 c4 10             	add    $0x10,%esp
80102e54:	39 3d 08 27 18 80    	cmp    %edi,0x80182708
80102e5a:	7f 94                	jg     80102df0 <install_trans+0x20>
  }
}
80102e5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e5f:	5b                   	pop    %ebx
80102e60:	5e                   	pop    %esi
80102e61:	5f                   	pop    %edi
80102e62:	5d                   	pop    %ebp
80102e63:	c3                   	ret
80102e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e68:	c3                   	ret
80102e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e70 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	53                   	push   %ebx
80102e74:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e77:	ff 35 f4 26 18 80    	push   0x801826f4
80102e7d:	ff 35 04 27 18 80    	push   0x80182704
80102e83:	e8 48 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102e88:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e8b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102e8d:	a1 08 27 18 80       	mov    0x80182708,%eax
80102e92:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102e95:	85 c0                	test   %eax,%eax
80102e97:	7e 19                	jle    80102eb2 <write_head+0x42>
80102e99:	31 d2                	xor    %edx,%edx
80102e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e9f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102ea0:	8b 0c 95 0c 27 18 80 	mov    -0x7fe7d8f4(,%edx,4),%ecx
80102ea7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102eab:	83 c2 01             	add    $0x1,%edx
80102eae:	39 d0                	cmp    %edx,%eax
80102eb0:	75 ee                	jne    80102ea0 <write_head+0x30>
  }
  bwrite(buf);
80102eb2:	83 ec 0c             	sub    $0xc,%esp
80102eb5:	53                   	push   %ebx
80102eb6:	e8 f5 d2 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102ebb:	89 1c 24             	mov    %ebx,(%esp)
80102ebe:	e8 2d d3 ff ff       	call   801001f0 <brelse>
}
80102ec3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ec6:	83 c4 10             	add    $0x10,%esp
80102ec9:	c9                   	leave
80102eca:	c3                   	ret
80102ecb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ecf:	90                   	nop

80102ed0 <initlog>:
{
80102ed0:	55                   	push   %ebp
80102ed1:	89 e5                	mov    %esp,%ebp
80102ed3:	53                   	push   %ebx
80102ed4:	83 ec 2c             	sub    $0x2c,%esp
80102ed7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102eda:	68 60 7b 10 80       	push   $0x80107b60
80102edf:	68 c0 26 18 80       	push   $0x801826c0
80102ee4:	e8 07 17 00 00       	call   801045f0 <initlock>
  readsb(dev, &sb);
80102ee9:	58                   	pop    %eax
80102eea:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102eed:	5a                   	pop    %edx
80102eee:	50                   	push   %eax
80102eef:	53                   	push   %ebx
80102ef0:	e8 9b e6 ff ff       	call   80101590 <readsb>
  log.size = sb.nlog;
80102ef5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102ef8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.dev = dev;
80102efb:	89 1d 04 27 18 80    	mov    %ebx,0x80182704
  log.start = sb.logstart;
80102f01:	a3 f4 26 18 80       	mov    %eax,0x801826f4
  log.size = sb.nlog;
80102f06:	89 15 f8 26 18 80    	mov    %edx,0x801826f8
  struct buf *buf = bread(log.dev, log.start);
80102f0c:	59                   	pop    %ecx
80102f0d:	5a                   	pop    %edx
80102f0e:	50                   	push   %eax
80102f0f:	53                   	push   %ebx
80102f10:	e8 bb d1 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102f15:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102f18:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102f1b:	89 1d 08 27 18 80    	mov    %ebx,0x80182708
  for (i = 0; i < log.lh.n; i++) {
80102f21:	85 db                	test   %ebx,%ebx
80102f23:	7e 1d                	jle    80102f42 <initlog+0x72>
80102f25:	31 d2                	xor    %edx,%edx
80102f27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f2e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102f30:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102f34:	89 0c 95 0c 27 18 80 	mov    %ecx,-0x7fe7d8f4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102f3b:	83 c2 01             	add    $0x1,%edx
80102f3e:	39 d3                	cmp    %edx,%ebx
80102f40:	75 ee                	jne    80102f30 <initlog+0x60>
  brelse(buf);
80102f42:	83 ec 0c             	sub    $0xc,%esp
80102f45:	50                   	push   %eax
80102f46:	e8 a5 d2 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102f4b:	e8 80 fe ff ff       	call   80102dd0 <install_trans>
  log.lh.n = 0;
80102f50:	c7 05 08 27 18 80 00 	movl   $0x0,0x80182708
80102f57:	00 00 00 
  write_head(); // clear the log
80102f5a:	e8 11 ff ff ff       	call   80102e70 <write_head>
}
80102f5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f62:	83 c4 10             	add    $0x10,%esp
80102f65:	c9                   	leave
80102f66:	c3                   	ret
80102f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f6e:	66 90                	xchg   %ax,%ax

80102f70 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f70:	55                   	push   %ebp
80102f71:	89 e5                	mov    %esp,%ebp
80102f73:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f76:	68 c0 26 18 80       	push   $0x801826c0
80102f7b:	e8 90 17 00 00       	call   80104710 <acquire>
80102f80:	83 c4 10             	add    $0x10,%esp
80102f83:	eb 18                	jmp    80102f9d <begin_op+0x2d>
80102f85:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f88:	83 ec 08             	sub    $0x8,%esp
80102f8b:	68 c0 26 18 80       	push   $0x801826c0
80102f90:	68 c0 26 18 80       	push   $0x801826c0
80102f95:	e8 e6 12 00 00       	call   80104280 <sleep>
80102f9a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102f9d:	a1 00 27 18 80       	mov    0x80182700,%eax
80102fa2:	85 c0                	test   %eax,%eax
80102fa4:	75 e2                	jne    80102f88 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102fa6:	a1 fc 26 18 80       	mov    0x801826fc,%eax
80102fab:	8b 15 08 27 18 80    	mov    0x80182708,%edx
80102fb1:	83 c0 01             	add    $0x1,%eax
80102fb4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102fb7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102fba:	83 fa 1e             	cmp    $0x1e,%edx
80102fbd:	7f c9                	jg     80102f88 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102fbf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102fc2:	a3 fc 26 18 80       	mov    %eax,0x801826fc
      release(&log.lock);
80102fc7:	68 c0 26 18 80       	push   $0x801826c0
80102fcc:	e8 7f 18 00 00       	call   80104850 <release>
      break;
    }
  }
}
80102fd1:	83 c4 10             	add    $0x10,%esp
80102fd4:	c9                   	leave
80102fd5:	c3                   	ret
80102fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fdd:	8d 76 00             	lea    0x0(%esi),%esi

80102fe0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	57                   	push   %edi
80102fe4:	56                   	push   %esi
80102fe5:	53                   	push   %ebx
80102fe6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102fe9:	68 c0 26 18 80       	push   $0x801826c0
80102fee:	e8 1d 17 00 00       	call   80104710 <acquire>
  log.outstanding -= 1;
80102ff3:	a1 fc 26 18 80       	mov    0x801826fc,%eax
  if(log.committing)
80102ff8:	8b 35 00 27 18 80    	mov    0x80182700,%esi
80102ffe:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103001:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103004:	89 1d fc 26 18 80    	mov    %ebx,0x801826fc
  if(log.committing)
8010300a:	85 f6                	test   %esi,%esi
8010300c:	0f 85 22 01 00 00    	jne    80103134 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103012:	85 db                	test   %ebx,%ebx
80103014:	0f 85 f6 00 00 00    	jne    80103110 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010301a:	c7 05 00 27 18 80 01 	movl   $0x1,0x80182700
80103021:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103024:	83 ec 0c             	sub    $0xc,%esp
80103027:	68 c0 26 18 80       	push   $0x801826c0
8010302c:	e8 1f 18 00 00       	call   80104850 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103031:	8b 0d 08 27 18 80    	mov    0x80182708,%ecx
80103037:	83 c4 10             	add    $0x10,%esp
8010303a:	85 c9                	test   %ecx,%ecx
8010303c:	7f 42                	jg     80103080 <end_op+0xa0>
    acquire(&log.lock);
8010303e:	83 ec 0c             	sub    $0xc,%esp
80103041:	68 c0 26 18 80       	push   $0x801826c0
80103046:	e8 c5 16 00 00       	call   80104710 <acquire>
    log.committing = 0;
8010304b:	c7 05 00 27 18 80 00 	movl   $0x0,0x80182700
80103052:	00 00 00 
    wakeup(&log);
80103055:	c7 04 24 c0 26 18 80 	movl   $0x801826c0,(%esp)
8010305c:	e8 df 12 00 00       	call   80104340 <wakeup>
    release(&log.lock);
80103061:	c7 04 24 c0 26 18 80 	movl   $0x801826c0,(%esp)
80103068:	e8 e3 17 00 00       	call   80104850 <release>
8010306d:	83 c4 10             	add    $0x10,%esp
}
80103070:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103073:	5b                   	pop    %ebx
80103074:	5e                   	pop    %esi
80103075:	5f                   	pop    %edi
80103076:	5d                   	pop    %ebp
80103077:	c3                   	ret
80103078:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010307f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103080:	a1 f4 26 18 80       	mov    0x801826f4,%eax
80103085:	83 ec 08             	sub    $0x8,%esp
80103088:	01 d8                	add    %ebx,%eax
8010308a:	83 c0 01             	add    $0x1,%eax
8010308d:	50                   	push   %eax
8010308e:	ff 35 04 27 18 80    	push   0x80182704
80103094:	e8 37 d0 ff ff       	call   801000d0 <bread>
80103099:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010309b:	58                   	pop    %eax
8010309c:	5a                   	pop    %edx
8010309d:	ff 34 9d 0c 27 18 80 	push   -0x7fe7d8f4(,%ebx,4)
801030a4:	ff 35 04 27 18 80    	push   0x80182704
  for (tail = 0; tail < log.lh.n; tail++) {
801030aa:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801030ad:	e8 1e d0 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801030b2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801030b5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801030b7:	8d 40 5c             	lea    0x5c(%eax),%eax
801030ba:	68 00 02 00 00       	push   $0x200
801030bf:	50                   	push   %eax
801030c0:	8d 46 5c             	lea    0x5c(%esi),%eax
801030c3:	50                   	push   %eax
801030c4:	e8 67 18 00 00       	call   80104930 <memmove>
    bwrite(to);  // write the log
801030c9:	89 34 24             	mov    %esi,(%esp)
801030cc:	e8 df d0 ff ff       	call   801001b0 <bwrite>
    brelse(from);
801030d1:	89 3c 24             	mov    %edi,(%esp)
801030d4:	e8 17 d1 ff ff       	call   801001f0 <brelse>
    brelse(to);
801030d9:	89 34 24             	mov    %esi,(%esp)
801030dc:	e8 0f d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801030e1:	83 c4 10             	add    $0x10,%esp
801030e4:	3b 1d 08 27 18 80    	cmp    0x80182708,%ebx
801030ea:	7c 94                	jl     80103080 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801030ec:	e8 7f fd ff ff       	call   80102e70 <write_head>
    install_trans(); // Now install writes to home locations
801030f1:	e8 da fc ff ff       	call   80102dd0 <install_trans>
    log.lh.n = 0;
801030f6:	c7 05 08 27 18 80 00 	movl   $0x0,0x80182708
801030fd:	00 00 00 
    write_head();    // Erase the transaction from the log
80103100:	e8 6b fd ff ff       	call   80102e70 <write_head>
80103105:	e9 34 ff ff ff       	jmp    8010303e <end_op+0x5e>
8010310a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103110:	83 ec 0c             	sub    $0xc,%esp
80103113:	68 c0 26 18 80       	push   $0x801826c0
80103118:	e8 23 12 00 00       	call   80104340 <wakeup>
  release(&log.lock);
8010311d:	c7 04 24 c0 26 18 80 	movl   $0x801826c0,(%esp)
80103124:	e8 27 17 00 00       	call   80104850 <release>
80103129:	83 c4 10             	add    $0x10,%esp
}
8010312c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010312f:	5b                   	pop    %ebx
80103130:	5e                   	pop    %esi
80103131:	5f                   	pop    %edi
80103132:	5d                   	pop    %ebp
80103133:	c3                   	ret
    panic("log.committing");
80103134:	83 ec 0c             	sub    $0xc,%esp
80103137:	68 64 7b 10 80       	push   $0x80107b64
8010313c:	e8 3f d2 ff ff       	call   80100380 <panic>
80103141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103148:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010314f:	90                   	nop

80103150 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103150:	55                   	push   %ebp
80103151:	89 e5                	mov    %esp,%ebp
80103153:	53                   	push   %ebx
80103154:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103157:	8b 15 08 27 18 80    	mov    0x80182708,%edx
{
8010315d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103160:	83 fa 1d             	cmp    $0x1d,%edx
80103163:	7f 7d                	jg     801031e2 <log_write+0x92>
80103165:	a1 f8 26 18 80       	mov    0x801826f8,%eax
8010316a:	83 e8 01             	sub    $0x1,%eax
8010316d:	39 c2                	cmp    %eax,%edx
8010316f:	7d 71                	jge    801031e2 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103171:	a1 fc 26 18 80       	mov    0x801826fc,%eax
80103176:	85 c0                	test   %eax,%eax
80103178:	7e 75                	jle    801031ef <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010317a:	83 ec 0c             	sub    $0xc,%esp
8010317d:	68 c0 26 18 80       	push   $0x801826c0
80103182:	e8 89 15 00 00       	call   80104710 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103187:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010318a:	83 c4 10             	add    $0x10,%esp
8010318d:	31 c0                	xor    %eax,%eax
8010318f:	8b 15 08 27 18 80    	mov    0x80182708,%edx
80103195:	85 d2                	test   %edx,%edx
80103197:	7f 0e                	jg     801031a7 <log_write+0x57>
80103199:	eb 15                	jmp    801031b0 <log_write+0x60>
8010319b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010319f:	90                   	nop
801031a0:	83 c0 01             	add    $0x1,%eax
801031a3:	39 c2                	cmp    %eax,%edx
801031a5:	74 29                	je     801031d0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801031a7:	39 0c 85 0c 27 18 80 	cmp    %ecx,-0x7fe7d8f4(,%eax,4)
801031ae:	75 f0                	jne    801031a0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
801031b0:	89 0c 85 0c 27 18 80 	mov    %ecx,-0x7fe7d8f4(,%eax,4)
  if (i == log.lh.n)
801031b7:	39 c2                	cmp    %eax,%edx
801031b9:	74 1c                	je     801031d7 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801031bb:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801031be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801031c1:	c7 45 08 c0 26 18 80 	movl   $0x801826c0,0x8(%ebp)
}
801031c8:	c9                   	leave
  release(&log.lock);
801031c9:	e9 82 16 00 00       	jmp    80104850 <release>
801031ce:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
801031d0:	89 0c 95 0c 27 18 80 	mov    %ecx,-0x7fe7d8f4(,%edx,4)
    log.lh.n++;
801031d7:	83 c2 01             	add    $0x1,%edx
801031da:	89 15 08 27 18 80    	mov    %edx,0x80182708
801031e0:	eb d9                	jmp    801031bb <log_write+0x6b>
    panic("too big a transaction");
801031e2:	83 ec 0c             	sub    $0xc,%esp
801031e5:	68 73 7b 10 80       	push   $0x80107b73
801031ea:	e8 91 d1 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
801031ef:	83 ec 0c             	sub    $0xc,%esp
801031f2:	68 89 7b 10 80       	push   $0x80107b89
801031f7:	e8 84 d1 ff ff       	call   80100380 <panic>
801031fc:	66 90                	xchg   %ax,%ax
801031fe:	66 90                	xchg   %ax,%ax

80103200 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103200:	55                   	push   %ebp
80103201:	89 e5                	mov    %esp,%ebp
80103203:	53                   	push   %ebx
80103204:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103207:	e8 64 09 00 00       	call   80103b70 <cpuid>
8010320c:	89 c3                	mov    %eax,%ebx
8010320e:	e8 5d 09 00 00       	call   80103b70 <cpuid>
80103213:	83 ec 04             	sub    $0x4,%esp
80103216:	53                   	push   %ebx
80103217:	50                   	push   %eax
80103218:	68 a4 7b 10 80       	push   $0x80107ba4
8010321d:	e8 8e d4 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103222:	e8 39 29 00 00       	call   80105b60 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103227:	e8 e4 08 00 00       	call   80103b10 <mycpu>
8010322c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010322e:	b8 01 00 00 00       	mov    $0x1,%eax
80103233:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010323a:	e8 21 0c 00 00       	call   80103e60 <scheduler>
8010323f:	90                   	nop

80103240 <mpenter>:
{
80103240:	55                   	push   %ebp
80103241:	89 e5                	mov    %esp,%ebp
80103243:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103246:	e8 35 3a 00 00       	call   80106c80 <switchkvm>
  seginit();
8010324b:	e8 a0 39 00 00       	call   80106bf0 <seginit>
  lapicinit();
80103250:	e8 ab f7 ff ff       	call   80102a00 <lapicinit>
  mpmain();
80103255:	e8 a6 ff ff ff       	call   80103200 <mpmain>
8010325a:	66 90                	xchg   %ax,%ax
8010325c:	66 90                	xchg   %ax,%ax
8010325e:	66 90                	xchg   %ax,%ax

80103260 <main>:
{
80103260:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103264:	83 e4 f0             	and    $0xfffffff0,%esp
80103267:	ff 71 fc             	push   -0x4(%ecx)
8010326a:	55                   	push   %ebp
8010326b:	89 e5                	mov    %esp,%ebp
8010326d:	53                   	push   %ebx
8010326e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010326f:	83 ec 08             	sub    $0x8,%esp
80103272:	68 00 00 40 80       	push   $0x80400000
80103277:	68 f0 64 18 80       	push   $0x801864f0
8010327c:	e8 5f f4 ff ff       	call   801026e0 <kinit1>
  kvmalloc();      // kernel page table
80103281:	e8 ba 3e 00 00       	call   80107140 <kvmalloc>
  mpinit();        // detect other processors
80103286:	e8 85 01 00 00       	call   80103410 <mpinit>
  lapicinit();     // interrupt controller
8010328b:	e8 70 f7 ff ff       	call   80102a00 <lapicinit>
  seginit();       // segment descriptors
80103290:	e8 5b 39 00 00       	call   80106bf0 <seginit>
  picinit();       // disable pic
80103295:	e8 86 03 00 00       	call   80103620 <picinit>
  ioapicinit();    // another interrupt controller
8010329a:	e8 c1 f1 ff ff       	call   80102460 <ioapicinit>
  consoleinit();   // console hardware
8010329f:	e8 ec d7 ff ff       	call   80100a90 <consoleinit>
  uartinit();      // serial port
801032a4:	e8 97 2b 00 00       	call   80105e40 <uartinit>
  pinit();         // process table
801032a9:	e8 42 08 00 00       	call   80103af0 <pinit>
  tvinit();        // trap vectors
801032ae:	e8 2d 28 00 00       	call   80105ae0 <tvinit>
  binit();         // buffer cache
801032b3:	e8 88 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
801032b8:	e8 a3 db ff ff       	call   80100e60 <fileinit>
  ideinit();       // disk 
801032bd:	e8 7e ef ff ff       	call   80102240 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801032c2:	83 c4 0c             	add    $0xc,%esp
801032c5:	68 8a 00 00 00       	push   $0x8a
801032ca:	68 8c b4 10 80       	push   $0x8010b48c
801032cf:	68 00 70 00 80       	push   $0x80007000
801032d4:	e8 57 16 00 00       	call   80104930 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801032d9:	83 c4 10             	add    $0x10,%esp
801032dc:	69 05 a4 27 18 80 b0 	imul   $0xb0,0x801827a4,%eax
801032e3:	00 00 00 
801032e6:	05 c0 27 18 80       	add    $0x801827c0,%eax
801032eb:	3d c0 27 18 80       	cmp    $0x801827c0,%eax
801032f0:	76 7e                	jbe    80103370 <main+0x110>
801032f2:	bb c0 27 18 80       	mov    $0x801827c0,%ebx
801032f7:	eb 20                	jmp    80103319 <main+0xb9>
801032f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103300:	69 05 a4 27 18 80 b0 	imul   $0xb0,0x801827a4,%eax
80103307:	00 00 00 
8010330a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103310:	05 c0 27 18 80       	add    $0x801827c0,%eax
80103315:	39 c3                	cmp    %eax,%ebx
80103317:	73 57                	jae    80103370 <main+0x110>
    if(c == mycpu())  // We've started already.
80103319:	e8 f2 07 00 00       	call   80103b10 <mycpu>
8010331e:	39 c3                	cmp    %eax,%ebx
80103320:	74 de                	je     80103300 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103322:	e8 29 f4 ff ff       	call   80102750 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103327:	83 ec 08             	sub    $0x8,%esp
    *(void**)(code-8) = mpenter;
8010332a:	c7 05 f8 6f 00 80 40 	movl   $0x80103240,0x80006ff8
80103331:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103334:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010333b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010333e:	05 00 10 00 00       	add    $0x1000,%eax
80103343:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103348:	0f b6 03             	movzbl (%ebx),%eax
8010334b:	68 00 70 00 00       	push   $0x7000
80103350:	50                   	push   %eax
80103351:	e8 fa f7 ff ff       	call   80102b50 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103356:	83 c4 10             	add    $0x10,%esp
80103359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103360:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103366:	85 c0                	test   %eax,%eax
80103368:	74 f6                	je     80103360 <main+0x100>
8010336a:	eb 94                	jmp    80103300 <main+0xa0>
8010336c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103370:	83 ec 08             	sub    $0x8,%esp
80103373:	68 00 00 00 8e       	push   $0x8e000000
80103378:	68 00 00 40 80       	push   $0x80400000
8010337d:	e8 fe f2 ff ff       	call   80102680 <kinit2>
  userinit();      // first user process
80103382:	e8 39 08 00 00       	call   80103bc0 <userinit>
  mpmain();        // finish this processor's setup
80103387:	e8 74 fe ff ff       	call   80103200 <mpmain>
8010338c:	66 90                	xchg   %ax,%ax
8010338e:	66 90                	xchg   %ax,%ax

80103390 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103390:	55                   	push   %ebp
80103391:	89 e5                	mov    %esp,%ebp
80103393:	57                   	push   %edi
80103394:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103395:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010339b:	53                   	push   %ebx
  e = addr+len;
8010339c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010339f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801033a2:	39 de                	cmp    %ebx,%esi
801033a4:	72 10                	jb     801033b6 <mpsearch1+0x26>
801033a6:	eb 50                	jmp    801033f8 <mpsearch1+0x68>
801033a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033af:	90                   	nop
801033b0:	89 fe                	mov    %edi,%esi
801033b2:	39 df                	cmp    %ebx,%edi
801033b4:	73 42                	jae    801033f8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033b6:	83 ec 04             	sub    $0x4,%esp
801033b9:	8d 7e 10             	lea    0x10(%esi),%edi
801033bc:	6a 04                	push   $0x4
801033be:	68 b8 7b 10 80       	push   $0x80107bb8
801033c3:	56                   	push   %esi
801033c4:	e8 17 15 00 00       	call   801048e0 <memcmp>
801033c9:	83 c4 10             	add    $0x10,%esp
801033cc:	85 c0                	test   %eax,%eax
801033ce:	75 e0                	jne    801033b0 <mpsearch1+0x20>
801033d0:	89 f2                	mov    %esi,%edx
801033d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801033d8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033db:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033de:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033e0:	39 fa                	cmp    %edi,%edx
801033e2:	75 f4                	jne    801033d8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033e4:	84 c0                	test   %al,%al
801033e6:	75 c8                	jne    801033b0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801033e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033eb:	89 f0                	mov    %esi,%eax
801033ed:	5b                   	pop    %ebx
801033ee:	5e                   	pop    %esi
801033ef:	5f                   	pop    %edi
801033f0:	5d                   	pop    %ebp
801033f1:	c3                   	ret
801033f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801033f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801033fb:	31 f6                	xor    %esi,%esi
}
801033fd:	5b                   	pop    %ebx
801033fe:	89 f0                	mov    %esi,%eax
80103400:	5e                   	pop    %esi
80103401:	5f                   	pop    %edi
80103402:	5d                   	pop    %ebp
80103403:	c3                   	ret
80103404:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010340b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010340f:	90                   	nop

80103410 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103410:	55                   	push   %ebp
80103411:	89 e5                	mov    %esp,%ebp
80103413:	57                   	push   %edi
80103414:	56                   	push   %esi
80103415:	53                   	push   %ebx
80103416:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103419:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103420:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103427:	c1 e0 08             	shl    $0x8,%eax
8010342a:	09 d0                	or     %edx,%eax
8010342c:	c1 e0 04             	shl    $0x4,%eax
8010342f:	75 1b                	jne    8010344c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103431:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103438:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010343f:	c1 e0 08             	shl    $0x8,%eax
80103442:	09 d0                	or     %edx,%eax
80103444:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103447:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010344c:	ba 00 04 00 00       	mov    $0x400,%edx
80103451:	e8 3a ff ff ff       	call   80103390 <mpsearch1>
80103456:	89 c3                	mov    %eax,%ebx
80103458:	85 c0                	test   %eax,%eax
8010345a:	0f 84 50 01 00 00    	je     801035b0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103460:	8b 73 04             	mov    0x4(%ebx),%esi
80103463:	85 f6                	test   %esi,%esi
80103465:	0f 84 35 01 00 00    	je     801035a0 <mpinit+0x190>
  if(memcmp(conf, "PCMP", 4) != 0)
8010346b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010346e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80103474:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103477:	6a 04                	push   $0x4
80103479:	68 bd 7b 10 80       	push   $0x80107bbd
8010347e:	50                   	push   %eax
8010347f:	e8 5c 14 00 00       	call   801048e0 <memcmp>
80103484:	83 c4 10             	add    $0x10,%esp
80103487:	85 c0                	test   %eax,%eax
80103489:	0f 85 11 01 00 00    	jne    801035a0 <mpinit+0x190>
  if(conf->version != 1 && conf->version != 4)
8010348f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103496:	3c 01                	cmp    $0x1,%al
80103498:	74 08                	je     801034a2 <mpinit+0x92>
8010349a:	3c 04                	cmp    $0x4,%al
8010349c:	0f 85 fe 00 00 00    	jne    801035a0 <mpinit+0x190>
  if(sum((uchar*)conf, conf->length) != 0)
801034a2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801034a9:	66 85 d2             	test   %dx,%dx
801034ac:	74 22                	je     801034d0 <mpinit+0xc0>
801034ae:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801034b1:	89 f0                	mov    %esi,%eax
  sum = 0;
801034b3:	31 d2                	xor    %edx,%edx
801034b5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801034b8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801034bf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801034c2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801034c4:	39 c7                	cmp    %eax,%edi
801034c6:	75 f0                	jne    801034b8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801034c8:	84 d2                	test   %dl,%dl
801034ca:	0f 85 d0 00 00 00    	jne    801035a0 <mpinit+0x190>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801034d0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801034d9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
801034dc:	a3 a4 26 18 80       	mov    %eax,0x801826a4
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034e1:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801034e8:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801034ee:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034f3:	01 d7                	add    %edx,%edi
801034f5:	89 fa                	mov    %edi,%edx
801034f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034fe:	66 90                	xchg   %ax,%ax
80103500:	39 d0                	cmp    %edx,%eax
80103502:	73 15                	jae    80103519 <mpinit+0x109>
    switch(*p){
80103504:	0f b6 08             	movzbl (%eax),%ecx
80103507:	80 f9 02             	cmp    $0x2,%cl
8010350a:	74 54                	je     80103560 <mpinit+0x150>
8010350c:	77 42                	ja     80103550 <mpinit+0x140>
8010350e:	84 c9                	test   %cl,%cl
80103510:	74 5e                	je     80103570 <mpinit+0x160>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103512:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103515:	39 d0                	cmp    %edx,%eax
80103517:	72 eb                	jb     80103504 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103519:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010351c:	85 f6                	test   %esi,%esi
8010351e:	0f 84 e1 00 00 00    	je     80103605 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103524:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103528:	74 15                	je     8010353f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010352a:	b8 70 00 00 00       	mov    $0x70,%eax
8010352f:	ba 22 00 00 00       	mov    $0x22,%edx
80103534:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103535:	ba 23 00 00 00       	mov    $0x23,%edx
8010353a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010353b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010353e:	ee                   	out    %al,(%dx)
  }
}
8010353f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103542:	5b                   	pop    %ebx
80103543:	5e                   	pop    %esi
80103544:	5f                   	pop    %edi
80103545:	5d                   	pop    %ebp
80103546:	c3                   	ret
80103547:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010354e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103550:	83 e9 03             	sub    $0x3,%ecx
80103553:	80 f9 01             	cmp    $0x1,%cl
80103556:	76 ba                	jbe    80103512 <mpinit+0x102>
80103558:	31 f6                	xor    %esi,%esi
8010355a:	eb a4                	jmp    80103500 <mpinit+0xf0>
8010355c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103560:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103564:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103567:	88 0d a0 27 18 80    	mov    %cl,0x801827a0
      continue;
8010356d:	eb 91                	jmp    80103500 <mpinit+0xf0>
8010356f:	90                   	nop
      if(ncpu < NCPU) {
80103570:	8b 0d a4 27 18 80    	mov    0x801827a4,%ecx
80103576:	83 f9 07             	cmp    $0x7,%ecx
80103579:	7f 19                	jg     80103594 <mpinit+0x184>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010357b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103581:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103585:	83 c1 01             	add    $0x1,%ecx
80103588:	89 0d a4 27 18 80    	mov    %ecx,0x801827a4
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010358e:	88 9f c0 27 18 80    	mov    %bl,-0x7fe7d840(%edi)
      p += sizeof(struct mpproc);
80103594:	83 c0 14             	add    $0x14,%eax
      continue;
80103597:	e9 64 ff ff ff       	jmp    80103500 <mpinit+0xf0>
8010359c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801035a0:	83 ec 0c             	sub    $0xc,%esp
801035a3:	68 c2 7b 10 80       	push   $0x80107bc2
801035a8:	e8 d3 cd ff ff       	call   80100380 <panic>
801035ad:	8d 76 00             	lea    0x0(%esi),%esi
{
801035b0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801035b5:	eb 13                	jmp    801035ca <mpinit+0x1ba>
801035b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035be:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801035c0:	89 f3                	mov    %esi,%ebx
801035c2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801035c8:	74 d6                	je     801035a0 <mpinit+0x190>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801035ca:	83 ec 04             	sub    $0x4,%esp
801035cd:	8d 73 10             	lea    0x10(%ebx),%esi
801035d0:	6a 04                	push   $0x4
801035d2:	68 b8 7b 10 80       	push   $0x80107bb8
801035d7:	53                   	push   %ebx
801035d8:	e8 03 13 00 00       	call   801048e0 <memcmp>
801035dd:	83 c4 10             	add    $0x10,%esp
801035e0:	85 c0                	test   %eax,%eax
801035e2:	75 dc                	jne    801035c0 <mpinit+0x1b0>
801035e4:	89 da                	mov    %ebx,%edx
801035e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035ed:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801035f0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801035f3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801035f6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801035f8:	39 f2                	cmp    %esi,%edx
801035fa:	75 f4                	jne    801035f0 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801035fc:	84 c0                	test   %al,%al
801035fe:	75 c0                	jne    801035c0 <mpinit+0x1b0>
80103600:	e9 5b fe ff ff       	jmp    80103460 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103605:	83 ec 0c             	sub    $0xc,%esp
80103608:	68 dc 7b 10 80       	push   $0x80107bdc
8010360d:	e8 6e cd ff ff       	call   80100380 <panic>
80103612:	66 90                	xchg   %ax,%ax
80103614:	66 90                	xchg   %ax,%ax
80103616:	66 90                	xchg   %ax,%ax
80103618:	66 90                	xchg   %ax,%ax
8010361a:	66 90                	xchg   %ax,%ax
8010361c:	66 90                	xchg   %ax,%ax
8010361e:	66 90                	xchg   %ax,%ax

80103620 <picinit>:
80103620:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103625:	ba 21 00 00 00       	mov    $0x21,%edx
8010362a:	ee                   	out    %al,(%dx)
8010362b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103630:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103631:	c3                   	ret
80103632:	66 90                	xchg   %ax,%ax
80103634:	66 90                	xchg   %ax,%ax
80103636:	66 90                	xchg   %ax,%ax
80103638:	66 90                	xchg   %ax,%ax
8010363a:	66 90                	xchg   %ax,%ax
8010363c:	66 90                	xchg   %ax,%ax
8010363e:	66 90                	xchg   %ax,%ax

80103640 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	57                   	push   %edi
80103644:	56                   	push   %esi
80103645:	53                   	push   %ebx
80103646:	83 ec 0c             	sub    $0xc,%esp
80103649:	8b 75 08             	mov    0x8(%ebp),%esi
8010364c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010364f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103655:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010365b:	e8 20 d8 ff ff       	call   80100e80 <filealloc>
80103660:	89 06                	mov    %eax,(%esi)
80103662:	85 c0                	test   %eax,%eax
80103664:	0f 84 a5 00 00 00    	je     8010370f <pipealloc+0xcf>
8010366a:	e8 11 d8 ff ff       	call   80100e80 <filealloc>
8010366f:	89 07                	mov    %eax,(%edi)
80103671:	85 c0                	test   %eax,%eax
80103673:	0f 84 84 00 00 00    	je     801036fd <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103679:	e8 d2 f0 ff ff       	call   80102750 <kalloc>
8010367e:	89 c3                	mov    %eax,%ebx
80103680:	85 c0                	test   %eax,%eax
80103682:	0f 84 a0 00 00 00    	je     80103728 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80103688:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010368f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103692:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103695:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010369c:	00 00 00 
  p->nwrite = 0;
8010369f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801036a6:	00 00 00 
  p->nread = 0;
801036a9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801036b0:	00 00 00 
  initlock(&p->lock, "pipe");
801036b3:	68 fb 7b 10 80       	push   $0x80107bfb
801036b8:	50                   	push   %eax
801036b9:	e8 32 0f 00 00       	call   801045f0 <initlock>
  (*f0)->type = FD_PIPE;
801036be:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801036c0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801036c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801036c9:	8b 06                	mov    (%esi),%eax
801036cb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801036cf:	8b 06                	mov    (%esi),%eax
801036d1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801036d5:	8b 06                	mov    (%esi),%eax
801036d7:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801036da:	8b 07                	mov    (%edi),%eax
801036dc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801036e2:	8b 07                	mov    (%edi),%eax
801036e4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801036e8:	8b 07                	mov    (%edi),%eax
801036ea:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801036ee:	8b 07                	mov    (%edi),%eax
801036f0:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
801036f3:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801036f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036f8:	5b                   	pop    %ebx
801036f9:	5e                   	pop    %esi
801036fa:	5f                   	pop    %edi
801036fb:	5d                   	pop    %ebp
801036fc:	c3                   	ret
  if(*f0)
801036fd:	8b 06                	mov    (%esi),%eax
801036ff:	85 c0                	test   %eax,%eax
80103701:	74 1e                	je     80103721 <pipealloc+0xe1>
    fileclose(*f0);
80103703:	83 ec 0c             	sub    $0xc,%esp
80103706:	50                   	push   %eax
80103707:	e8 34 d8 ff ff       	call   80100f40 <fileclose>
8010370c:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010370f:	8b 07                	mov    (%edi),%eax
80103711:	85 c0                	test   %eax,%eax
80103713:	74 0c                	je     80103721 <pipealloc+0xe1>
    fileclose(*f1);
80103715:	83 ec 0c             	sub    $0xc,%esp
80103718:	50                   	push   %eax
80103719:	e8 22 d8 ff ff       	call   80100f40 <fileclose>
8010371e:	83 c4 10             	add    $0x10,%esp
  return -1;
80103721:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103726:	eb cd                	jmp    801036f5 <pipealloc+0xb5>
  if(*f0)
80103728:	8b 06                	mov    (%esi),%eax
8010372a:	85 c0                	test   %eax,%eax
8010372c:	75 d5                	jne    80103703 <pipealloc+0xc3>
8010372e:	eb df                	jmp    8010370f <pipealloc+0xcf>

80103730 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103730:	55                   	push   %ebp
80103731:	89 e5                	mov    %esp,%ebp
80103733:	56                   	push   %esi
80103734:	53                   	push   %ebx
80103735:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103738:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010373b:	83 ec 0c             	sub    $0xc,%esp
8010373e:	53                   	push   %ebx
8010373f:	e8 cc 0f 00 00       	call   80104710 <acquire>
  if(writable){
80103744:	83 c4 10             	add    $0x10,%esp
80103747:	85 f6                	test   %esi,%esi
80103749:	74 65                	je     801037b0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010374b:	83 ec 0c             	sub    $0xc,%esp
8010374e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103754:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010375b:	00 00 00 
    wakeup(&p->nread);
8010375e:	50                   	push   %eax
8010375f:	e8 dc 0b 00 00       	call   80104340 <wakeup>
80103764:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103767:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010376d:	85 d2                	test   %edx,%edx
8010376f:	75 0a                	jne    8010377b <pipeclose+0x4b>
80103771:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103777:	85 c0                	test   %eax,%eax
80103779:	74 15                	je     80103790 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010377b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010377e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103781:	5b                   	pop    %ebx
80103782:	5e                   	pop    %esi
80103783:	5d                   	pop    %ebp
    release(&p->lock);
80103784:	e9 c7 10 00 00       	jmp    80104850 <release>
80103789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103790:	83 ec 0c             	sub    $0xc,%esp
80103793:	53                   	push   %ebx
80103794:	e8 b7 10 00 00       	call   80104850 <release>
    kfree((char*)p);
80103799:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010379c:	83 c4 10             	add    $0x10,%esp
}
8010379f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037a2:	5b                   	pop    %ebx
801037a3:	5e                   	pop    %esi
801037a4:	5d                   	pop    %ebp
    kfree((char*)p);
801037a5:	e9 96 ed ff ff       	jmp    80102540 <kfree>
801037aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801037b0:	83 ec 0c             	sub    $0xc,%esp
801037b3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801037b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801037c0:	00 00 00 
    wakeup(&p->nwrite);
801037c3:	50                   	push   %eax
801037c4:	e8 77 0b 00 00       	call   80104340 <wakeup>
801037c9:	83 c4 10             	add    $0x10,%esp
801037cc:	eb 99                	jmp    80103767 <pipeclose+0x37>
801037ce:	66 90                	xchg   %ax,%ax

801037d0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	57                   	push   %edi
801037d4:	56                   	push   %esi
801037d5:	53                   	push   %ebx
801037d6:	83 ec 28             	sub    $0x28,%esp
801037d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801037dc:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
801037df:	53                   	push   %ebx
801037e0:	e8 2b 0f 00 00       	call   80104710 <acquire>
  for(i = 0; i < n; i++){
801037e5:	83 c4 10             	add    $0x10,%esp
801037e8:	85 ff                	test   %edi,%edi
801037ea:	0f 8e ce 00 00 00    	jle    801038be <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037f0:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801037f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801037f9:	89 7d 10             	mov    %edi,0x10(%ebp)
801037fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801037ff:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80103802:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103805:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010380b:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103811:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103817:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
8010381d:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80103820:	0f 85 b6 00 00 00    	jne    801038dc <pipewrite+0x10c>
80103826:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103829:	eb 3b                	jmp    80103866 <pipewrite+0x96>
8010382b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010382f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103830:	e8 5b 03 00 00       	call   80103b90 <myproc>
80103835:	8b 48 24             	mov    0x24(%eax),%ecx
80103838:	85 c9                	test   %ecx,%ecx
8010383a:	75 34                	jne    80103870 <pipewrite+0xa0>
      wakeup(&p->nread);
8010383c:	83 ec 0c             	sub    $0xc,%esp
8010383f:	56                   	push   %esi
80103840:	e8 fb 0a 00 00       	call   80104340 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103845:	58                   	pop    %eax
80103846:	5a                   	pop    %edx
80103847:	53                   	push   %ebx
80103848:	57                   	push   %edi
80103849:	e8 32 0a 00 00       	call   80104280 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010384e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103854:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010385a:	83 c4 10             	add    $0x10,%esp
8010385d:	05 00 02 00 00       	add    $0x200,%eax
80103862:	39 c2                	cmp    %eax,%edx
80103864:	75 2a                	jne    80103890 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103866:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010386c:	85 c0                	test   %eax,%eax
8010386e:	75 c0                	jne    80103830 <pipewrite+0x60>
        release(&p->lock);
80103870:	83 ec 0c             	sub    $0xc,%esp
80103873:	53                   	push   %ebx
80103874:	e8 d7 0f 00 00       	call   80104850 <release>
        return -1;
80103879:	83 c4 10             	add    $0x10,%esp
8010387c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103881:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103884:	5b                   	pop    %ebx
80103885:	5e                   	pop    %esi
80103886:	5f                   	pop    %edi
80103887:	5d                   	pop    %ebp
80103888:	c3                   	ret
80103889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103890:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103893:	8d 42 01             	lea    0x1(%edx),%eax
80103896:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
8010389c:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010389f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801038a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801038a8:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
801038ac:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801038b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801038b3:	39 c1                	cmp    %eax,%ecx
801038b5:	0f 85 50 ff ff ff    	jne    8010380b <pipewrite+0x3b>
801038bb:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801038be:	83 ec 0c             	sub    $0xc,%esp
801038c1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801038c7:	50                   	push   %eax
801038c8:	e8 73 0a 00 00       	call   80104340 <wakeup>
  release(&p->lock);
801038cd:	89 1c 24             	mov    %ebx,(%esp)
801038d0:	e8 7b 0f 00 00       	call   80104850 <release>
  return n;
801038d5:	83 c4 10             	add    $0x10,%esp
801038d8:	89 f8                	mov    %edi,%eax
801038da:	eb a5                	jmp    80103881 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801038dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801038df:	eb b2                	jmp    80103893 <pipewrite+0xc3>
801038e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038ef:	90                   	nop

801038f0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	57                   	push   %edi
801038f4:	56                   	push   %esi
801038f5:	53                   	push   %ebx
801038f6:	83 ec 18             	sub    $0x18,%esp
801038f9:	8b 75 08             	mov    0x8(%ebp),%esi
801038fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801038ff:	56                   	push   %esi
80103900:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103906:	e8 05 0e 00 00       	call   80104710 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010390b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103911:	83 c4 10             	add    $0x10,%esp
80103914:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010391a:	74 2f                	je     8010394b <piperead+0x5b>
8010391c:	eb 37                	jmp    80103955 <piperead+0x65>
8010391e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103920:	e8 6b 02 00 00       	call   80103b90 <myproc>
80103925:	8b 48 24             	mov    0x24(%eax),%ecx
80103928:	85 c9                	test   %ecx,%ecx
8010392a:	0f 85 80 00 00 00    	jne    801039b0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103930:	83 ec 08             	sub    $0x8,%esp
80103933:	56                   	push   %esi
80103934:	53                   	push   %ebx
80103935:	e8 46 09 00 00       	call   80104280 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010393a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103940:	83 c4 10             	add    $0x10,%esp
80103943:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103949:	75 0a                	jne    80103955 <piperead+0x65>
8010394b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103951:	85 c0                	test   %eax,%eax
80103953:	75 cb                	jne    80103920 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103955:	8b 55 10             	mov    0x10(%ebp),%edx
80103958:	31 db                	xor    %ebx,%ebx
8010395a:	85 d2                	test   %edx,%edx
8010395c:	7f 20                	jg     8010397e <piperead+0x8e>
8010395e:	eb 2c                	jmp    8010398c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103960:	8d 48 01             	lea    0x1(%eax),%ecx
80103963:	25 ff 01 00 00       	and    $0x1ff,%eax
80103968:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010396e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103973:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103976:	83 c3 01             	add    $0x1,%ebx
80103979:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010397c:	74 0e                	je     8010398c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010397e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103984:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010398a:	75 d4                	jne    80103960 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010398c:	83 ec 0c             	sub    $0xc,%esp
8010398f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103995:	50                   	push   %eax
80103996:	e8 a5 09 00 00       	call   80104340 <wakeup>
  release(&p->lock);
8010399b:	89 34 24             	mov    %esi,(%esp)
8010399e:	e8 ad 0e 00 00       	call   80104850 <release>
  return i;
801039a3:	83 c4 10             	add    $0x10,%esp
}
801039a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039a9:	89 d8                	mov    %ebx,%eax
801039ab:	5b                   	pop    %ebx
801039ac:	5e                   	pop    %esi
801039ad:	5f                   	pop    %edi
801039ae:	5d                   	pop    %ebp
801039af:	c3                   	ret
      release(&p->lock);
801039b0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801039b3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801039b8:	56                   	push   %esi
801039b9:	e8 92 0e 00 00       	call   80104850 <release>
      return -1;
801039be:	83 c4 10             	add    $0x10,%esp
}
801039c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039c4:	89 d8                	mov    %ebx,%eax
801039c6:	5b                   	pop    %ebx
801039c7:	5e                   	pop    %esi
801039c8:	5f                   	pop    %edi
801039c9:	5d                   	pop    %ebp
801039ca:	c3                   	ret
801039cb:	66 90                	xchg   %ax,%ax
801039cd:	66 90                	xchg   %ax,%ax
801039cf:	90                   	nop

801039d0 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void) {
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	53                   	push   %ebx
    struct proc* p;
    char* sp;

    acquire(&ptable.lock);

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039d4:	bb 74 2d 18 80       	mov    $0x80182d74,%ebx
allocproc(void) {
801039d9:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);
801039dc:	68 40 2d 18 80       	push   $0x80182d40
801039e1:	e8 2a 0d 00 00       	call   80104710 <acquire>
801039e6:	83 c4 10             	add    $0x10,%esp
801039e9:	eb 10                	jmp    801039fb <allocproc+0x2b>
801039eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039ef:	90                   	nop
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039f0:	83 c3 7c             	add    $0x7c,%ebx
801039f3:	81 fb 74 4c 18 80    	cmp    $0x80184c74,%ebx
801039f9:	74 75                	je     80103a70 <allocproc+0xa0>
        if (p->state == UNUSED)
801039fb:	8b 43 0c             	mov    0xc(%ebx),%eax
801039fe:	85 c0                	test   %eax,%eax
80103a00:	75 ee                	jne    801039f0 <allocproc+0x20>
    release(&ptable.lock);
    return 0;

    found:
    p->state = EMBRYO;
    p->pid = nextpid++;
80103a02:	a1 04 b0 10 80       	mov    0x8010b004,%eax

    release(&ptable.lock);
80103a07:	83 ec 0c             	sub    $0xc,%esp
    p->state = EMBRYO;
80103a0a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
    p->pid = nextpid++;
80103a11:	8d 50 01             	lea    0x1(%eax),%edx
80103a14:	89 43 10             	mov    %eax,0x10(%ebx)
80103a17:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
    release(&ptable.lock);
80103a1d:	68 40 2d 18 80       	push   $0x80182d40
80103a22:	e8 29 0e 00 00       	call   80104850 <release>

    // Allocate kernel stack.
    if ((p->kstack = kalloc()) == 0) {
80103a27:	e8 24 ed ff ff       	call   80102750 <kalloc>
80103a2c:	83 c4 10             	add    $0x10,%esp
80103a2f:	89 43 08             	mov    %eax,0x8(%ebx)
80103a32:	85 c0                	test   %eax,%eax
80103a34:	74 53                	je     80103a89 <allocproc+0xb9>
        return 0;
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
80103a36:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    sp -= 4;
    *(uint*) sp = (uint) trapret;

    sp -= sizeof *p->context;
    p->context = (struct context*) sp;
    memset(p->context, 0, sizeof *p->context);
80103a3c:	83 ec 04             	sub    $0x4,%esp
    sp -= sizeof *p->context;
80103a3f:	05 9c 0f 00 00       	add    $0xf9c,%eax
    sp -= sizeof *p->tf;
80103a44:	89 53 18             	mov    %edx,0x18(%ebx)
    *(uint*) sp = (uint) trapret;
80103a47:	c7 40 14 ce 5a 10 80 	movl   $0x80105ace,0x14(%eax)
    p->context = (struct context*) sp;
80103a4e:	89 43 1c             	mov    %eax,0x1c(%ebx)
    memset(p->context, 0, sizeof *p->context);
80103a51:	6a 14                	push   $0x14
80103a53:	6a 00                	push   $0x0
80103a55:	50                   	push   %eax
80103a56:	e8 45 0e 00 00       	call   801048a0 <memset>
    p->context->eip = (uint) forkret;
80103a5b:	8b 43 1c             	mov    0x1c(%ebx),%eax

    return p;
80103a5e:	83 c4 10             	add    $0x10,%esp
    p->context->eip = (uint) forkret;
80103a61:	c7 40 10 a0 3a 10 80 	movl   $0x80103aa0,0x10(%eax)
}
80103a68:	89 d8                	mov    %ebx,%eax
80103a6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a6d:	c9                   	leave
80103a6e:	c3                   	ret
80103a6f:	90                   	nop
    release(&ptable.lock);
80103a70:	83 ec 0c             	sub    $0xc,%esp
    return 0;
80103a73:	31 db                	xor    %ebx,%ebx
    release(&ptable.lock);
80103a75:	68 40 2d 18 80       	push   $0x80182d40
80103a7a:	e8 d1 0d 00 00       	call   80104850 <release>
    return 0;
80103a7f:	83 c4 10             	add    $0x10,%esp
}
80103a82:	89 d8                	mov    %ebx,%eax
80103a84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a87:	c9                   	leave
80103a88:	c3                   	ret
        p->state = UNUSED;
80103a89:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103a90:	31 db                	xor    %ebx,%ebx
80103a92:	eb ee                	jmp    80103a82 <allocproc+0xb2>
80103a94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a9f:	90                   	nop

80103aa0 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void) {
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	83 ec 14             	sub    $0x14,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
80103aa6:	68 40 2d 18 80       	push   $0x80182d40
80103aab:	e8 a0 0d 00 00       	call   80104850 <release>

    if (first) {
80103ab0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103ab5:	83 c4 10             	add    $0x10,%esp
80103ab8:	85 c0                	test   %eax,%eax
80103aba:	75 04                	jne    80103ac0 <forkret+0x20>
        iinit(ROOTDEV);
        initlog(ROOTDEV);
    }

    // Return to "caller", actually trapret (see allocproc).
}
80103abc:	c9                   	leave
80103abd:	c3                   	ret
80103abe:	66 90                	xchg   %ax,%ax
        first = 0;
80103ac0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103ac7:	00 00 00 
        iinit(ROOTDEV);
80103aca:	83 ec 0c             	sub    $0xc,%esp
80103acd:	6a 01                	push   $0x1
80103acf:	e8 fc da ff ff       	call   801015d0 <iinit>
        initlog(ROOTDEV);
80103ad4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103adb:	e8 f0 f3 ff ff       	call   80102ed0 <initlog>
}
80103ae0:	83 c4 10             	add    $0x10,%esp
80103ae3:	c9                   	leave
80103ae4:	c3                   	ret
80103ae5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103af0 <pinit>:
pinit(void) {
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	83 ec 10             	sub    $0x10,%esp
    initlock(&ptable.lock, "ptable");
80103af6:	68 00 7c 10 80       	push   $0x80107c00
80103afb:	68 40 2d 18 80       	push   $0x80182d40
80103b00:	e8 eb 0a 00 00       	call   801045f0 <initlock>
}
80103b05:	83 c4 10             	add    $0x10,%esp
80103b08:	c9                   	leave
80103b09:	c3                   	ret
80103b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b10 <mycpu>:
mycpu(void) {
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	56                   	push   %esi
80103b14:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b15:	9c                   	pushf
80103b16:	58                   	pop    %eax
    if (readeflags() & FL_IF)
80103b17:	f6 c4 02             	test   $0x2,%ah
80103b1a:	75 46                	jne    80103b62 <mycpu+0x52>
    apicid = lapicid();
80103b1c:	e8 df ef ff ff       	call   80102b00 <lapicid>
    for (i = 0; i < ncpu; ++i) {
80103b21:	8b 35 a4 27 18 80    	mov    0x801827a4,%esi
80103b27:	85 f6                	test   %esi,%esi
80103b29:	7e 2a                	jle    80103b55 <mycpu+0x45>
80103b2b:	31 d2                	xor    %edx,%edx
80103b2d:	eb 08                	jmp    80103b37 <mycpu+0x27>
80103b2f:	90                   	nop
80103b30:	83 c2 01             	add    $0x1,%edx
80103b33:	39 f2                	cmp    %esi,%edx
80103b35:	74 1e                	je     80103b55 <mycpu+0x45>
        if (cpus[i].apicid == apicid)
80103b37:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103b3d:	0f b6 99 c0 27 18 80 	movzbl -0x7fe7d840(%ecx),%ebx
80103b44:	39 c3                	cmp    %eax,%ebx
80103b46:	75 e8                	jne    80103b30 <mycpu+0x20>
}
80103b48:	8d 65 f8             	lea    -0x8(%ebp),%esp
            return &cpus[i];
80103b4b:	8d 81 c0 27 18 80    	lea    -0x7fe7d840(%ecx),%eax
}
80103b51:	5b                   	pop    %ebx
80103b52:	5e                   	pop    %esi
80103b53:	5d                   	pop    %ebp
80103b54:	c3                   	ret
    panic("unknown apicid\n");
80103b55:	83 ec 0c             	sub    $0xc,%esp
80103b58:	68 07 7c 10 80       	push   $0x80107c07
80103b5d:	e8 1e c8 ff ff       	call   80100380 <panic>
        panic("mycpu called with interrupts enabled\n");
80103b62:	83 ec 0c             	sub    $0xc,%esp
80103b65:	68 18 7d 10 80       	push   $0x80107d18
80103b6a:	e8 11 c8 ff ff       	call   80100380 <panic>
80103b6f:	90                   	nop

80103b70 <cpuid>:
cpuid() {
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	83 ec 08             	sub    $0x8,%esp
    return mycpu() - cpus;
80103b76:	e8 95 ff ff ff       	call   80103b10 <mycpu>
}
80103b7b:	c9                   	leave
    return mycpu() - cpus;
80103b7c:	2d c0 27 18 80       	sub    $0x801827c0,%eax
80103b81:	c1 f8 04             	sar    $0x4,%eax
80103b84:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b8a:	c3                   	ret
80103b8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b8f:	90                   	nop

80103b90 <myproc>:
myproc(void) {
80103b90:	55                   	push   %ebp
80103b91:	89 e5                	mov    %esp,%ebp
80103b93:	53                   	push   %ebx
80103b94:	83 ec 04             	sub    $0x4,%esp
    pushcli();
80103b97:	e8 24 0b 00 00       	call   801046c0 <pushcli>
    c = mycpu();
80103b9c:	e8 6f ff ff ff       	call   80103b10 <mycpu>
    p = c->proc;
80103ba1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103ba7:	e8 44 0c 00 00       	call   801047f0 <popcli>
}
80103bac:	89 d8                	mov    %ebx,%eax
80103bae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bb1:	c9                   	leave
80103bb2:	c3                   	ret
80103bb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103bc0 <userinit>:
userinit(void) {
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	53                   	push   %ebx
80103bc4:	83 ec 04             	sub    $0x4,%esp
    p = allocproc();
80103bc7:	e8 04 fe ff ff       	call   801039d0 <allocproc>
80103bcc:	89 c3                	mov    %eax,%ebx
    initproc = p;
80103bce:	a3 74 4c 18 80       	mov    %eax,0x80184c74
    if ((p->pgdir = setupkvm()) == 0)
80103bd3:	e8 e8 34 00 00       	call   801070c0 <setupkvm>
80103bd8:	89 43 04             	mov    %eax,0x4(%ebx)
80103bdb:	85 c0                	test   %eax,%eax
80103bdd:	0f 84 bd 00 00 00    	je     80103ca0 <userinit+0xe0>
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
80103be3:	83 ec 04             	sub    $0x4,%esp
80103be6:	68 2c 00 00 00       	push   $0x2c
80103beb:	68 60 b4 10 80       	push   $0x8010b460
80103bf0:	50                   	push   %eax
80103bf1:	e8 aa 31 00 00       	call   80106da0 <inituvm>
    memset(p->tf, 0, sizeof(*p->tf));
80103bf6:	83 c4 0c             	add    $0xc,%esp
    p->sz = PGSIZE;
80103bf9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->tf, 0, sizeof(*p->tf));
80103bff:	6a 4c                	push   $0x4c
80103c01:	6a 00                	push   $0x0
80103c03:	ff 73 18             	push   0x18(%ebx)
80103c06:	e8 95 0c 00 00       	call   801048a0 <memset>
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c0b:	8b 43 18             	mov    0x18(%ebx),%eax
80103c0e:	ba 1b 00 00 00       	mov    $0x1b,%edx
    safestrcpy(p->name, "initcode", sizeof(p->name));
80103c13:	83 c4 0c             	add    $0xc,%esp
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c16:	b9 23 00 00 00       	mov    $0x23,%ecx
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c1b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c1f:	8b 43 18             	mov    0x18(%ebx),%eax
80103c22:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    p->tf->es = p->tf->ds;
80103c26:	8b 43 18             	mov    0x18(%ebx),%eax
80103c29:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c2d:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
80103c31:	8b 43 18             	mov    0x18(%ebx),%eax
80103c34:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c38:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
80103c3c:	8b 43 18             	mov    0x18(%ebx),%eax
80103c3f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
80103c46:	8b 43 18             	mov    0x18(%ebx),%eax
80103c49:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0;  // beginning of initcode.S
80103c50:	8b 43 18             	mov    0x18(%ebx),%eax
80103c53:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
    safestrcpy(p->name, "initcode", sizeof(p->name));
80103c5a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c5d:	6a 10                	push   $0x10
80103c5f:	68 30 7c 10 80       	push   $0x80107c30
80103c64:	50                   	push   %eax
80103c65:	e8 e6 0d 00 00       	call   80104a50 <safestrcpy>
    p->cwd = namei("/");
80103c6a:	c7 04 24 39 7c 10 80 	movl   $0x80107c39,(%esp)
80103c71:	e8 aa e4 ff ff       	call   80102120 <namei>
80103c76:	89 43 68             	mov    %eax,0x68(%ebx)
    acquire(&ptable.lock);
80103c79:	c7 04 24 40 2d 18 80 	movl   $0x80182d40,(%esp)
80103c80:	e8 8b 0a 00 00       	call   80104710 <acquire>
    p->state = RUNNABLE;
80103c85:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    release(&ptable.lock);
80103c8c:	c7 04 24 40 2d 18 80 	movl   $0x80182d40,(%esp)
80103c93:	e8 b8 0b 00 00       	call   80104850 <release>
}
80103c98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c9b:	83 c4 10             	add    $0x10,%esp
80103c9e:	c9                   	leave
80103c9f:	c3                   	ret
        panic("userinit: out of memory?");
80103ca0:	83 ec 0c             	sub    $0xc,%esp
80103ca3:	68 17 7c 10 80       	push   $0x80107c17
80103ca8:	e8 d3 c6 ff ff       	call   80100380 <panic>
80103cad:	8d 76 00             	lea    0x0(%esi),%esi

80103cb0 <growproc>:
growproc(int n) {
80103cb0:	55                   	push   %ebp
80103cb1:	89 e5                	mov    %esp,%ebp
80103cb3:	56                   	push   %esi
80103cb4:	53                   	push   %ebx
80103cb5:	8b 75 08             	mov    0x8(%ebp),%esi
    pushcli();
80103cb8:	e8 03 0a 00 00       	call   801046c0 <pushcli>
    c = mycpu();
80103cbd:	e8 4e fe ff ff       	call   80103b10 <mycpu>
    p = c->proc;
80103cc2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103cc8:	e8 23 0b 00 00       	call   801047f0 <popcli>
    sz = curproc->sz;
80103ccd:	8b 03                	mov    (%ebx),%eax
    if (n > 0) {
80103ccf:	85 f6                	test   %esi,%esi
80103cd1:	7f 1d                	jg     80103cf0 <growproc+0x40>
    } else if (n < 0) {
80103cd3:	75 4b                	jne    80103d20 <growproc+0x70>
    switchuvm(curproc);
80103cd5:	83 ec 0c             	sub    $0xc,%esp
    curproc->sz = sz;
80103cd8:	89 03                	mov    %eax,(%ebx)
    switchuvm(curproc);
80103cda:	53                   	push   %ebx
80103cdb:	e8 b0 2f 00 00       	call   80106c90 <switchuvm>
    return 0;
80103ce0:	83 c4 10             	add    $0x10,%esp
80103ce3:	31 c0                	xor    %eax,%eax
}
80103ce5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ce8:	5b                   	pop    %ebx
80103ce9:	5e                   	pop    %esi
80103cea:	5d                   	pop    %ebp
80103ceb:	c3                   	ret
80103cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0) {
80103cf0:	83 ec 04             	sub    $0x4,%esp
80103cf3:	01 c6                	add    %eax,%esi
80103cf5:	56                   	push   %esi
80103cf6:	50                   	push   %eax
80103cf7:	ff 73 04             	push   0x4(%ebx)
80103cfa:	e8 f1 31 00 00       	call   80106ef0 <allocuvm>
80103cff:	83 c4 10             	add    $0x10,%esp
80103d02:	85 c0                	test   %eax,%eax
80103d04:	75 cf                	jne    80103cd5 <growproc+0x25>
            cprintf("Allocating pages failed!\n"); // xv6 proj - cow
80103d06:	83 ec 0c             	sub    $0xc,%esp
80103d09:	68 3b 7c 10 80       	push   $0x80107c3b
80103d0e:	e8 9d c9 ff ff       	call   801006b0 <cprintf>
            return -1;
80103d13:	83 c4 10             	add    $0x10,%esp
80103d16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d1b:	eb c8                	jmp    80103ce5 <growproc+0x35>
80103d1d:	8d 76 00             	lea    0x0(%esi),%esi
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0) {
80103d20:	83 ec 04             	sub    $0x4,%esp
80103d23:	01 c6                	add    %eax,%esi
80103d25:	56                   	push   %esi
80103d26:	50                   	push   %eax
80103d27:	ff 73 04             	push   0x4(%ebx)
80103d2a:	e8 e1 32 00 00       	call   80107010 <deallocuvm>
80103d2f:	83 c4 10             	add    $0x10,%esp
80103d32:	85 c0                	test   %eax,%eax
80103d34:	75 9f                	jne    80103cd5 <growproc+0x25>
            cprintf("Deallocating pages failed!\n"); // xv6 proj - cow
80103d36:	83 ec 0c             	sub    $0xc,%esp
80103d39:	68 55 7c 10 80       	push   $0x80107c55
80103d3e:	e8 6d c9 ff ff       	call   801006b0 <cprintf>
            return -1;
80103d43:	83 c4 10             	add    $0x10,%esp
80103d46:	eb ce                	jmp    80103d16 <growproc+0x66>
80103d48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d4f:	90                   	nop

80103d50 <fork>:
fork(void) {
80103d50:	55                   	push   %ebp
80103d51:	89 e5                	mov    %esp,%ebp
80103d53:	57                   	push   %edi
80103d54:	56                   	push   %esi
80103d55:	53                   	push   %ebx
80103d56:	83 ec 1c             	sub    $0x1c,%esp
    pushcli();
80103d59:	e8 62 09 00 00       	call   801046c0 <pushcli>
    c = mycpu();
80103d5e:	e8 ad fd ff ff       	call   80103b10 <mycpu>
    p = c->proc;
80103d63:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103d69:	e8 82 0a 00 00       	call   801047f0 <popcli>
    if ((np = allocproc()) == 0) {
80103d6e:	e8 5d fc ff ff       	call   801039d0 <allocproc>
80103d73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d76:	85 c0                	test   %eax,%eax
80103d78:	0f 84 d6 00 00 00    	je     80103e54 <fork+0x104>
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
80103d7e:	83 ec 08             	sub    $0x8,%esp
80103d81:	ff 33                	push   (%ebx)
80103d83:	89 c7                	mov    %eax,%edi
80103d85:	ff 73 04             	push   0x4(%ebx)
80103d88:	e8 23 34 00 00       	call   801071b0 <copyuvm>
80103d8d:	83 c4 10             	add    $0x10,%esp
80103d90:	89 47 04             	mov    %eax,0x4(%edi)
80103d93:	85 c0                	test   %eax,%eax
80103d95:	0f 84 9a 00 00 00    	je     80103e35 <fork+0xe5>
    np->sz = curproc->sz;
80103d9b:	8b 03                	mov    (%ebx),%eax
80103d9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103da0:	89 01                	mov    %eax,(%ecx)
    *np->tf = *curproc->tf;
80103da2:	8b 79 18             	mov    0x18(%ecx),%edi
    np->parent = curproc;
80103da5:	89 c8                	mov    %ecx,%eax
80103da7:	89 59 14             	mov    %ebx,0x14(%ecx)
    *np->tf = *curproc->tf;
80103daa:	b9 13 00 00 00       	mov    $0x13,%ecx
80103daf:	8b 73 18             	mov    0x18(%ebx),%esi
80103db2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    for (i = 0; i < NOFILE; i++)
80103db4:	31 f6                	xor    %esi,%esi
    np->tf->eax = 0;
80103db6:	8b 40 18             	mov    0x18(%eax),%eax
80103db9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
        if (curproc->ofile[i])
80103dc0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103dc4:	85 c0                	test   %eax,%eax
80103dc6:	74 13                	je     80103ddb <fork+0x8b>
            np->ofile[i] = filedup(curproc->ofile[i]);
80103dc8:	83 ec 0c             	sub    $0xc,%esp
80103dcb:	50                   	push   %eax
80103dcc:	e8 1f d1 ff ff       	call   80100ef0 <filedup>
80103dd1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103dd4:	83 c4 10             	add    $0x10,%esp
80103dd7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
    for (i = 0; i < NOFILE; i++)
80103ddb:	83 c6 01             	add    $0x1,%esi
80103dde:	83 fe 10             	cmp    $0x10,%esi
80103de1:	75 dd                	jne    80103dc0 <fork+0x70>
    np->cwd = idup(curproc->cwd);
80103de3:	83 ec 0c             	sub    $0xc,%esp
80103de6:	ff 73 68             	push   0x68(%ebx)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103de9:	83 c3 6c             	add    $0x6c,%ebx
    np->cwd = idup(curproc->cwd);
80103dec:	e8 cf d9 ff ff       	call   801017c0 <idup>
80103df1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103df4:	83 c4 0c             	add    $0xc,%esp
    np->cwd = idup(curproc->cwd);
80103df7:	89 47 68             	mov    %eax,0x68(%edi)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103dfa:	8d 47 6c             	lea    0x6c(%edi),%eax
80103dfd:	6a 10                	push   $0x10
80103dff:	53                   	push   %ebx
80103e00:	50                   	push   %eax
80103e01:	e8 4a 0c 00 00       	call   80104a50 <safestrcpy>
    pid = np->pid;
80103e06:	8b 5f 10             	mov    0x10(%edi),%ebx
    acquire(&ptable.lock);
80103e09:	c7 04 24 40 2d 18 80 	movl   $0x80182d40,(%esp)
80103e10:	e8 fb 08 00 00       	call   80104710 <acquire>
    np->state = RUNNABLE;
80103e15:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
    release(&ptable.lock);
80103e1c:	c7 04 24 40 2d 18 80 	movl   $0x80182d40,(%esp)
80103e23:	e8 28 0a 00 00       	call   80104850 <release>
    return pid;
80103e28:	83 c4 10             	add    $0x10,%esp
}
80103e2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e2e:	89 d8                	mov    %ebx,%eax
80103e30:	5b                   	pop    %ebx
80103e31:	5e                   	pop    %esi
80103e32:	5f                   	pop    %edi
80103e33:	5d                   	pop    %ebp
80103e34:	c3                   	ret
        kfree(np->kstack);
80103e35:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103e38:	83 ec 0c             	sub    $0xc,%esp
80103e3b:	ff 73 08             	push   0x8(%ebx)
80103e3e:	e8 fd e6 ff ff       	call   80102540 <kfree>
        np->kstack = 0;
80103e43:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        return -1;
80103e4a:	83 c4 10             	add    $0x10,%esp
        np->state = UNUSED;
80103e4d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return -1;
80103e54:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e59:	eb d0                	jmp    80103e2b <fork+0xdb>
80103e5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e5f:	90                   	nop

80103e60 <scheduler>:
scheduler(void) {
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	57                   	push   %edi
80103e64:	56                   	push   %esi
80103e65:	53                   	push   %ebx
80103e66:	83 ec 1c             	sub    $0x1c,%esp
    struct cpu* c = mycpu();
80103e69:	e8 a2 fc ff ff       	call   80103b10 <mycpu>
    c->proc = 0;
80103e6e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e75:	00 00 00 
    struct cpu* c = mycpu();
80103e78:	89 c6                	mov    %eax,%esi
    int ran = 0; // CS 350/550: to solve the 100%-CPU-utilization-when-idling problem
80103e7a:	8d 78 04             	lea    0x4(%eax),%edi
80103e7d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103e80:	fb                   	sti
        acquire(&ptable.lock);
80103e81:	83 ec 0c             	sub    $0xc,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103e84:	bb 74 2d 18 80       	mov    $0x80182d74,%ebx
        acquire(&ptable.lock);
80103e89:	68 40 2d 18 80       	push   $0x80182d40
80103e8e:	e8 7d 08 00 00       	call   80104710 <acquire>
80103e93:	83 c4 10             	add    $0x10,%esp
        ran = 0;
80103e96:	31 c0                	xor    %eax,%eax
80103e98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e9f:	90                   	nop
            if (p->state != RUNNABLE)
80103ea0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103ea4:	75 38                	jne    80103ede <scheduler+0x7e>
            switchuvm(p);
80103ea6:	83 ec 0c             	sub    $0xc,%esp
            c->proc = p;
80103ea9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
            switchuvm(p);
80103eaf:	53                   	push   %ebx
80103eb0:	e8 db 2d 00 00       	call   80106c90 <switchuvm>
            swtch(&(c->scheduler), p->context);
80103eb5:	58                   	pop    %eax
80103eb6:	5a                   	pop    %edx
80103eb7:	ff 73 1c             	push   0x1c(%ebx)
80103eba:	57                   	push   %edi
            p->state = RUNNING;
80103ebb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
            swtch(&(c->scheduler), p->context);
80103ec2:	e8 e4 0b 00 00       	call   80104aab <swtch>
            switchkvm();
80103ec7:	e8 b4 2d 00 00       	call   80106c80 <switchkvm>
            c->proc = 0;
80103ecc:	83 c4 10             	add    $0x10,%esp
            ran = 1;
80103ecf:	b8 01 00 00 00       	mov    $0x1,%eax
            c->proc = 0;
80103ed4:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103edb:	00 00 00 
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103ede:	83 c3 7c             	add    $0x7c,%ebx
80103ee1:	81 fb 74 4c 18 80    	cmp    $0x80184c74,%ebx
80103ee7:	75 b7                	jne    80103ea0 <scheduler+0x40>
        release(&ptable.lock);
80103ee9:	83 ec 0c             	sub    $0xc,%esp
80103eec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103eef:	68 40 2d 18 80       	push   $0x80182d40
80103ef4:	e8 57 09 00 00       	call   80104850 <release>
        if (ran == 0) {
80103ef9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103efc:	83 c4 10             	add    $0x10,%esp
80103eff:	85 c0                	test   %eax,%eax
80103f01:	0f 85 79 ff ff ff    	jne    80103e80 <scheduler+0x20>

// CS 350/550: to solve the 100%-CPU-utilization-when-idling problem - "hlt" instruction puts CPU to sleep
static inline void
halt()
{
    asm volatile("hlt" : : :"memory");
80103f07:	f4                   	hlt
}
80103f08:	e9 73 ff ff ff       	jmp    80103e80 <scheduler+0x20>
80103f0d:	8d 76 00             	lea    0x0(%esi),%esi

80103f10 <sched>:
sched(void) {
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	56                   	push   %esi
80103f14:	53                   	push   %ebx
    pushcli();
80103f15:	e8 a6 07 00 00       	call   801046c0 <pushcli>
    c = mycpu();
80103f1a:	e8 f1 fb ff ff       	call   80103b10 <mycpu>
    p = c->proc;
80103f1f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103f25:	e8 c6 08 00 00       	call   801047f0 <popcli>
    if (!holding(&ptable.lock))
80103f2a:	83 ec 0c             	sub    $0xc,%esp
80103f2d:	68 40 2d 18 80       	push   $0x80182d40
80103f32:	e8 49 07 00 00       	call   80104680 <holding>
80103f37:	83 c4 10             	add    $0x10,%esp
80103f3a:	85 c0                	test   %eax,%eax
80103f3c:	74 4f                	je     80103f8d <sched+0x7d>
    if (mycpu()->ncli != 1)
80103f3e:	e8 cd fb ff ff       	call   80103b10 <mycpu>
80103f43:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f4a:	75 68                	jne    80103fb4 <sched+0xa4>
    if (p->state == RUNNING)
80103f4c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103f50:	74 55                	je     80103fa7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f52:	9c                   	pushf
80103f53:	58                   	pop    %eax
    if (readeflags() & FL_IF)
80103f54:	f6 c4 02             	test   $0x2,%ah
80103f57:	75 41                	jne    80103f9a <sched+0x8a>
    intena = mycpu()->intena;
80103f59:	e8 b2 fb ff ff       	call   80103b10 <mycpu>
    swtch(&p->context, mycpu()->scheduler);
80103f5e:	83 c3 1c             	add    $0x1c,%ebx
    intena = mycpu()->intena;
80103f61:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
    swtch(&p->context, mycpu()->scheduler);
80103f67:	e8 a4 fb ff ff       	call   80103b10 <mycpu>
80103f6c:	83 ec 08             	sub    $0x8,%esp
80103f6f:	ff 70 04             	push   0x4(%eax)
80103f72:	53                   	push   %ebx
80103f73:	e8 33 0b 00 00       	call   80104aab <swtch>
    mycpu()->intena = intena;
80103f78:	e8 93 fb ff ff       	call   80103b10 <mycpu>
}
80103f7d:	83 c4 10             	add    $0x10,%esp
    mycpu()->intena = intena;
80103f80:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f86:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f89:	5b                   	pop    %ebx
80103f8a:	5e                   	pop    %esi
80103f8b:	5d                   	pop    %ebp
80103f8c:	c3                   	ret
        panic("sched ptable.lock");
80103f8d:	83 ec 0c             	sub    $0xc,%esp
80103f90:	68 71 7c 10 80       	push   $0x80107c71
80103f95:	e8 e6 c3 ff ff       	call   80100380 <panic>
        panic("sched interruptible");
80103f9a:	83 ec 0c             	sub    $0xc,%esp
80103f9d:	68 9d 7c 10 80       	push   $0x80107c9d
80103fa2:	e8 d9 c3 ff ff       	call   80100380 <panic>
        panic("sched running");
80103fa7:	83 ec 0c             	sub    $0xc,%esp
80103faa:	68 8f 7c 10 80       	push   $0x80107c8f
80103faf:	e8 cc c3 ff ff       	call   80100380 <panic>
        panic("sched locks");
80103fb4:	83 ec 0c             	sub    $0xc,%esp
80103fb7:	68 83 7c 10 80       	push   $0x80107c83
80103fbc:	e8 bf c3 ff ff       	call   80100380 <panic>
80103fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fcf:	90                   	nop

80103fd0 <exit>:
exit(void) {
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	57                   	push   %edi
80103fd4:	56                   	push   %esi
80103fd5:	53                   	push   %ebx
80103fd6:	83 ec 0c             	sub    $0xc,%esp
    struct proc* curproc = myproc();
80103fd9:	e8 b2 fb ff ff       	call   80103b90 <myproc>
    if (curproc == initproc)
80103fde:	39 05 74 4c 18 80    	cmp    %eax,0x80184c74
80103fe4:	0f 84 fd 00 00 00    	je     801040e7 <exit+0x117>
80103fea:	89 c3                	mov    %eax,%ebx
80103fec:	8d 70 28             	lea    0x28(%eax),%esi
80103fef:	8d 78 68             	lea    0x68(%eax),%edi
80103ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (curproc->ofile[fd]) {
80103ff8:	8b 06                	mov    (%esi),%eax
80103ffa:	85 c0                	test   %eax,%eax
80103ffc:	74 12                	je     80104010 <exit+0x40>
            fileclose(curproc->ofile[fd]);
80103ffe:	83 ec 0c             	sub    $0xc,%esp
80104001:	50                   	push   %eax
80104002:	e8 39 cf ff ff       	call   80100f40 <fileclose>
            curproc->ofile[fd] = 0;
80104007:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010400d:	83 c4 10             	add    $0x10,%esp
    for (fd = 0; fd < NOFILE; fd++) {
80104010:	83 c6 04             	add    $0x4,%esi
80104013:	39 f7                	cmp    %esi,%edi
80104015:	75 e1                	jne    80103ff8 <exit+0x28>
    begin_op();
80104017:	e8 54 ef ff ff       	call   80102f70 <begin_op>
    iput(curproc->cwd);
8010401c:	83 ec 0c             	sub    $0xc,%esp
8010401f:	ff 73 68             	push   0x68(%ebx)
80104022:	e8 f9 d8 ff ff       	call   80101920 <iput>
    end_op();
80104027:	e8 b4 ef ff ff       	call   80102fe0 <end_op>
    curproc->cwd = 0;
8010402c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
    acquire(&ptable.lock);
80104033:	c7 04 24 40 2d 18 80 	movl   $0x80182d40,(%esp)
8010403a:	e8 d1 06 00 00       	call   80104710 <acquire>
    wakeup1(curproc->parent);
8010403f:	8b 53 14             	mov    0x14(%ebx),%edx
80104042:	83 c4 10             	add    $0x10,%esp
// The ptable lock must be held.
static void
wakeup1(void* chan) {
    struct proc* p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104045:	b8 74 2d 18 80       	mov    $0x80182d74,%eax
8010404a:	eb 0e                	jmp    8010405a <exit+0x8a>
8010404c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104050:	83 c0 7c             	add    $0x7c,%eax
80104053:	3d 74 4c 18 80       	cmp    $0x80184c74,%eax
80104058:	74 1c                	je     80104076 <exit+0xa6>
        if (p->state == SLEEPING && p->chan == chan)
8010405a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010405e:	75 f0                	jne    80104050 <exit+0x80>
80104060:	3b 50 20             	cmp    0x20(%eax),%edx
80104063:	75 eb                	jne    80104050 <exit+0x80>
            p->state = RUNNABLE;
80104065:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010406c:	83 c0 7c             	add    $0x7c,%eax
8010406f:	3d 74 4c 18 80       	cmp    $0x80184c74,%eax
80104074:	75 e4                	jne    8010405a <exit+0x8a>
            p->parent = initproc;
80104076:	8b 0d 74 4c 18 80    	mov    0x80184c74,%ecx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010407c:	ba 74 2d 18 80       	mov    $0x80182d74,%edx
80104081:	eb 10                	jmp    80104093 <exit+0xc3>
80104083:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104087:	90                   	nop
80104088:	83 c2 7c             	add    $0x7c,%edx
8010408b:	81 fa 74 4c 18 80    	cmp    $0x80184c74,%edx
80104091:	74 3b                	je     801040ce <exit+0xfe>
        if (p->parent == curproc) {
80104093:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104096:	75 f0                	jne    80104088 <exit+0xb8>
            if (p->state == ZOMBIE)
80104098:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
            p->parent = initproc;
8010409c:	89 4a 14             	mov    %ecx,0x14(%edx)
            if (p->state == ZOMBIE)
8010409f:	75 e7                	jne    80104088 <exit+0xb8>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040a1:	b8 74 2d 18 80       	mov    $0x80182d74,%eax
801040a6:	eb 12                	jmp    801040ba <exit+0xea>
801040a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040af:	90                   	nop
801040b0:	83 c0 7c             	add    $0x7c,%eax
801040b3:	3d 74 4c 18 80       	cmp    $0x80184c74,%eax
801040b8:	74 ce                	je     80104088 <exit+0xb8>
        if (p->state == SLEEPING && p->chan == chan)
801040ba:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040be:	75 f0                	jne    801040b0 <exit+0xe0>
801040c0:	3b 48 20             	cmp    0x20(%eax),%ecx
801040c3:	75 eb                	jne    801040b0 <exit+0xe0>
            p->state = RUNNABLE;
801040c5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801040cc:	eb e2                	jmp    801040b0 <exit+0xe0>
    curproc->state = ZOMBIE;
801040ce:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
    sched();
801040d5:	e8 36 fe ff ff       	call   80103f10 <sched>
    panic("zombie exit");
801040da:	83 ec 0c             	sub    $0xc,%esp
801040dd:	68 be 7c 10 80       	push   $0x80107cbe
801040e2:	e8 99 c2 ff ff       	call   80100380 <panic>
        panic("init exiting");
801040e7:	83 ec 0c             	sub    $0xc,%esp
801040ea:	68 b1 7c 10 80       	push   $0x80107cb1
801040ef:	e8 8c c2 ff ff       	call   80100380 <panic>
801040f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040ff:	90                   	nop

80104100 <wait>:
wait(void) {
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	56                   	push   %esi
80104104:	53                   	push   %ebx
    pushcli();
80104105:	e8 b6 05 00 00       	call   801046c0 <pushcli>
    c = mycpu();
8010410a:	e8 01 fa ff ff       	call   80103b10 <mycpu>
    p = c->proc;
8010410f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104115:	e8 d6 06 00 00       	call   801047f0 <popcli>
    acquire(&ptable.lock);
8010411a:	83 ec 0c             	sub    $0xc,%esp
8010411d:	68 40 2d 18 80       	push   $0x80182d40
80104122:	e8 e9 05 00 00       	call   80104710 <acquire>
80104127:	83 c4 10             	add    $0x10,%esp
        havekids = 0;
8010412a:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010412c:	bb 74 2d 18 80       	mov    $0x80182d74,%ebx
80104131:	eb 10                	jmp    80104143 <wait+0x43>
80104133:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104137:	90                   	nop
80104138:	83 c3 7c             	add    $0x7c,%ebx
8010413b:	81 fb 74 4c 18 80    	cmp    $0x80184c74,%ebx
80104141:	74 1b                	je     8010415e <wait+0x5e>
            if (p->parent != curproc)
80104143:	39 73 14             	cmp    %esi,0x14(%ebx)
80104146:	75 f0                	jne    80104138 <wait+0x38>
            if (p->state == ZOMBIE) {
80104148:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010414c:	74 62                	je     801041b0 <wait+0xb0>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010414e:	83 c3 7c             	add    $0x7c,%ebx
            havekids = 1;
80104151:	b8 01 00 00 00       	mov    $0x1,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104156:	81 fb 74 4c 18 80    	cmp    $0x80184c74,%ebx
8010415c:	75 e5                	jne    80104143 <wait+0x43>
        if (!havekids || curproc->killed) {
8010415e:	85 c0                	test   %eax,%eax
80104160:	0f 84 a0 00 00 00    	je     80104206 <wait+0x106>
80104166:	8b 46 24             	mov    0x24(%esi),%eax
80104169:	85 c0                	test   %eax,%eax
8010416b:	0f 85 95 00 00 00    	jne    80104206 <wait+0x106>
    pushcli();
80104171:	e8 4a 05 00 00       	call   801046c0 <pushcli>
    c = mycpu();
80104176:	e8 95 f9 ff ff       	call   80103b10 <mycpu>
    p = c->proc;
8010417b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104181:	e8 6a 06 00 00       	call   801047f0 <popcli>
    if (p == 0)
80104186:	85 db                	test   %ebx,%ebx
80104188:	0f 84 8f 00 00 00    	je     8010421d <wait+0x11d>
    p->chan = chan;
8010418e:	89 73 20             	mov    %esi,0x20(%ebx)
    p->state = SLEEPING;
80104191:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
80104198:	e8 73 fd ff ff       	call   80103f10 <sched>
    p->chan = 0;
8010419d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801041a4:	eb 84                	jmp    8010412a <wait+0x2a>
801041a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041ad:	8d 76 00             	lea    0x0(%esi),%esi
                kfree(p->kstack);
801041b0:	83 ec 0c             	sub    $0xc,%esp
                pid = p->pid;
801041b3:	8b 73 10             	mov    0x10(%ebx),%esi
                kfree(p->kstack);
801041b6:	ff 73 08             	push   0x8(%ebx)
801041b9:	e8 82 e3 ff ff       	call   80102540 <kfree>
                p->kstack = 0;
801041be:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                freevm(p->pgdir);
801041c5:	5a                   	pop    %edx
801041c6:	ff 73 04             	push   0x4(%ebx)
801041c9:	e8 72 2e 00 00       	call   80107040 <freevm>
                p->pid = 0;
801041ce:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->parent = 0;
801041d5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->name[0] = 0;
801041dc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
                p->killed = 0;
801041e0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
                p->state = UNUSED;
801041e7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                release(&ptable.lock);
801041ee:	c7 04 24 40 2d 18 80 	movl   $0x80182d40,(%esp)
801041f5:	e8 56 06 00 00       	call   80104850 <release>
                return pid;
801041fa:	83 c4 10             	add    $0x10,%esp
}
801041fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104200:	89 f0                	mov    %esi,%eax
80104202:	5b                   	pop    %ebx
80104203:	5e                   	pop    %esi
80104204:	5d                   	pop    %ebp
80104205:	c3                   	ret
            release(&ptable.lock);
80104206:	83 ec 0c             	sub    $0xc,%esp
            return -1;
80104209:	be ff ff ff ff       	mov    $0xffffffff,%esi
            release(&ptable.lock);
8010420e:	68 40 2d 18 80       	push   $0x80182d40
80104213:	e8 38 06 00 00       	call   80104850 <release>
            return -1;
80104218:	83 c4 10             	add    $0x10,%esp
8010421b:	eb e0                	jmp    801041fd <wait+0xfd>
        panic("sleep");
8010421d:	83 ec 0c             	sub    $0xc,%esp
80104220:	68 ca 7c 10 80       	push   $0x80107cca
80104225:	e8 56 c1 ff ff       	call   80100380 <panic>
8010422a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104230 <yield>:
yield(void) {
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	53                   	push   %ebx
80104234:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);  //DOC: yieldlock
80104237:	68 40 2d 18 80       	push   $0x80182d40
8010423c:	e8 cf 04 00 00       	call   80104710 <acquire>
    pushcli();
80104241:	e8 7a 04 00 00       	call   801046c0 <pushcli>
    c = mycpu();
80104246:	e8 c5 f8 ff ff       	call   80103b10 <mycpu>
    p = c->proc;
8010424b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104251:	e8 9a 05 00 00       	call   801047f0 <popcli>
    myproc()->state = RUNNABLE;
80104256:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    sched();
8010425d:	e8 ae fc ff ff       	call   80103f10 <sched>
    release(&ptable.lock);
80104262:	c7 04 24 40 2d 18 80 	movl   $0x80182d40,(%esp)
80104269:	e8 e2 05 00 00       	call   80104850 <release>
}
8010426e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104271:	83 c4 10             	add    $0x10,%esp
80104274:	c9                   	leave
80104275:	c3                   	ret
80104276:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010427d:	8d 76 00             	lea    0x0(%esi),%esi

80104280 <sleep>:
sleep(void* chan, struct spinlock* lk) {
80104280:	55                   	push   %ebp
80104281:	89 e5                	mov    %esp,%ebp
80104283:	57                   	push   %edi
80104284:	56                   	push   %esi
80104285:	53                   	push   %ebx
80104286:	83 ec 0c             	sub    $0xc,%esp
80104289:	8b 7d 08             	mov    0x8(%ebp),%edi
8010428c:	8b 75 0c             	mov    0xc(%ebp),%esi
    pushcli();
8010428f:	e8 2c 04 00 00       	call   801046c0 <pushcli>
    c = mycpu();
80104294:	e8 77 f8 ff ff       	call   80103b10 <mycpu>
    p = c->proc;
80104299:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
8010429f:	e8 4c 05 00 00       	call   801047f0 <popcli>
    if (p == 0)
801042a4:	85 db                	test   %ebx,%ebx
801042a6:	0f 84 87 00 00 00    	je     80104333 <sleep+0xb3>
    if (lk == 0)
801042ac:	85 f6                	test   %esi,%esi
801042ae:	74 76                	je     80104326 <sleep+0xa6>
    if (lk != &ptable.lock) {  //DOC: sleeplock0
801042b0:	81 fe 40 2d 18 80    	cmp    $0x80182d40,%esi
801042b6:	74 50                	je     80104308 <sleep+0x88>
        acquire(&ptable.lock);  //DOC: sleeplock1
801042b8:	83 ec 0c             	sub    $0xc,%esp
801042bb:	68 40 2d 18 80       	push   $0x80182d40
801042c0:	e8 4b 04 00 00       	call   80104710 <acquire>
        release(lk);
801042c5:	89 34 24             	mov    %esi,(%esp)
801042c8:	e8 83 05 00 00       	call   80104850 <release>
    p->chan = chan;
801042cd:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
801042d0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
801042d7:	e8 34 fc ff ff       	call   80103f10 <sched>
    p->chan = 0;
801042dc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
        release(&ptable.lock);
801042e3:	c7 04 24 40 2d 18 80 	movl   $0x80182d40,(%esp)
801042ea:	e8 61 05 00 00       	call   80104850 <release>
        acquire(lk);
801042ef:	89 75 08             	mov    %esi,0x8(%ebp)
801042f2:	83 c4 10             	add    $0x10,%esp
}
801042f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042f8:	5b                   	pop    %ebx
801042f9:	5e                   	pop    %esi
801042fa:	5f                   	pop    %edi
801042fb:	5d                   	pop    %ebp
        acquire(lk);
801042fc:	e9 0f 04 00 00       	jmp    80104710 <acquire>
80104301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->chan = chan;
80104308:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
8010430b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
80104312:	e8 f9 fb ff ff       	call   80103f10 <sched>
    p->chan = 0;
80104317:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010431e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104321:	5b                   	pop    %ebx
80104322:	5e                   	pop    %esi
80104323:	5f                   	pop    %edi
80104324:	5d                   	pop    %ebp
80104325:	c3                   	ret
        panic("sleep without lk");
80104326:	83 ec 0c             	sub    $0xc,%esp
80104329:	68 d0 7c 10 80       	push   $0x80107cd0
8010432e:	e8 4d c0 ff ff       	call   80100380 <panic>
        panic("sleep");
80104333:	83 ec 0c             	sub    $0xc,%esp
80104336:	68 ca 7c 10 80       	push   $0x80107cca
8010433b:	e8 40 c0 ff ff       	call   80100380 <panic>

80104340 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void* chan) {
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	53                   	push   %ebx
80104344:	83 ec 10             	sub    $0x10,%esp
80104347:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ptable.lock);
8010434a:	68 40 2d 18 80       	push   $0x80182d40
8010434f:	e8 bc 03 00 00       	call   80104710 <acquire>
80104354:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104357:	b8 74 2d 18 80       	mov    $0x80182d74,%eax
8010435c:	eb 0c                	jmp    8010436a <wakeup+0x2a>
8010435e:	66 90                	xchg   %ax,%ax
80104360:	83 c0 7c             	add    $0x7c,%eax
80104363:	3d 74 4c 18 80       	cmp    $0x80184c74,%eax
80104368:	74 1c                	je     80104386 <wakeup+0x46>
        if (p->state == SLEEPING && p->chan == chan)
8010436a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010436e:	75 f0                	jne    80104360 <wakeup+0x20>
80104370:	3b 58 20             	cmp    0x20(%eax),%ebx
80104373:	75 eb                	jne    80104360 <wakeup+0x20>
            p->state = RUNNABLE;
80104375:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010437c:	83 c0 7c             	add    $0x7c,%eax
8010437f:	3d 74 4c 18 80       	cmp    $0x80184c74,%eax
80104384:	75 e4                	jne    8010436a <wakeup+0x2a>
    wakeup1(chan);
    release(&ptable.lock);
80104386:	c7 45 08 40 2d 18 80 	movl   $0x80182d40,0x8(%ebp)
}
8010438d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104390:	c9                   	leave
    release(&ptable.lock);
80104391:	e9 ba 04 00 00       	jmp    80104850 <release>
80104396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010439d:	8d 76 00             	lea    0x0(%esi),%esi

801043a0 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid) {
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	53                   	push   %ebx
801043a4:	83 ec 10             	sub    $0x10,%esp
801043a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc* p;

    acquire(&ptable.lock);
801043aa:	68 40 2d 18 80       	push   $0x80182d40
801043af:	e8 5c 03 00 00       	call   80104710 <acquire>
801043b4:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801043b7:	b8 74 2d 18 80       	mov    $0x80182d74,%eax
801043bc:	eb 0c                	jmp    801043ca <kill+0x2a>
801043be:	66 90                	xchg   %ax,%ax
801043c0:	83 c0 7c             	add    $0x7c,%eax
801043c3:	3d 74 4c 18 80       	cmp    $0x80184c74,%eax
801043c8:	74 36                	je     80104400 <kill+0x60>
        if (p->pid == pid) {
801043ca:	39 58 10             	cmp    %ebx,0x10(%eax)
801043cd:	75 f1                	jne    801043c0 <kill+0x20>
            p->killed = 1;
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING)
801043cf:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
            p->killed = 1;
801043d3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            if (p->state == SLEEPING)
801043da:	75 07                	jne    801043e3 <kill+0x43>
                p->state = RUNNABLE;
801043dc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
            release(&ptable.lock);
801043e3:	83 ec 0c             	sub    $0xc,%esp
801043e6:	68 40 2d 18 80       	push   $0x80182d40
801043eb:	e8 60 04 00 00       	call   80104850 <release>
            return 0;
        }
    }
    release(&ptable.lock);
    return -1;
}
801043f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
            return 0;
801043f3:	83 c4 10             	add    $0x10,%esp
801043f6:	31 c0                	xor    %eax,%eax
}
801043f8:	c9                   	leave
801043f9:	c3                   	ret
801043fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ptable.lock);
80104400:	83 ec 0c             	sub    $0xc,%esp
80104403:	68 40 2d 18 80       	push   $0x80182d40
80104408:	e8 43 04 00 00       	call   80104850 <release>
}
8010440d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104410:	83 c4 10             	add    $0x10,%esp
80104413:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104418:	c9                   	leave
80104419:	c3                   	ret
8010441a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104420 <procdump>:
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void) {
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	57                   	push   %edi
80104424:	56                   	push   %esi
80104425:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104428:	53                   	push   %ebx
80104429:	bb e0 2d 18 80       	mov    $0x80182de0,%ebx
8010442e:	83 ec 3c             	sub    $0x3c,%esp
80104431:	eb 24                	jmp    80104457 <procdump+0x37>
80104433:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104437:	90                   	nop
        if (p->state == SLEEPING) {
            getcallerpcs((uint*) p->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
80104438:	83 ec 0c             	sub    $0xc,%esp
8010443b:	68 a1 7e 10 80       	push   $0x80107ea1
80104440:	e8 6b c2 ff ff       	call   801006b0 <cprintf>
80104445:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104448:	83 c3 7c             	add    $0x7c,%ebx
8010444b:	81 fb e0 4c 18 80    	cmp    $0x80184ce0,%ebx
80104451:	0f 84 81 00 00 00    	je     801044d8 <procdump+0xb8>
        if (p->state == UNUSED)
80104457:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010445a:	85 c0                	test   %eax,%eax
8010445c:	74 ea                	je     80104448 <procdump+0x28>
            state = "???";
8010445e:	ba e1 7c 10 80       	mov    $0x80107ce1,%edx
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104463:	83 f8 05             	cmp    $0x5,%eax
80104466:	77 11                	ja     80104479 <procdump+0x59>
80104468:	8b 14 85 40 7d 10 80 	mov    -0x7fef82c0(,%eax,4),%edx
            state = "???";
8010446f:	b8 e1 7c 10 80       	mov    $0x80107ce1,%eax
80104474:	85 d2                	test   %edx,%edx
80104476:	0f 44 d0             	cmove  %eax,%edx
        cprintf("%d %s %s", p->pid, state, p->name);
80104479:	53                   	push   %ebx
8010447a:	52                   	push   %edx
8010447b:	ff 73 a4             	push   -0x5c(%ebx)
8010447e:	68 e5 7c 10 80       	push   $0x80107ce5
80104483:	e8 28 c2 ff ff       	call   801006b0 <cprintf>
        if (p->state == SLEEPING) {
80104488:	83 c4 10             	add    $0x10,%esp
8010448b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010448f:	75 a7                	jne    80104438 <procdump+0x18>
            getcallerpcs((uint*) p->context->ebp + 2, pc);
80104491:	83 ec 08             	sub    $0x8,%esp
80104494:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104497:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010449a:	50                   	push   %eax
8010449b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010449e:	8b 40 0c             	mov    0xc(%eax),%eax
801044a1:	83 c0 08             	add    $0x8,%eax
801044a4:	50                   	push   %eax
801044a5:	e8 66 01 00 00       	call   80104610 <getcallerpcs>
            for (i = 0; i < 10 && pc[i] != 0; i++)
801044aa:	83 c4 10             	add    $0x10,%esp
801044ad:	8d 76 00             	lea    0x0(%esi),%esi
801044b0:	8b 17                	mov    (%edi),%edx
801044b2:	85 d2                	test   %edx,%edx
801044b4:	74 82                	je     80104438 <procdump+0x18>
                cprintf(" %p", pc[i]);
801044b6:	83 ec 08             	sub    $0x8,%esp
            for (i = 0; i < 10 && pc[i] != 0; i++)
801044b9:	83 c7 04             	add    $0x4,%edi
                cprintf(" %p", pc[i]);
801044bc:	52                   	push   %edx
801044bd:	68 01 77 10 80       	push   $0x80107701
801044c2:	e8 e9 c1 ff ff       	call   801006b0 <cprintf>
            for (i = 0; i < 10 && pc[i] != 0; i++)
801044c7:	83 c4 10             	add    $0x10,%esp
801044ca:	39 f7                	cmp    %esi,%edi
801044cc:	75 e2                	jne    801044b0 <procdump+0x90>
801044ce:	e9 65 ff ff ff       	jmp    80104438 <procdump+0x18>
801044d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044d7:	90                   	nop
    }
}
801044d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044db:	5b                   	pop    %ebx
801044dc:	5e                   	pop    %esi
801044dd:	5f                   	pop    %edi
801044de:	5d                   	pop    %ebp
801044df:	c3                   	ret

801044e0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	53                   	push   %ebx
801044e4:	83 ec 0c             	sub    $0xc,%esp
801044e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801044ea:	68 58 7d 10 80       	push   $0x80107d58
801044ef:	8d 43 04             	lea    0x4(%ebx),%eax
801044f2:	50                   	push   %eax
801044f3:	e8 f8 00 00 00       	call   801045f0 <initlock>
  lk->name = name;
801044f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801044fb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104501:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104504:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010450b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010450e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104511:	c9                   	leave
80104512:	c3                   	ret
80104513:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010451a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104520 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	56                   	push   %esi
80104524:	53                   	push   %ebx
80104525:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104528:	8d 73 04             	lea    0x4(%ebx),%esi
8010452b:	83 ec 0c             	sub    $0xc,%esp
8010452e:	56                   	push   %esi
8010452f:	e8 dc 01 00 00       	call   80104710 <acquire>
  while (lk->locked) {
80104534:	8b 13                	mov    (%ebx),%edx
80104536:	83 c4 10             	add    $0x10,%esp
80104539:	85 d2                	test   %edx,%edx
8010453b:	74 16                	je     80104553 <acquiresleep+0x33>
8010453d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104540:	83 ec 08             	sub    $0x8,%esp
80104543:	56                   	push   %esi
80104544:	53                   	push   %ebx
80104545:	e8 36 fd ff ff       	call   80104280 <sleep>
  while (lk->locked) {
8010454a:	8b 03                	mov    (%ebx),%eax
8010454c:	83 c4 10             	add    $0x10,%esp
8010454f:	85 c0                	test   %eax,%eax
80104551:	75 ed                	jne    80104540 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104553:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104559:	e8 32 f6 ff ff       	call   80103b90 <myproc>
8010455e:	8b 40 10             	mov    0x10(%eax),%eax
80104561:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104564:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104567:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010456a:	5b                   	pop    %ebx
8010456b:	5e                   	pop    %esi
8010456c:	5d                   	pop    %ebp
  release(&lk->lk);
8010456d:	e9 de 02 00 00       	jmp    80104850 <release>
80104572:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104580 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	56                   	push   %esi
80104584:	53                   	push   %ebx
80104585:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104588:	8d 73 04             	lea    0x4(%ebx),%esi
8010458b:	83 ec 0c             	sub    $0xc,%esp
8010458e:	56                   	push   %esi
8010458f:	e8 7c 01 00 00       	call   80104710 <acquire>
  lk->locked = 0;
80104594:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010459a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801045a1:	89 1c 24             	mov    %ebx,(%esp)
801045a4:	e8 97 fd ff ff       	call   80104340 <wakeup>
  release(&lk->lk);
801045a9:	89 75 08             	mov    %esi,0x8(%ebp)
801045ac:	83 c4 10             	add    $0x10,%esp
}
801045af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045b2:	5b                   	pop    %ebx
801045b3:	5e                   	pop    %esi
801045b4:	5d                   	pop    %ebp
  release(&lk->lk);
801045b5:	e9 96 02 00 00       	jmp    80104850 <release>
801045ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045c0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	56                   	push   %esi
801045c4:	53                   	push   %ebx
801045c5:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
801045c8:	8d 5e 04             	lea    0x4(%esi),%ebx
801045cb:	83 ec 0c             	sub    $0xc,%esp
801045ce:	53                   	push   %ebx
801045cf:	e8 3c 01 00 00       	call   80104710 <acquire>
  r = lk->locked;
801045d4:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
801045d6:	89 1c 24             	mov    %ebx,(%esp)
801045d9:	e8 72 02 00 00       	call   80104850 <release>
  return r;
}
801045de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045e1:	89 f0                	mov    %esi,%eax
801045e3:	5b                   	pop    %ebx
801045e4:	5e                   	pop    %esi
801045e5:	5d                   	pop    %ebp
801045e6:	c3                   	ret
801045e7:	66 90                	xchg   %ax,%ax
801045e9:	66 90                	xchg   %ax,%ax
801045eb:	66 90                	xchg   %ax,%ax
801045ed:	66 90                	xchg   %ax,%ax
801045ef:	90                   	nop

801045f0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801045f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801045f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801045ff:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104602:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104609:	5d                   	pop    %ebp
8010460a:	c3                   	ret
8010460b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010460f:	90                   	nop

80104610 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	53                   	push   %ebx
80104614:	8b 45 08             	mov    0x8(%ebp),%eax
80104617:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010461a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010461d:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
80104622:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
80104627:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010462c:	76 10                	jbe    8010463e <getcallerpcs+0x2e>
8010462e:	eb 28                	jmp    80104658 <getcallerpcs+0x48>
80104630:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104636:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010463c:	77 1a                	ja     80104658 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010463e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104641:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104644:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104647:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104649:	83 f8 0a             	cmp    $0xa,%eax
8010464c:	75 e2                	jne    80104630 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010464e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104651:	c9                   	leave
80104652:	c3                   	ret
80104653:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104657:	90                   	nop
80104658:	8d 04 81             	lea    (%ecx,%eax,4),%eax
8010465b:	8d 51 28             	lea    0x28(%ecx),%edx
8010465e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104660:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104666:	83 c0 04             	add    $0x4,%eax
80104669:	39 d0                	cmp    %edx,%eax
8010466b:	75 f3                	jne    80104660 <getcallerpcs+0x50>
}
8010466d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104670:	c9                   	leave
80104671:	c3                   	ret
80104672:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104680 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	53                   	push   %ebx
80104684:	83 ec 04             	sub    $0x4,%esp
80104687:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010468a:	8b 02                	mov    (%edx),%eax
8010468c:	85 c0                	test   %eax,%eax
8010468e:	75 10                	jne    801046a0 <holding+0x20>
}
80104690:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104693:	31 c0                	xor    %eax,%eax
80104695:	c9                   	leave
80104696:	c3                   	ret
80104697:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010469e:	66 90                	xchg   %ax,%ax
  return lock->locked && lock->cpu == mycpu();
801046a0:	8b 5a 08             	mov    0x8(%edx),%ebx
801046a3:	e8 68 f4 ff ff       	call   80103b10 <mycpu>
801046a8:	39 c3                	cmp    %eax,%ebx
}
801046aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046ad:	c9                   	leave
  return lock->locked && lock->cpu == mycpu();
801046ae:	0f 94 c0             	sete   %al
801046b1:	0f b6 c0             	movzbl %al,%eax
}
801046b4:	c3                   	ret
801046b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046c0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	53                   	push   %ebx
801046c4:	83 ec 04             	sub    $0x4,%esp
801046c7:	9c                   	pushf
801046c8:	5b                   	pop    %ebx
  asm volatile("cli");
801046c9:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801046ca:	e8 41 f4 ff ff       	call   80103b10 <mycpu>
801046cf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801046d5:	85 c0                	test   %eax,%eax
801046d7:	74 17                	je     801046f0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801046d9:	e8 32 f4 ff ff       	call   80103b10 <mycpu>
801046de:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801046e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046e8:	c9                   	leave
801046e9:	c3                   	ret
801046ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801046f0:	e8 1b f4 ff ff       	call   80103b10 <mycpu>
801046f5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801046fb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104701:	eb d6                	jmp    801046d9 <pushcli+0x19>
80104703:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010470a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104710 <acquire>:
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	53                   	push   %ebx
80104714:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104717:	e8 a4 ff ff ff       	call   801046c0 <pushcli>
  if(holding(lk))
8010471c:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010471f:	8b 02                	mov    (%edx),%eax
80104721:	85 c0                	test   %eax,%eax
80104723:	0f 85 9f 00 00 00    	jne    801047c8 <acquire+0xb8>
  asm volatile("lock; xchgl %0, %1" :
80104729:	b8 01 00 00 00       	mov    $0x1,%eax
8010472e:	f0 87 02             	lock xchg %eax,(%edx)
80104731:	b9 01 00 00 00       	mov    $0x1,%ecx
  while(xchg(&lk->locked, 1) != 0)
80104736:	85 c0                	test   %eax,%eax
80104738:	74 12                	je     8010474c <acquire+0x3c>
8010473a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104740:	8b 55 08             	mov    0x8(%ebp),%edx
80104743:	89 c8                	mov    %ecx,%eax
80104745:	f0 87 02             	lock xchg %eax,(%edx)
80104748:	85 c0                	test   %eax,%eax
8010474a:	75 f4                	jne    80104740 <acquire+0x30>
  __sync_synchronize();
8010474c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104751:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104754:	e8 b7 f3 ff ff       	call   80103b10 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104759:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
8010475c:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
8010475e:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104761:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
80104767:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
8010476c:	77 32                	ja     801047a0 <acquire+0x90>
  ebp = (uint*)v - 2;
8010476e:	89 e8                	mov    %ebp,%eax
80104770:	eb 14                	jmp    80104786 <acquire+0x76>
80104772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104778:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010477e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104784:	77 1a                	ja     801047a0 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
80104786:	8b 58 04             	mov    0x4(%eax),%ebx
80104789:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010478d:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104790:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104792:	83 fa 0a             	cmp    $0xa,%edx
80104795:	75 e1                	jne    80104778 <acquire+0x68>
}
80104797:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010479a:	c9                   	leave
8010479b:	c3                   	ret
8010479c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047a0:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
801047a4:	8d 51 34             	lea    0x34(%ecx),%edx
801047a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ae:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801047b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801047b6:	83 c0 04             	add    $0x4,%eax
801047b9:	39 d0                	cmp    %edx,%eax
801047bb:	75 f3                	jne    801047b0 <acquire+0xa0>
}
801047bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047c0:	c9                   	leave
801047c1:	c3                   	ret
801047c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return lock->locked && lock->cpu == mycpu();
801047c8:	8b 5a 08             	mov    0x8(%edx),%ebx
801047cb:	e8 40 f3 ff ff       	call   80103b10 <mycpu>
801047d0:	39 c3                	cmp    %eax,%ebx
801047d2:	74 0c                	je     801047e0 <acquire+0xd0>
  while(xchg(&lk->locked, 1) != 0)
801047d4:	8b 55 08             	mov    0x8(%ebp),%edx
801047d7:	e9 4d ff ff ff       	jmp    80104729 <acquire+0x19>
801047dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("acquire");
801047e0:	83 ec 0c             	sub    $0xc,%esp
801047e3:	68 63 7d 10 80       	push   $0x80107d63
801047e8:	e8 93 bb ff ff       	call   80100380 <panic>
801047ed:	8d 76 00             	lea    0x0(%esi),%esi

801047f0 <popcli>:

void
popcli(void)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801047f6:	9c                   	pushf
801047f7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801047f8:	f6 c4 02             	test   $0x2,%ah
801047fb:	75 35                	jne    80104832 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801047fd:	e8 0e f3 ff ff       	call   80103b10 <mycpu>
80104802:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104809:	78 34                	js     8010483f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010480b:	e8 00 f3 ff ff       	call   80103b10 <mycpu>
80104810:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104816:	85 d2                	test   %edx,%edx
80104818:	74 06                	je     80104820 <popcli+0x30>
    sti();
}
8010481a:	c9                   	leave
8010481b:	c3                   	ret
8010481c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104820:	e8 eb f2 ff ff       	call   80103b10 <mycpu>
80104825:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010482b:	85 c0                	test   %eax,%eax
8010482d:	74 eb                	je     8010481a <popcli+0x2a>
  asm volatile("sti");
8010482f:	fb                   	sti
}
80104830:	c9                   	leave
80104831:	c3                   	ret
    panic("popcli - interruptible");
80104832:	83 ec 0c             	sub    $0xc,%esp
80104835:	68 6b 7d 10 80       	push   $0x80107d6b
8010483a:	e8 41 bb ff ff       	call   80100380 <panic>
    panic("popcli");
8010483f:	83 ec 0c             	sub    $0xc,%esp
80104842:	68 82 7d 10 80       	push   $0x80107d82
80104847:	e8 34 bb ff ff       	call   80100380 <panic>
8010484c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104850 <release>:
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	56                   	push   %esi
80104854:	53                   	push   %ebx
80104855:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104858:	8b 03                	mov    (%ebx),%eax
8010485a:	85 c0                	test   %eax,%eax
8010485c:	75 12                	jne    80104870 <release+0x20>
    panic("release");
8010485e:	83 ec 0c             	sub    $0xc,%esp
80104861:	68 89 7d 10 80       	push   $0x80107d89
80104866:	e8 15 bb ff ff       	call   80100380 <panic>
8010486b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010486f:	90                   	nop
  return lock->locked && lock->cpu == mycpu();
80104870:	8b 73 08             	mov    0x8(%ebx),%esi
80104873:	e8 98 f2 ff ff       	call   80103b10 <mycpu>
80104878:	39 c6                	cmp    %eax,%esi
8010487a:	75 e2                	jne    8010485e <release+0xe>
  lk->pcs[0] = 0;
8010487c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104883:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
8010488a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010488f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104895:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104898:	5b                   	pop    %ebx
80104899:	5e                   	pop    %esi
8010489a:	5d                   	pop    %ebp
  popcli();
8010489b:	e9 50 ff ff ff       	jmp    801047f0 <popcli>

801048a0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	57                   	push   %edi
801048a4:	8b 55 08             	mov    0x8(%ebp),%edx
801048a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801048aa:	89 d0                	mov    %edx,%eax
801048ac:	09 c8                	or     %ecx,%eax
801048ae:	a8 03                	test   $0x3,%al
801048b0:	75 1e                	jne    801048d0 <memset+0x30>
    c &= 0xFF;
801048b2:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801048b6:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
801048b9:	89 d7                	mov    %edx,%edi
801048bb:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
801048c1:	fc                   	cld
801048c2:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801048c4:	8b 7d fc             	mov    -0x4(%ebp),%edi
801048c7:	89 d0                	mov    %edx,%eax
801048c9:	c9                   	leave
801048ca:	c3                   	ret
801048cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048cf:	90                   	nop
  asm volatile("cld; rep stosb" :
801048d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801048d3:	89 d7                	mov    %edx,%edi
801048d5:	fc                   	cld
801048d6:	f3 aa                	rep stos %al,%es:(%edi)
801048d8:	8b 7d fc             	mov    -0x4(%ebp),%edi
801048db:	89 d0                	mov    %edx,%eax
801048dd:	c9                   	leave
801048de:	c3                   	ret
801048df:	90                   	nop

801048e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	56                   	push   %esi
801048e4:	53                   	push   %ebx
801048e5:	8b 75 10             	mov    0x10(%ebp),%esi
801048e8:	8b 55 08             	mov    0x8(%ebp),%edx
801048eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801048ee:	85 f6                	test   %esi,%esi
801048f0:	74 2e                	je     80104920 <memcmp+0x40>
801048f2:	01 c6                	add    %eax,%esi
801048f4:	eb 14                	jmp    8010490a <memcmp+0x2a>
801048f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048fd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104900:	83 c0 01             	add    $0x1,%eax
80104903:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104906:	39 f0                	cmp    %esi,%eax
80104908:	74 16                	je     80104920 <memcmp+0x40>
    if(*s1 != *s2)
8010490a:	0f b6 0a             	movzbl (%edx),%ecx
8010490d:	0f b6 18             	movzbl (%eax),%ebx
80104910:	38 d9                	cmp    %bl,%cl
80104912:	74 ec                	je     80104900 <memcmp+0x20>
      return *s1 - *s2;
80104914:	0f b6 c1             	movzbl %cl,%eax
80104917:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104919:	5b                   	pop    %ebx
8010491a:	5e                   	pop    %esi
8010491b:	5d                   	pop    %ebp
8010491c:	c3                   	ret
8010491d:	8d 76 00             	lea    0x0(%esi),%esi
80104920:	5b                   	pop    %ebx
  return 0;
80104921:	31 c0                	xor    %eax,%eax
}
80104923:	5e                   	pop    %esi
80104924:	5d                   	pop    %ebp
80104925:	c3                   	ret
80104926:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010492d:	8d 76 00             	lea    0x0(%esi),%esi

80104930 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	57                   	push   %edi
80104934:	56                   	push   %esi
80104935:	8b 55 08             	mov    0x8(%ebp),%edx
80104938:	8b 75 0c             	mov    0xc(%ebp),%esi
8010493b:	8b 45 10             	mov    0x10(%ebp),%eax
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010493e:	39 d6                	cmp    %edx,%esi
80104940:	73 26                	jae    80104968 <memmove+0x38>
80104942:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104945:	39 ca                	cmp    %ecx,%edx
80104947:	73 1f                	jae    80104968 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104949:	85 c0                	test   %eax,%eax
8010494b:	74 0f                	je     8010495c <memmove+0x2c>
8010494d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80104950:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104954:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104957:	83 e8 01             	sub    $0x1,%eax
8010495a:	73 f4                	jae    80104950 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010495c:	5e                   	pop    %esi
8010495d:	89 d0                	mov    %edx,%eax
8010495f:	5f                   	pop    %edi
80104960:	5d                   	pop    %ebp
80104961:	c3                   	ret
80104962:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104968:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
8010496b:	89 d7                	mov    %edx,%edi
8010496d:	85 c0                	test   %eax,%eax
8010496f:	74 eb                	je     8010495c <memmove+0x2c>
80104971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104978:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104979:	39 ce                	cmp    %ecx,%esi
8010497b:	75 fb                	jne    80104978 <memmove+0x48>
}
8010497d:	5e                   	pop    %esi
8010497e:	89 d0                	mov    %edx,%eax
80104980:	5f                   	pop    %edi
80104981:	5d                   	pop    %ebp
80104982:	c3                   	ret
80104983:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010498a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104990 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104990:	eb 9e                	jmp    80104930 <memmove>
80104992:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049a0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	53                   	push   %ebx
801049a4:	8b 55 10             	mov    0x10(%ebp),%edx
801049a7:	8b 45 08             	mov    0x8(%ebp),%eax
801049aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
801049ad:	85 d2                	test   %edx,%edx
801049af:	75 16                	jne    801049c7 <strncmp+0x27>
801049b1:	eb 2d                	jmp    801049e0 <strncmp+0x40>
801049b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049b7:	90                   	nop
801049b8:	3a 19                	cmp    (%ecx),%bl
801049ba:	75 12                	jne    801049ce <strncmp+0x2e>
    n--, p++, q++;
801049bc:	83 c0 01             	add    $0x1,%eax
801049bf:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801049c2:	83 ea 01             	sub    $0x1,%edx
801049c5:	74 19                	je     801049e0 <strncmp+0x40>
801049c7:	0f b6 18             	movzbl (%eax),%ebx
801049ca:	84 db                	test   %bl,%bl
801049cc:	75 ea                	jne    801049b8 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801049ce:	0f b6 00             	movzbl (%eax),%eax
801049d1:	0f b6 11             	movzbl (%ecx),%edx
}
801049d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049d7:	c9                   	leave
  return (uchar)*p - (uchar)*q;
801049d8:	29 d0                	sub    %edx,%eax
}
801049da:	c3                   	ret
801049db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049df:	90                   	nop
801049e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801049e3:	31 c0                	xor    %eax,%eax
}
801049e5:	c9                   	leave
801049e6:	c3                   	ret
801049e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ee:	66 90                	xchg   %ax,%ax

801049f0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	57                   	push   %edi
801049f4:	56                   	push   %esi
801049f5:	53                   	push   %ebx
801049f6:	8b 75 08             	mov    0x8(%ebp),%esi
801049f9:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801049fc:	89 f0                	mov    %esi,%eax
801049fe:	eb 15                	jmp    80104a15 <strncpy+0x25>
80104a00:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104a04:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104a07:	83 c0 01             	add    $0x1,%eax
80104a0a:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
80104a0e:	88 48 ff             	mov    %cl,-0x1(%eax)
80104a11:	84 c9                	test   %cl,%cl
80104a13:	74 13                	je     80104a28 <strncpy+0x38>
80104a15:	89 d3                	mov    %edx,%ebx
80104a17:	83 ea 01             	sub    $0x1,%edx
80104a1a:	85 db                	test   %ebx,%ebx
80104a1c:	7f e2                	jg     80104a00 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
80104a1e:	5b                   	pop    %ebx
80104a1f:	89 f0                	mov    %esi,%eax
80104a21:	5e                   	pop    %esi
80104a22:	5f                   	pop    %edi
80104a23:	5d                   	pop    %ebp
80104a24:	c3                   	ret
80104a25:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80104a28:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
80104a2b:	83 e9 01             	sub    $0x1,%ecx
80104a2e:	85 d2                	test   %edx,%edx
80104a30:	74 ec                	je     80104a1e <strncpy+0x2e>
80104a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80104a38:	83 c0 01             	add    $0x1,%eax
80104a3b:	89 ca                	mov    %ecx,%edx
80104a3d:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80104a41:	29 c2                	sub    %eax,%edx
80104a43:	85 d2                	test   %edx,%edx
80104a45:	7f f1                	jg     80104a38 <strncpy+0x48>
}
80104a47:	5b                   	pop    %ebx
80104a48:	89 f0                	mov    %esi,%eax
80104a4a:	5e                   	pop    %esi
80104a4b:	5f                   	pop    %edi
80104a4c:	5d                   	pop    %ebp
80104a4d:	c3                   	ret
80104a4e:	66 90                	xchg   %ax,%ax

80104a50 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	56                   	push   %esi
80104a54:	53                   	push   %ebx
80104a55:	8b 55 10             	mov    0x10(%ebp),%edx
80104a58:	8b 75 08             	mov    0x8(%ebp),%esi
80104a5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104a5e:	85 d2                	test   %edx,%edx
80104a60:	7e 25                	jle    80104a87 <safestrcpy+0x37>
80104a62:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104a66:	89 f2                	mov    %esi,%edx
80104a68:	eb 16                	jmp    80104a80 <safestrcpy+0x30>
80104a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104a70:	0f b6 08             	movzbl (%eax),%ecx
80104a73:	83 c0 01             	add    $0x1,%eax
80104a76:	83 c2 01             	add    $0x1,%edx
80104a79:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a7c:	84 c9                	test   %cl,%cl
80104a7e:	74 04                	je     80104a84 <safestrcpy+0x34>
80104a80:	39 d8                	cmp    %ebx,%eax
80104a82:	75 ec                	jne    80104a70 <safestrcpy+0x20>
    ;
  *s = 0;
80104a84:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104a87:	89 f0                	mov    %esi,%eax
80104a89:	5b                   	pop    %ebx
80104a8a:	5e                   	pop    %esi
80104a8b:	5d                   	pop    %ebp
80104a8c:	c3                   	ret
80104a8d:	8d 76 00             	lea    0x0(%esi),%esi

80104a90 <strlen>:

int
strlen(const char *s)
{
80104a90:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104a91:	31 c0                	xor    %eax,%eax
{
80104a93:	89 e5                	mov    %esp,%ebp
80104a95:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104a98:	80 3a 00             	cmpb   $0x0,(%edx)
80104a9b:	74 0c                	je     80104aa9 <strlen+0x19>
80104a9d:	8d 76 00             	lea    0x0(%esi),%esi
80104aa0:	83 c0 01             	add    $0x1,%eax
80104aa3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104aa7:	75 f7                	jne    80104aa0 <strlen+0x10>
    ;
  return n;
}
80104aa9:	5d                   	pop    %ebp
80104aaa:	c3                   	ret

80104aab <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104aab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104aaf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104ab3:	55                   	push   %ebp
  pushl %ebx
80104ab4:	53                   	push   %ebx
  pushl %esi
80104ab5:	56                   	push   %esi
  pushl %edi
80104ab6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104ab7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104ab9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104abb:	5f                   	pop    %edi
  popl %esi
80104abc:	5e                   	pop    %esi
  popl %ebx
80104abd:	5b                   	pop    %ebx
  popl %ebp
80104abe:	5d                   	pop    %ebp
  ret
80104abf:	c3                   	ret

80104ac0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	53                   	push   %ebx
80104ac4:	83 ec 04             	sub    $0x4,%esp
80104ac7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104aca:	e8 c1 f0 ff ff       	call   80103b90 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104acf:	8b 00                	mov    (%eax),%eax
80104ad1:	39 c3                	cmp    %eax,%ebx
80104ad3:	73 1b                	jae    80104af0 <fetchint+0x30>
80104ad5:	8d 53 04             	lea    0x4(%ebx),%edx
80104ad8:	39 d0                	cmp    %edx,%eax
80104ada:	72 14                	jb     80104af0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104adc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104adf:	8b 13                	mov    (%ebx),%edx
80104ae1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ae3:	31 c0                	xor    %eax,%eax
}
80104ae5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ae8:	c9                   	leave
80104ae9:	c3                   	ret
80104aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104af0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104af5:	eb ee                	jmp    80104ae5 <fetchint+0x25>
80104af7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104afe:	66 90                	xchg   %ax,%ax

80104b00 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	53                   	push   %ebx
80104b04:	83 ec 04             	sub    $0x4,%esp
80104b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104b0a:	e8 81 f0 ff ff       	call   80103b90 <myproc>

  if(addr >= curproc->sz)
80104b0f:	3b 18                	cmp    (%eax),%ebx
80104b11:	73 2d                	jae    80104b40 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104b13:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b16:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104b18:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104b1a:	39 d3                	cmp    %edx,%ebx
80104b1c:	73 22                	jae    80104b40 <fetchstr+0x40>
80104b1e:	89 d8                	mov    %ebx,%eax
80104b20:	eb 0d                	jmp    80104b2f <fetchstr+0x2f>
80104b22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b28:	83 c0 01             	add    $0x1,%eax
80104b2b:	39 d0                	cmp    %edx,%eax
80104b2d:	73 11                	jae    80104b40 <fetchstr+0x40>
    if(*s == 0)
80104b2f:	80 38 00             	cmpb   $0x0,(%eax)
80104b32:	75 f4                	jne    80104b28 <fetchstr+0x28>
      return s - *pp;
80104b34:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104b36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b39:	c9                   	leave
80104b3a:	c3                   	ret
80104b3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b3f:	90                   	nop
80104b40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104b43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b48:	c9                   	leave
80104b49:	c3                   	ret
80104b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b50 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	56                   	push   %esi
80104b54:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b55:	e8 36 f0 ff ff       	call   80103b90 <myproc>
80104b5a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b5d:	8b 40 18             	mov    0x18(%eax),%eax
80104b60:	8b 40 44             	mov    0x44(%eax),%eax
80104b63:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b66:	e8 25 f0 ff ff       	call   80103b90 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b6b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b6e:	8b 00                	mov    (%eax),%eax
80104b70:	39 c6                	cmp    %eax,%esi
80104b72:	73 1c                	jae    80104b90 <argint+0x40>
80104b74:	8d 53 08             	lea    0x8(%ebx),%edx
80104b77:	39 d0                	cmp    %edx,%eax
80104b79:	72 15                	jb     80104b90 <argint+0x40>
  *ip = *(int*)(addr);
80104b7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b7e:	8b 53 04             	mov    0x4(%ebx),%edx
80104b81:	89 10                	mov    %edx,(%eax)
  return 0;
80104b83:	31 c0                	xor    %eax,%eax
}
80104b85:	5b                   	pop    %ebx
80104b86:	5e                   	pop    %esi
80104b87:	5d                   	pop    %ebp
80104b88:	c3                   	ret
80104b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b95:	eb ee                	jmp    80104b85 <argint+0x35>
80104b97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b9e:	66 90                	xchg   %ax,%ax

80104ba0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	57                   	push   %edi
80104ba4:	56                   	push   %esi
80104ba5:	53                   	push   %ebx
80104ba6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104ba9:	e8 e2 ef ff ff       	call   80103b90 <myproc>
80104bae:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bb0:	e8 db ef ff ff       	call   80103b90 <myproc>
80104bb5:	8b 55 08             	mov    0x8(%ebp),%edx
80104bb8:	8b 40 18             	mov    0x18(%eax),%eax
80104bbb:	8b 40 44             	mov    0x44(%eax),%eax
80104bbe:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104bc1:	e8 ca ef ff ff       	call   80103b90 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bc6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bc9:	8b 00                	mov    (%eax),%eax
80104bcb:	39 c7                	cmp    %eax,%edi
80104bcd:	73 31                	jae    80104c00 <argptr+0x60>
80104bcf:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104bd2:	39 c8                	cmp    %ecx,%eax
80104bd4:	72 2a                	jb     80104c00 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104bd6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104bd9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104bdc:	85 d2                	test   %edx,%edx
80104bde:	78 20                	js     80104c00 <argptr+0x60>
80104be0:	8b 16                	mov    (%esi),%edx
80104be2:	39 d0                	cmp    %edx,%eax
80104be4:	73 1a                	jae    80104c00 <argptr+0x60>
80104be6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104be9:	01 c3                	add    %eax,%ebx
80104beb:	39 da                	cmp    %ebx,%edx
80104bed:	72 11                	jb     80104c00 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104bef:	8b 55 0c             	mov    0xc(%ebp),%edx
80104bf2:	89 02                	mov    %eax,(%edx)
  return 0;
80104bf4:	31 c0                	xor    %eax,%eax
}
80104bf6:	83 c4 0c             	add    $0xc,%esp
80104bf9:	5b                   	pop    %ebx
80104bfa:	5e                   	pop    %esi
80104bfb:	5f                   	pop    %edi
80104bfc:	5d                   	pop    %ebp
80104bfd:	c3                   	ret
80104bfe:	66 90                	xchg   %ax,%ax
    return -1;
80104c00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c05:	eb ef                	jmp    80104bf6 <argptr+0x56>
80104c07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c0e:	66 90                	xchg   %ax,%ax

80104c10 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	56                   	push   %esi
80104c14:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c15:	e8 76 ef ff ff       	call   80103b90 <myproc>
80104c1a:	8b 55 08             	mov    0x8(%ebp),%edx
80104c1d:	8b 40 18             	mov    0x18(%eax),%eax
80104c20:	8b 40 44             	mov    0x44(%eax),%eax
80104c23:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c26:	e8 65 ef ff ff       	call   80103b90 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c2b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c2e:	8b 00                	mov    (%eax),%eax
80104c30:	39 c6                	cmp    %eax,%esi
80104c32:	73 44                	jae    80104c78 <argstr+0x68>
80104c34:	8d 53 08             	lea    0x8(%ebx),%edx
80104c37:	39 d0                	cmp    %edx,%eax
80104c39:	72 3d                	jb     80104c78 <argstr+0x68>
  *ip = *(int*)(addr);
80104c3b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104c3e:	e8 4d ef ff ff       	call   80103b90 <myproc>
  if(addr >= curproc->sz)
80104c43:	3b 18                	cmp    (%eax),%ebx
80104c45:	73 31                	jae    80104c78 <argstr+0x68>
  *pp = (char*)addr;
80104c47:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c4a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104c4c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104c4e:	39 d3                	cmp    %edx,%ebx
80104c50:	73 26                	jae    80104c78 <argstr+0x68>
80104c52:	89 d8                	mov    %ebx,%eax
80104c54:	eb 11                	jmp    80104c67 <argstr+0x57>
80104c56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c5d:	8d 76 00             	lea    0x0(%esi),%esi
80104c60:	83 c0 01             	add    $0x1,%eax
80104c63:	39 d0                	cmp    %edx,%eax
80104c65:	73 11                	jae    80104c78 <argstr+0x68>
    if(*s == 0)
80104c67:	80 38 00             	cmpb   $0x0,(%eax)
80104c6a:	75 f4                	jne    80104c60 <argstr+0x50>
      return s - *pp;
80104c6c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104c6e:	5b                   	pop    %ebx
80104c6f:	5e                   	pop    %esi
80104c70:	5d                   	pop    %ebp
80104c71:	c3                   	ret
80104c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c78:	5b                   	pop    %ebx
    return -1;
80104c79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c7e:	5e                   	pop    %esi
80104c7f:	5d                   	pop    %ebp
80104c80:	c3                   	ret
80104c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c8f:	90                   	nop

80104c90 <syscall>:

};

void
syscall(void)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	53                   	push   %ebx
80104c94:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104c97:	e8 f4 ee ff ff       	call   80103b90 <myproc>
80104c9c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104c9e:	8b 40 18             	mov    0x18(%eax),%eax
80104ca1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104ca4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104ca7:	83 fa 18             	cmp    $0x18,%edx
80104caa:	77 24                	ja     80104cd0 <syscall+0x40>
80104cac:	8b 14 85 c0 7d 10 80 	mov    -0x7fef8240(,%eax,4),%edx
80104cb3:	85 d2                	test   %edx,%edx
80104cb5:	74 19                	je     80104cd0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104cb7:	ff d2                	call   *%edx
80104cb9:	89 c2                	mov    %eax,%edx
80104cbb:	8b 43 18             	mov    0x18(%ebx),%eax
80104cbe:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104cc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cc4:	c9                   	leave
80104cc5:	c3                   	ret
80104cc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ccd:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104cd0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104cd1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104cd4:	50                   	push   %eax
80104cd5:	ff 73 10             	push   0x10(%ebx)
80104cd8:	68 91 7d 10 80       	push   $0x80107d91
80104cdd:	e8 ce b9 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104ce2:	8b 43 18             	mov    0x18(%ebx),%eax
80104ce5:	83 c4 10             	add    $0x10,%esp
80104ce8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104cef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cf2:	c9                   	leave
80104cf3:	c3                   	ret
80104cf4:	66 90                	xchg   %ax,%ax
80104cf6:	66 90                	xchg   %ax,%ax
80104cf8:	66 90                	xchg   %ax,%ax
80104cfa:	66 90                	xchg   %ax,%ax
80104cfc:	66 90                	xchg   %ax,%ax
80104cfe:	66 90                	xchg   %ax,%ax

80104d00 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	57                   	push   %edi
80104d04:	56                   	push   %esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104d05:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104d08:	53                   	push   %ebx
80104d09:	83 ec 44             	sub    $0x44,%esp
80104d0c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104d0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104d12:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104d15:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104d18:	57                   	push   %edi
80104d19:	50                   	push   %eax
80104d1a:	e8 21 d4 ff ff       	call   80102140 <nameiparent>
80104d1f:	83 c4 10             	add    $0x10,%esp
80104d22:	85 c0                	test   %eax,%eax
80104d24:	74 5e                	je     80104d84 <create+0x84>
    return 0;
  ilock(dp);
80104d26:	83 ec 0c             	sub    $0xc,%esp
80104d29:	89 c3                	mov    %eax,%ebx
80104d2b:	50                   	push   %eax
80104d2c:	e8 bf ca ff ff       	call   801017f0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104d31:	83 c4 0c             	add    $0xc,%esp
80104d34:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104d37:	50                   	push   %eax
80104d38:	57                   	push   %edi
80104d39:	53                   	push   %ebx
80104d3a:	e8 11 d0 ff ff       	call   80101d50 <dirlookup>
80104d3f:	83 c4 10             	add    $0x10,%esp
80104d42:	89 c6                	mov    %eax,%esi
80104d44:	85 c0                	test   %eax,%eax
80104d46:	74 48                	je     80104d90 <create+0x90>
    iunlockput(dp);
80104d48:	83 ec 0c             	sub    $0xc,%esp
80104d4b:	53                   	push   %ebx
80104d4c:	e8 2f cd ff ff       	call   80101a80 <iunlockput>
    ilock(ip);
80104d51:	89 34 24             	mov    %esi,(%esp)
80104d54:	e8 97 ca ff ff       	call   801017f0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104d59:	83 c4 10             	add    $0x10,%esp
80104d5c:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104d61:	75 15                	jne    80104d78 <create+0x78>
80104d63:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104d68:	75 0e                	jne    80104d78 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104d6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d6d:	89 f0                	mov    %esi,%eax
80104d6f:	5b                   	pop    %ebx
80104d70:	5e                   	pop    %esi
80104d71:	5f                   	pop    %edi
80104d72:	5d                   	pop    %ebp
80104d73:	c3                   	ret
80104d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80104d78:	83 ec 0c             	sub    $0xc,%esp
80104d7b:	56                   	push   %esi
80104d7c:	e8 ff cc ff ff       	call   80101a80 <iunlockput>
    return 0;
80104d81:	83 c4 10             	add    $0x10,%esp
}
80104d84:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104d87:	31 f6                	xor    %esi,%esi
}
80104d89:	5b                   	pop    %ebx
80104d8a:	89 f0                	mov    %esi,%eax
80104d8c:	5e                   	pop    %esi
80104d8d:	5f                   	pop    %edi
80104d8e:	5d                   	pop    %ebp
80104d8f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80104d90:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104d94:	83 ec 08             	sub    $0x8,%esp
80104d97:	50                   	push   %eax
80104d98:	ff 33                	push   (%ebx)
80104d9a:	e8 e1 c8 ff ff       	call   80101680 <ialloc>
80104d9f:	83 c4 10             	add    $0x10,%esp
80104da2:	89 c6                	mov    %eax,%esi
80104da4:	85 c0                	test   %eax,%eax
80104da6:	0f 84 bc 00 00 00    	je     80104e68 <create+0x168>
  ilock(ip);
80104dac:	83 ec 0c             	sub    $0xc,%esp
80104daf:	50                   	push   %eax
80104db0:	e8 3b ca ff ff       	call   801017f0 <ilock>
  ip->major = major;
80104db5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104db9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104dbd:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104dc1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104dc5:	b8 01 00 00 00       	mov    $0x1,%eax
80104dca:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104dce:	89 34 24             	mov    %esi,(%esp)
80104dd1:	e8 6a c9 ff ff       	call   80101740 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104dd6:	83 c4 10             	add    $0x10,%esp
80104dd9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104dde:	74 30                	je     80104e10 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80104de0:	83 ec 04             	sub    $0x4,%esp
80104de3:	ff 76 04             	push   0x4(%esi)
80104de6:	57                   	push   %edi
80104de7:	53                   	push   %ebx
80104de8:	e8 73 d2 ff ff       	call   80102060 <dirlink>
80104ded:	83 c4 10             	add    $0x10,%esp
80104df0:	85 c0                	test   %eax,%eax
80104df2:	78 67                	js     80104e5b <create+0x15b>
  iunlockput(dp);
80104df4:	83 ec 0c             	sub    $0xc,%esp
80104df7:	53                   	push   %ebx
80104df8:	e8 83 cc ff ff       	call   80101a80 <iunlockput>
  return ip;
80104dfd:	83 c4 10             	add    $0x10,%esp
}
80104e00:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e03:	89 f0                	mov    %esi,%eax
80104e05:	5b                   	pop    %ebx
80104e06:	5e                   	pop    %esi
80104e07:	5f                   	pop    %edi
80104e08:	5d                   	pop    %ebp
80104e09:	c3                   	ret
80104e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104e10:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104e13:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104e18:	53                   	push   %ebx
80104e19:	e8 22 c9 ff ff       	call   80101740 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104e1e:	83 c4 0c             	add    $0xc,%esp
80104e21:	ff 76 04             	push   0x4(%esi)
80104e24:	68 44 7e 10 80       	push   $0x80107e44
80104e29:	56                   	push   %esi
80104e2a:	e8 31 d2 ff ff       	call   80102060 <dirlink>
80104e2f:	83 c4 10             	add    $0x10,%esp
80104e32:	85 c0                	test   %eax,%eax
80104e34:	78 18                	js     80104e4e <create+0x14e>
80104e36:	83 ec 04             	sub    $0x4,%esp
80104e39:	ff 73 04             	push   0x4(%ebx)
80104e3c:	68 43 7e 10 80       	push   $0x80107e43
80104e41:	56                   	push   %esi
80104e42:	e8 19 d2 ff ff       	call   80102060 <dirlink>
80104e47:	83 c4 10             	add    $0x10,%esp
80104e4a:	85 c0                	test   %eax,%eax
80104e4c:	79 92                	jns    80104de0 <create+0xe0>
      panic("create dots");
80104e4e:	83 ec 0c             	sub    $0xc,%esp
80104e51:	68 37 7e 10 80       	push   $0x80107e37
80104e56:	e8 25 b5 ff ff       	call   80100380 <panic>
    panic("create: dirlink");
80104e5b:	83 ec 0c             	sub    $0xc,%esp
80104e5e:	68 46 7e 10 80       	push   $0x80107e46
80104e63:	e8 18 b5 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104e68:	83 ec 0c             	sub    $0xc,%esp
80104e6b:	68 28 7e 10 80       	push   $0x80107e28
80104e70:	e8 0b b5 ff ff       	call   80100380 <panic>
80104e75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e80 <sys_dup>:
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	56                   	push   %esi
80104e84:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e85:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104e88:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e8b:	50                   	push   %eax
80104e8c:	6a 00                	push   $0x0
80104e8e:	e8 bd fc ff ff       	call   80104b50 <argint>
80104e93:	83 c4 10             	add    $0x10,%esp
80104e96:	85 c0                	test   %eax,%eax
80104e98:	78 36                	js     80104ed0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e9a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e9e:	77 30                	ja     80104ed0 <sys_dup+0x50>
80104ea0:	e8 eb ec ff ff       	call   80103b90 <myproc>
80104ea5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ea8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104eac:	85 f6                	test   %esi,%esi
80104eae:	74 20                	je     80104ed0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104eb0:	e8 db ec ff ff       	call   80103b90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104eb5:	31 db                	xor    %ebx,%ebx
80104eb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ebe:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104ec0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104ec4:	85 d2                	test   %edx,%edx
80104ec6:	74 18                	je     80104ee0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104ec8:	83 c3 01             	add    $0x1,%ebx
80104ecb:	83 fb 10             	cmp    $0x10,%ebx
80104ece:	75 f0                	jne    80104ec0 <sys_dup+0x40>
}
80104ed0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104ed3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104ed8:	89 d8                	mov    %ebx,%eax
80104eda:	5b                   	pop    %ebx
80104edb:	5e                   	pop    %esi
80104edc:	5d                   	pop    %ebp
80104edd:	c3                   	ret
80104ede:	66 90                	xchg   %ax,%ax
  filedup(f);
80104ee0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104ee3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104ee7:	56                   	push   %esi
80104ee8:	e8 03 c0 ff ff       	call   80100ef0 <filedup>
  return fd;
80104eed:	83 c4 10             	add    $0x10,%esp
}
80104ef0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ef3:	89 d8                	mov    %ebx,%eax
80104ef5:	5b                   	pop    %ebx
80104ef6:	5e                   	pop    %esi
80104ef7:	5d                   	pop    %ebp
80104ef8:	c3                   	ret
80104ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f00 <sys_read>:
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	56                   	push   %esi
80104f04:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f05:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f08:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f0b:	53                   	push   %ebx
80104f0c:	6a 00                	push   $0x0
80104f0e:	e8 3d fc ff ff       	call   80104b50 <argint>
80104f13:	83 c4 10             	add    $0x10,%esp
80104f16:	85 c0                	test   %eax,%eax
80104f18:	78 5e                	js     80104f78 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f1a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f1e:	77 58                	ja     80104f78 <sys_read+0x78>
80104f20:	e8 6b ec ff ff       	call   80103b90 <myproc>
80104f25:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f28:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f2c:	85 f6                	test   %esi,%esi
80104f2e:	74 48                	je     80104f78 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f30:	83 ec 08             	sub    $0x8,%esp
80104f33:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f36:	50                   	push   %eax
80104f37:	6a 02                	push   $0x2
80104f39:	e8 12 fc ff ff       	call   80104b50 <argint>
80104f3e:	83 c4 10             	add    $0x10,%esp
80104f41:	85 c0                	test   %eax,%eax
80104f43:	78 33                	js     80104f78 <sys_read+0x78>
80104f45:	83 ec 04             	sub    $0x4,%esp
80104f48:	ff 75 f0             	push   -0x10(%ebp)
80104f4b:	53                   	push   %ebx
80104f4c:	6a 01                	push   $0x1
80104f4e:	e8 4d fc ff ff       	call   80104ba0 <argptr>
80104f53:	83 c4 10             	add    $0x10,%esp
80104f56:	85 c0                	test   %eax,%eax
80104f58:	78 1e                	js     80104f78 <sys_read+0x78>
  return fileread(f, p, n);
80104f5a:	83 ec 04             	sub    $0x4,%esp
80104f5d:	ff 75 f0             	push   -0x10(%ebp)
80104f60:	ff 75 f4             	push   -0xc(%ebp)
80104f63:	56                   	push   %esi
80104f64:	e8 07 c1 ff ff       	call   80101070 <fileread>
80104f69:	83 c4 10             	add    $0x10,%esp
}
80104f6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f6f:	5b                   	pop    %ebx
80104f70:	5e                   	pop    %esi
80104f71:	5d                   	pop    %ebp
80104f72:	c3                   	ret
80104f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f77:	90                   	nop
    return -1;
80104f78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f7d:	eb ed                	jmp    80104f6c <sys_read+0x6c>
80104f7f:	90                   	nop

80104f80 <sys_write>:
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	56                   	push   %esi
80104f84:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f85:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f88:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f8b:	53                   	push   %ebx
80104f8c:	6a 00                	push   $0x0
80104f8e:	e8 bd fb ff ff       	call   80104b50 <argint>
80104f93:	83 c4 10             	add    $0x10,%esp
80104f96:	85 c0                	test   %eax,%eax
80104f98:	78 5e                	js     80104ff8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f9a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f9e:	77 58                	ja     80104ff8 <sys_write+0x78>
80104fa0:	e8 eb eb ff ff       	call   80103b90 <myproc>
80104fa5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fa8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104fac:	85 f6                	test   %esi,%esi
80104fae:	74 48                	je     80104ff8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fb0:	83 ec 08             	sub    $0x8,%esp
80104fb3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fb6:	50                   	push   %eax
80104fb7:	6a 02                	push   $0x2
80104fb9:	e8 92 fb ff ff       	call   80104b50 <argint>
80104fbe:	83 c4 10             	add    $0x10,%esp
80104fc1:	85 c0                	test   %eax,%eax
80104fc3:	78 33                	js     80104ff8 <sys_write+0x78>
80104fc5:	83 ec 04             	sub    $0x4,%esp
80104fc8:	ff 75 f0             	push   -0x10(%ebp)
80104fcb:	53                   	push   %ebx
80104fcc:	6a 01                	push   $0x1
80104fce:	e8 cd fb ff ff       	call   80104ba0 <argptr>
80104fd3:	83 c4 10             	add    $0x10,%esp
80104fd6:	85 c0                	test   %eax,%eax
80104fd8:	78 1e                	js     80104ff8 <sys_write+0x78>
  return filewrite(f, p, n);
80104fda:	83 ec 04             	sub    $0x4,%esp
80104fdd:	ff 75 f0             	push   -0x10(%ebp)
80104fe0:	ff 75 f4             	push   -0xc(%ebp)
80104fe3:	56                   	push   %esi
80104fe4:	e8 17 c1 ff ff       	call   80101100 <filewrite>
80104fe9:	83 c4 10             	add    $0x10,%esp
}
80104fec:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fef:	5b                   	pop    %ebx
80104ff0:	5e                   	pop    %esi
80104ff1:	5d                   	pop    %ebp
80104ff2:	c3                   	ret
80104ff3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ff7:	90                   	nop
    return -1;
80104ff8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ffd:	eb ed                	jmp    80104fec <sys_write+0x6c>
80104fff:	90                   	nop

80105000 <sys_close>:
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	56                   	push   %esi
80105004:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105005:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105008:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010500b:	50                   	push   %eax
8010500c:	6a 00                	push   $0x0
8010500e:	e8 3d fb ff ff       	call   80104b50 <argint>
80105013:	83 c4 10             	add    $0x10,%esp
80105016:	85 c0                	test   %eax,%eax
80105018:	78 3e                	js     80105058 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010501a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010501e:	77 38                	ja     80105058 <sys_close+0x58>
80105020:	e8 6b eb ff ff       	call   80103b90 <myproc>
80105025:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105028:	8d 5a 08             	lea    0x8(%edx),%ebx
8010502b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010502f:	85 f6                	test   %esi,%esi
80105031:	74 25                	je     80105058 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105033:	e8 58 eb ff ff       	call   80103b90 <myproc>
  fileclose(f);
80105038:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010503b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105042:	00 
  fileclose(f);
80105043:	56                   	push   %esi
80105044:	e8 f7 be ff ff       	call   80100f40 <fileclose>
  return 0;
80105049:	83 c4 10             	add    $0x10,%esp
8010504c:	31 c0                	xor    %eax,%eax
}
8010504e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105051:	5b                   	pop    %ebx
80105052:	5e                   	pop    %esi
80105053:	5d                   	pop    %ebp
80105054:	c3                   	ret
80105055:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105058:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010505d:	eb ef                	jmp    8010504e <sys_close+0x4e>
8010505f:	90                   	nop

80105060 <sys_fstat>:
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	56                   	push   %esi
80105064:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105065:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105068:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010506b:	53                   	push   %ebx
8010506c:	6a 00                	push   $0x0
8010506e:	e8 dd fa ff ff       	call   80104b50 <argint>
80105073:	83 c4 10             	add    $0x10,%esp
80105076:	85 c0                	test   %eax,%eax
80105078:	78 46                	js     801050c0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010507a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010507e:	77 40                	ja     801050c0 <sys_fstat+0x60>
80105080:	e8 0b eb ff ff       	call   80103b90 <myproc>
80105085:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105088:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010508c:	85 f6                	test   %esi,%esi
8010508e:	74 30                	je     801050c0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105090:	83 ec 04             	sub    $0x4,%esp
80105093:	6a 14                	push   $0x14
80105095:	53                   	push   %ebx
80105096:	6a 01                	push   $0x1
80105098:	e8 03 fb ff ff       	call   80104ba0 <argptr>
8010509d:	83 c4 10             	add    $0x10,%esp
801050a0:	85 c0                	test   %eax,%eax
801050a2:	78 1c                	js     801050c0 <sys_fstat+0x60>
  return filestat(f, st);
801050a4:	83 ec 08             	sub    $0x8,%esp
801050a7:	ff 75 f4             	push   -0xc(%ebp)
801050aa:	56                   	push   %esi
801050ab:	e8 70 bf ff ff       	call   80101020 <filestat>
801050b0:	83 c4 10             	add    $0x10,%esp
}
801050b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050b6:	5b                   	pop    %ebx
801050b7:	5e                   	pop    %esi
801050b8:	5d                   	pop    %ebp
801050b9:	c3                   	ret
801050ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801050c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050c5:	eb ec                	jmp    801050b3 <sys_fstat+0x53>
801050c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ce:	66 90                	xchg   %ax,%ax

801050d0 <sys_link>:
{
801050d0:	55                   	push   %ebp
801050d1:	89 e5                	mov    %esp,%ebp
801050d3:	57                   	push   %edi
801050d4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050d5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801050d8:	53                   	push   %ebx
801050d9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050dc:	50                   	push   %eax
801050dd:	6a 00                	push   $0x0
801050df:	e8 2c fb ff ff       	call   80104c10 <argstr>
801050e4:	83 c4 10             	add    $0x10,%esp
801050e7:	85 c0                	test   %eax,%eax
801050e9:	0f 88 fb 00 00 00    	js     801051ea <sys_link+0x11a>
801050ef:	83 ec 08             	sub    $0x8,%esp
801050f2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801050f5:	50                   	push   %eax
801050f6:	6a 01                	push   $0x1
801050f8:	e8 13 fb ff ff       	call   80104c10 <argstr>
801050fd:	83 c4 10             	add    $0x10,%esp
80105100:	85 c0                	test   %eax,%eax
80105102:	0f 88 e2 00 00 00    	js     801051ea <sys_link+0x11a>
  begin_op();
80105108:	e8 63 de ff ff       	call   80102f70 <begin_op>
  if((ip = namei(old)) == 0){
8010510d:	83 ec 0c             	sub    $0xc,%esp
80105110:	ff 75 d4             	push   -0x2c(%ebp)
80105113:	e8 08 d0 ff ff       	call   80102120 <namei>
80105118:	83 c4 10             	add    $0x10,%esp
8010511b:	89 c3                	mov    %eax,%ebx
8010511d:	85 c0                	test   %eax,%eax
8010511f:	0f 84 df 00 00 00    	je     80105204 <sys_link+0x134>
  ilock(ip);
80105125:	83 ec 0c             	sub    $0xc,%esp
80105128:	50                   	push   %eax
80105129:	e8 c2 c6 ff ff       	call   801017f0 <ilock>
  if(ip->type == T_DIR){
8010512e:	83 c4 10             	add    $0x10,%esp
80105131:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105136:	0f 84 b5 00 00 00    	je     801051f1 <sys_link+0x121>
  iupdate(ip);
8010513c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010513f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105144:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105147:	53                   	push   %ebx
80105148:	e8 f3 c5 ff ff       	call   80101740 <iupdate>
  iunlock(ip);
8010514d:	89 1c 24             	mov    %ebx,(%esp)
80105150:	e8 7b c7 ff ff       	call   801018d0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105155:	58                   	pop    %eax
80105156:	5a                   	pop    %edx
80105157:	57                   	push   %edi
80105158:	ff 75 d0             	push   -0x30(%ebp)
8010515b:	e8 e0 cf ff ff       	call   80102140 <nameiparent>
80105160:	83 c4 10             	add    $0x10,%esp
80105163:	89 c6                	mov    %eax,%esi
80105165:	85 c0                	test   %eax,%eax
80105167:	74 5b                	je     801051c4 <sys_link+0xf4>
  ilock(dp);
80105169:	83 ec 0c             	sub    $0xc,%esp
8010516c:	50                   	push   %eax
8010516d:	e8 7e c6 ff ff       	call   801017f0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105172:	8b 03                	mov    (%ebx),%eax
80105174:	83 c4 10             	add    $0x10,%esp
80105177:	39 06                	cmp    %eax,(%esi)
80105179:	75 3d                	jne    801051b8 <sys_link+0xe8>
8010517b:	83 ec 04             	sub    $0x4,%esp
8010517e:	ff 73 04             	push   0x4(%ebx)
80105181:	57                   	push   %edi
80105182:	56                   	push   %esi
80105183:	e8 d8 ce ff ff       	call   80102060 <dirlink>
80105188:	83 c4 10             	add    $0x10,%esp
8010518b:	85 c0                	test   %eax,%eax
8010518d:	78 29                	js     801051b8 <sys_link+0xe8>
  iunlockput(dp);
8010518f:	83 ec 0c             	sub    $0xc,%esp
80105192:	56                   	push   %esi
80105193:	e8 e8 c8 ff ff       	call   80101a80 <iunlockput>
  iput(ip);
80105198:	89 1c 24             	mov    %ebx,(%esp)
8010519b:	e8 80 c7 ff ff       	call   80101920 <iput>
  end_op();
801051a0:	e8 3b de ff ff       	call   80102fe0 <end_op>
  return 0;
801051a5:	83 c4 10             	add    $0x10,%esp
801051a8:	31 c0                	xor    %eax,%eax
}
801051aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051ad:	5b                   	pop    %ebx
801051ae:	5e                   	pop    %esi
801051af:	5f                   	pop    %edi
801051b0:	5d                   	pop    %ebp
801051b1:	c3                   	ret
801051b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801051b8:	83 ec 0c             	sub    $0xc,%esp
801051bb:	56                   	push   %esi
801051bc:	e8 bf c8 ff ff       	call   80101a80 <iunlockput>
    goto bad;
801051c1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801051c4:	83 ec 0c             	sub    $0xc,%esp
801051c7:	53                   	push   %ebx
801051c8:	e8 23 c6 ff ff       	call   801017f0 <ilock>
  ip->nlink--;
801051cd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801051d2:	89 1c 24             	mov    %ebx,(%esp)
801051d5:	e8 66 c5 ff ff       	call   80101740 <iupdate>
  iunlockput(ip);
801051da:	89 1c 24             	mov    %ebx,(%esp)
801051dd:	e8 9e c8 ff ff       	call   80101a80 <iunlockput>
  end_op();
801051e2:	e8 f9 dd ff ff       	call   80102fe0 <end_op>
  return -1;
801051e7:	83 c4 10             	add    $0x10,%esp
    return -1;
801051ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051ef:	eb b9                	jmp    801051aa <sys_link+0xda>
    iunlockput(ip);
801051f1:	83 ec 0c             	sub    $0xc,%esp
801051f4:	53                   	push   %ebx
801051f5:	e8 86 c8 ff ff       	call   80101a80 <iunlockput>
    end_op();
801051fa:	e8 e1 dd ff ff       	call   80102fe0 <end_op>
    return -1;
801051ff:	83 c4 10             	add    $0x10,%esp
80105202:	eb e6                	jmp    801051ea <sys_link+0x11a>
    end_op();
80105204:	e8 d7 dd ff ff       	call   80102fe0 <end_op>
    return -1;
80105209:	eb df                	jmp    801051ea <sys_link+0x11a>
8010520b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010520f:	90                   	nop

80105210 <sys_unlink>:
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	57                   	push   %edi
80105214:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105215:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105218:	53                   	push   %ebx
80105219:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010521c:	50                   	push   %eax
8010521d:	6a 00                	push   $0x0
8010521f:	e8 ec f9 ff ff       	call   80104c10 <argstr>
80105224:	83 c4 10             	add    $0x10,%esp
80105227:	85 c0                	test   %eax,%eax
80105229:	0f 88 54 01 00 00    	js     80105383 <sys_unlink+0x173>
  begin_op();
8010522f:	e8 3c dd ff ff       	call   80102f70 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105234:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105237:	83 ec 08             	sub    $0x8,%esp
8010523a:	53                   	push   %ebx
8010523b:	ff 75 c0             	push   -0x40(%ebp)
8010523e:	e8 fd ce ff ff       	call   80102140 <nameiparent>
80105243:	83 c4 10             	add    $0x10,%esp
80105246:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105249:	85 c0                	test   %eax,%eax
8010524b:	0f 84 58 01 00 00    	je     801053a9 <sys_unlink+0x199>
  ilock(dp);
80105251:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105254:	83 ec 0c             	sub    $0xc,%esp
80105257:	57                   	push   %edi
80105258:	e8 93 c5 ff ff       	call   801017f0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010525d:	58                   	pop    %eax
8010525e:	5a                   	pop    %edx
8010525f:	68 44 7e 10 80       	push   $0x80107e44
80105264:	53                   	push   %ebx
80105265:	e8 c6 ca ff ff       	call   80101d30 <namecmp>
8010526a:	83 c4 10             	add    $0x10,%esp
8010526d:	85 c0                	test   %eax,%eax
8010526f:	0f 84 fb 00 00 00    	je     80105370 <sys_unlink+0x160>
80105275:	83 ec 08             	sub    $0x8,%esp
80105278:	68 43 7e 10 80       	push   $0x80107e43
8010527d:	53                   	push   %ebx
8010527e:	e8 ad ca ff ff       	call   80101d30 <namecmp>
80105283:	83 c4 10             	add    $0x10,%esp
80105286:	85 c0                	test   %eax,%eax
80105288:	0f 84 e2 00 00 00    	je     80105370 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010528e:	83 ec 04             	sub    $0x4,%esp
80105291:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105294:	50                   	push   %eax
80105295:	53                   	push   %ebx
80105296:	57                   	push   %edi
80105297:	e8 b4 ca ff ff       	call   80101d50 <dirlookup>
8010529c:	83 c4 10             	add    $0x10,%esp
8010529f:	89 c3                	mov    %eax,%ebx
801052a1:	85 c0                	test   %eax,%eax
801052a3:	0f 84 c7 00 00 00    	je     80105370 <sys_unlink+0x160>
  ilock(ip);
801052a9:	83 ec 0c             	sub    $0xc,%esp
801052ac:	50                   	push   %eax
801052ad:	e8 3e c5 ff ff       	call   801017f0 <ilock>
  if(ip->nlink < 1)
801052b2:	83 c4 10             	add    $0x10,%esp
801052b5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801052ba:	0f 8e 0a 01 00 00    	jle    801053ca <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
801052c0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052c5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801052c8:	74 66                	je     80105330 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801052ca:	83 ec 04             	sub    $0x4,%esp
801052cd:	6a 10                	push   $0x10
801052cf:	6a 00                	push   $0x0
801052d1:	57                   	push   %edi
801052d2:	e8 c9 f5 ff ff       	call   801048a0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801052d7:	6a 10                	push   $0x10
801052d9:	ff 75 c4             	push   -0x3c(%ebp)
801052dc:	57                   	push   %edi
801052dd:	ff 75 b4             	push   -0x4c(%ebp)
801052e0:	e8 1b c9 ff ff       	call   80101c00 <writei>
801052e5:	83 c4 20             	add    $0x20,%esp
801052e8:	83 f8 10             	cmp    $0x10,%eax
801052eb:	0f 85 cc 00 00 00    	jne    801053bd <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
801052f1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052f6:	0f 84 94 00 00 00    	je     80105390 <sys_unlink+0x180>
  iunlockput(dp);
801052fc:	83 ec 0c             	sub    $0xc,%esp
801052ff:	ff 75 b4             	push   -0x4c(%ebp)
80105302:	e8 79 c7 ff ff       	call   80101a80 <iunlockput>
  ip->nlink--;
80105307:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010530c:	89 1c 24             	mov    %ebx,(%esp)
8010530f:	e8 2c c4 ff ff       	call   80101740 <iupdate>
  iunlockput(ip);
80105314:	89 1c 24             	mov    %ebx,(%esp)
80105317:	e8 64 c7 ff ff       	call   80101a80 <iunlockput>
  end_op();
8010531c:	e8 bf dc ff ff       	call   80102fe0 <end_op>
  return 0;
80105321:	83 c4 10             	add    $0x10,%esp
80105324:	31 c0                	xor    %eax,%eax
}
80105326:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105329:	5b                   	pop    %ebx
8010532a:	5e                   	pop    %esi
8010532b:	5f                   	pop    %edi
8010532c:	5d                   	pop    %ebp
8010532d:	c3                   	ret
8010532e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105330:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105334:	76 94                	jbe    801052ca <sys_unlink+0xba>
80105336:	be 20 00 00 00       	mov    $0x20,%esi
8010533b:	eb 0b                	jmp    80105348 <sys_unlink+0x138>
8010533d:	8d 76 00             	lea    0x0(%esi),%esi
80105340:	83 c6 10             	add    $0x10,%esi
80105343:	3b 73 58             	cmp    0x58(%ebx),%esi
80105346:	73 82                	jae    801052ca <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105348:	6a 10                	push   $0x10
8010534a:	56                   	push   %esi
8010534b:	57                   	push   %edi
8010534c:	53                   	push   %ebx
8010534d:	e8 ae c7 ff ff       	call   80101b00 <readi>
80105352:	83 c4 10             	add    $0x10,%esp
80105355:	83 f8 10             	cmp    $0x10,%eax
80105358:	75 56                	jne    801053b0 <sys_unlink+0x1a0>
    if(de.inum != 0)
8010535a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010535f:	74 df                	je     80105340 <sys_unlink+0x130>
    iunlockput(ip);
80105361:	83 ec 0c             	sub    $0xc,%esp
80105364:	53                   	push   %ebx
80105365:	e8 16 c7 ff ff       	call   80101a80 <iunlockput>
    goto bad;
8010536a:	83 c4 10             	add    $0x10,%esp
8010536d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105370:	83 ec 0c             	sub    $0xc,%esp
80105373:	ff 75 b4             	push   -0x4c(%ebp)
80105376:	e8 05 c7 ff ff       	call   80101a80 <iunlockput>
  end_op();
8010537b:	e8 60 dc ff ff       	call   80102fe0 <end_op>
  return -1;
80105380:	83 c4 10             	add    $0x10,%esp
    return -1;
80105383:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105388:	eb 9c                	jmp    80105326 <sys_unlink+0x116>
8010538a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105390:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105393:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105396:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010539b:	50                   	push   %eax
8010539c:	e8 9f c3 ff ff       	call   80101740 <iupdate>
801053a1:	83 c4 10             	add    $0x10,%esp
801053a4:	e9 53 ff ff ff       	jmp    801052fc <sys_unlink+0xec>
    end_op();
801053a9:	e8 32 dc ff ff       	call   80102fe0 <end_op>
    return -1;
801053ae:	eb d3                	jmp    80105383 <sys_unlink+0x173>
      panic("isdirempty: readi");
801053b0:	83 ec 0c             	sub    $0xc,%esp
801053b3:	68 68 7e 10 80       	push   $0x80107e68
801053b8:	e8 c3 af ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801053bd:	83 ec 0c             	sub    $0xc,%esp
801053c0:	68 7a 7e 10 80       	push   $0x80107e7a
801053c5:	e8 b6 af ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801053ca:	83 ec 0c             	sub    $0xc,%esp
801053cd:	68 56 7e 10 80       	push   $0x80107e56
801053d2:	e8 a9 af ff ff       	call   80100380 <panic>
801053d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053de:	66 90                	xchg   %ax,%ax

801053e0 <sys_open>:

int
sys_open(void)
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	57                   	push   %edi
801053e4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053e5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801053e8:	53                   	push   %ebx
801053e9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053ec:	50                   	push   %eax
801053ed:	6a 00                	push   $0x0
801053ef:	e8 1c f8 ff ff       	call   80104c10 <argstr>
801053f4:	83 c4 10             	add    $0x10,%esp
801053f7:	85 c0                	test   %eax,%eax
801053f9:	0f 88 8e 00 00 00    	js     8010548d <sys_open+0xad>
801053ff:	83 ec 08             	sub    $0x8,%esp
80105402:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105405:	50                   	push   %eax
80105406:	6a 01                	push   $0x1
80105408:	e8 43 f7 ff ff       	call   80104b50 <argint>
8010540d:	83 c4 10             	add    $0x10,%esp
80105410:	85 c0                	test   %eax,%eax
80105412:	78 79                	js     8010548d <sys_open+0xad>
    return -1;

  begin_op();
80105414:	e8 57 db ff ff       	call   80102f70 <begin_op>

  if(omode & O_CREATE){
80105419:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010541d:	75 79                	jne    80105498 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010541f:	83 ec 0c             	sub    $0xc,%esp
80105422:	ff 75 e0             	push   -0x20(%ebp)
80105425:	e8 f6 cc ff ff       	call   80102120 <namei>
8010542a:	83 c4 10             	add    $0x10,%esp
8010542d:	89 c6                	mov    %eax,%esi
8010542f:	85 c0                	test   %eax,%eax
80105431:	0f 84 7e 00 00 00    	je     801054b5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105437:	83 ec 0c             	sub    $0xc,%esp
8010543a:	50                   	push   %eax
8010543b:	e8 b0 c3 ff ff       	call   801017f0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105440:	83 c4 10             	add    $0x10,%esp
80105443:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105448:	0f 84 ba 00 00 00    	je     80105508 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010544e:	e8 2d ba ff ff       	call   80100e80 <filealloc>
80105453:	89 c7                	mov    %eax,%edi
80105455:	85 c0                	test   %eax,%eax
80105457:	74 23                	je     8010547c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105459:	e8 32 e7 ff ff       	call   80103b90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010545e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105460:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105464:	85 d2                	test   %edx,%edx
80105466:	74 58                	je     801054c0 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105468:	83 c3 01             	add    $0x1,%ebx
8010546b:	83 fb 10             	cmp    $0x10,%ebx
8010546e:	75 f0                	jne    80105460 <sys_open+0x80>
    if(f)
      fileclose(f);
80105470:	83 ec 0c             	sub    $0xc,%esp
80105473:	57                   	push   %edi
80105474:	e8 c7 ba ff ff       	call   80100f40 <fileclose>
80105479:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010547c:	83 ec 0c             	sub    $0xc,%esp
8010547f:	56                   	push   %esi
80105480:	e8 fb c5 ff ff       	call   80101a80 <iunlockput>
    end_op();
80105485:	e8 56 db ff ff       	call   80102fe0 <end_op>
    return -1;
8010548a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010548d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105492:	eb 65                	jmp    801054f9 <sys_open+0x119>
80105494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105498:	83 ec 0c             	sub    $0xc,%esp
8010549b:	31 c9                	xor    %ecx,%ecx
8010549d:	ba 02 00 00 00       	mov    $0x2,%edx
801054a2:	6a 00                	push   $0x0
801054a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801054a7:	e8 54 f8 ff ff       	call   80104d00 <create>
    if(ip == 0){
801054ac:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801054af:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801054b1:	85 c0                	test   %eax,%eax
801054b3:	75 99                	jne    8010544e <sys_open+0x6e>
      end_op();
801054b5:	e8 26 db ff ff       	call   80102fe0 <end_op>
      return -1;
801054ba:	eb d1                	jmp    8010548d <sys_open+0xad>
801054bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801054c0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801054c3:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801054c7:	56                   	push   %esi
801054c8:	e8 03 c4 ff ff       	call   801018d0 <iunlock>
  end_op();
801054cd:	e8 0e db ff ff       	call   80102fe0 <end_op>

  f->type = FD_INODE;
801054d2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801054d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054db:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801054de:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801054e1:	89 d0                	mov    %edx,%eax
  f->off = 0;
801054e3:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801054ea:	f7 d0                	not    %eax
801054ec:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054ef:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801054f2:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054f5:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801054f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054fc:	89 d8                	mov    %ebx,%eax
801054fe:	5b                   	pop    %ebx
801054ff:	5e                   	pop    %esi
80105500:	5f                   	pop    %edi
80105501:	5d                   	pop    %ebp
80105502:	c3                   	ret
80105503:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105507:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105508:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010550b:	85 c9                	test   %ecx,%ecx
8010550d:	0f 84 3b ff ff ff    	je     8010544e <sys_open+0x6e>
80105513:	e9 64 ff ff ff       	jmp    8010547c <sys_open+0x9c>
80105518:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010551f:	90                   	nop

80105520 <sys_mkdir>:

int
sys_mkdir(void)
{
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105526:	e8 45 da ff ff       	call   80102f70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010552b:	83 ec 08             	sub    $0x8,%esp
8010552e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105531:	50                   	push   %eax
80105532:	6a 00                	push   $0x0
80105534:	e8 d7 f6 ff ff       	call   80104c10 <argstr>
80105539:	83 c4 10             	add    $0x10,%esp
8010553c:	85 c0                	test   %eax,%eax
8010553e:	78 30                	js     80105570 <sys_mkdir+0x50>
80105540:	83 ec 0c             	sub    $0xc,%esp
80105543:	31 c9                	xor    %ecx,%ecx
80105545:	ba 01 00 00 00       	mov    $0x1,%edx
8010554a:	6a 00                	push   $0x0
8010554c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010554f:	e8 ac f7 ff ff       	call   80104d00 <create>
80105554:	83 c4 10             	add    $0x10,%esp
80105557:	85 c0                	test   %eax,%eax
80105559:	74 15                	je     80105570 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010555b:	83 ec 0c             	sub    $0xc,%esp
8010555e:	50                   	push   %eax
8010555f:	e8 1c c5 ff ff       	call   80101a80 <iunlockput>
  end_op();
80105564:	e8 77 da ff ff       	call   80102fe0 <end_op>
  return 0;
80105569:	83 c4 10             	add    $0x10,%esp
8010556c:	31 c0                	xor    %eax,%eax
}
8010556e:	c9                   	leave
8010556f:	c3                   	ret
    end_op();
80105570:	e8 6b da ff ff       	call   80102fe0 <end_op>
    return -1;
80105575:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010557a:	c9                   	leave
8010557b:	c3                   	ret
8010557c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105580 <sys_mknod>:

int
sys_mknod(void)
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105586:	e8 e5 d9 ff ff       	call   80102f70 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010558b:	83 ec 08             	sub    $0x8,%esp
8010558e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105591:	50                   	push   %eax
80105592:	6a 00                	push   $0x0
80105594:	e8 77 f6 ff ff       	call   80104c10 <argstr>
80105599:	83 c4 10             	add    $0x10,%esp
8010559c:	85 c0                	test   %eax,%eax
8010559e:	78 60                	js     80105600 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801055a0:	83 ec 08             	sub    $0x8,%esp
801055a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055a6:	50                   	push   %eax
801055a7:	6a 01                	push   $0x1
801055a9:	e8 a2 f5 ff ff       	call   80104b50 <argint>
  if((argstr(0, &path)) < 0 ||
801055ae:	83 c4 10             	add    $0x10,%esp
801055b1:	85 c0                	test   %eax,%eax
801055b3:	78 4b                	js     80105600 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801055b5:	83 ec 08             	sub    $0x8,%esp
801055b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055bb:	50                   	push   %eax
801055bc:	6a 02                	push   $0x2
801055be:	e8 8d f5 ff ff       	call   80104b50 <argint>
     argint(1, &major) < 0 ||
801055c3:	83 c4 10             	add    $0x10,%esp
801055c6:	85 c0                	test   %eax,%eax
801055c8:	78 36                	js     80105600 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801055ca:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801055ce:	83 ec 0c             	sub    $0xc,%esp
801055d1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801055d5:	ba 03 00 00 00       	mov    $0x3,%edx
801055da:	50                   	push   %eax
801055db:	8b 45 ec             	mov    -0x14(%ebp),%eax
801055de:	e8 1d f7 ff ff       	call   80104d00 <create>
     argint(2, &minor) < 0 ||
801055e3:	83 c4 10             	add    $0x10,%esp
801055e6:	85 c0                	test   %eax,%eax
801055e8:	74 16                	je     80105600 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801055ea:	83 ec 0c             	sub    $0xc,%esp
801055ed:	50                   	push   %eax
801055ee:	e8 8d c4 ff ff       	call   80101a80 <iunlockput>
  end_op();
801055f3:	e8 e8 d9 ff ff       	call   80102fe0 <end_op>
  return 0;
801055f8:	83 c4 10             	add    $0x10,%esp
801055fb:	31 c0                	xor    %eax,%eax
}
801055fd:	c9                   	leave
801055fe:	c3                   	ret
801055ff:	90                   	nop
    end_op();
80105600:	e8 db d9 ff ff       	call   80102fe0 <end_op>
    return -1;
80105605:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010560a:	c9                   	leave
8010560b:	c3                   	ret
8010560c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105610 <sys_chdir>:

int
sys_chdir(void)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	56                   	push   %esi
80105614:	53                   	push   %ebx
80105615:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105618:	e8 73 e5 ff ff       	call   80103b90 <myproc>
8010561d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010561f:	e8 4c d9 ff ff       	call   80102f70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105624:	83 ec 08             	sub    $0x8,%esp
80105627:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010562a:	50                   	push   %eax
8010562b:	6a 00                	push   $0x0
8010562d:	e8 de f5 ff ff       	call   80104c10 <argstr>
80105632:	83 c4 10             	add    $0x10,%esp
80105635:	85 c0                	test   %eax,%eax
80105637:	78 77                	js     801056b0 <sys_chdir+0xa0>
80105639:	83 ec 0c             	sub    $0xc,%esp
8010563c:	ff 75 f4             	push   -0xc(%ebp)
8010563f:	e8 dc ca ff ff       	call   80102120 <namei>
80105644:	83 c4 10             	add    $0x10,%esp
80105647:	89 c3                	mov    %eax,%ebx
80105649:	85 c0                	test   %eax,%eax
8010564b:	74 63                	je     801056b0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010564d:	83 ec 0c             	sub    $0xc,%esp
80105650:	50                   	push   %eax
80105651:	e8 9a c1 ff ff       	call   801017f0 <ilock>
  if(ip->type != T_DIR){
80105656:	83 c4 10             	add    $0x10,%esp
80105659:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010565e:	75 30                	jne    80105690 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105660:	83 ec 0c             	sub    $0xc,%esp
80105663:	53                   	push   %ebx
80105664:	e8 67 c2 ff ff       	call   801018d0 <iunlock>
  iput(curproc->cwd);
80105669:	58                   	pop    %eax
8010566a:	ff 76 68             	push   0x68(%esi)
8010566d:	e8 ae c2 ff ff       	call   80101920 <iput>
  end_op();
80105672:	e8 69 d9 ff ff       	call   80102fe0 <end_op>
  curproc->cwd = ip;
80105677:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010567a:	83 c4 10             	add    $0x10,%esp
8010567d:	31 c0                	xor    %eax,%eax
}
8010567f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105682:	5b                   	pop    %ebx
80105683:	5e                   	pop    %esi
80105684:	5d                   	pop    %ebp
80105685:	c3                   	ret
80105686:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010568d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105690:	83 ec 0c             	sub    $0xc,%esp
80105693:	53                   	push   %ebx
80105694:	e8 e7 c3 ff ff       	call   80101a80 <iunlockput>
    end_op();
80105699:	e8 42 d9 ff ff       	call   80102fe0 <end_op>
    return -1;
8010569e:	83 c4 10             	add    $0x10,%esp
    return -1;
801056a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056a6:	eb d7                	jmp    8010567f <sys_chdir+0x6f>
801056a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056af:	90                   	nop
    end_op();
801056b0:	e8 2b d9 ff ff       	call   80102fe0 <end_op>
    return -1;
801056b5:	eb ea                	jmp    801056a1 <sys_chdir+0x91>
801056b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056be:	66 90                	xchg   %ax,%ax

801056c0 <sys_exec>:

int
sys_exec(void)
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	57                   	push   %edi
801056c4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801056c5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801056cb:	53                   	push   %ebx
801056cc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801056d2:	50                   	push   %eax
801056d3:	6a 00                	push   $0x0
801056d5:	e8 36 f5 ff ff       	call   80104c10 <argstr>
801056da:	83 c4 10             	add    $0x10,%esp
801056dd:	85 c0                	test   %eax,%eax
801056df:	0f 88 87 00 00 00    	js     8010576c <sys_exec+0xac>
801056e5:	83 ec 08             	sub    $0x8,%esp
801056e8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801056ee:	50                   	push   %eax
801056ef:	6a 01                	push   $0x1
801056f1:	e8 5a f4 ff ff       	call   80104b50 <argint>
801056f6:	83 c4 10             	add    $0x10,%esp
801056f9:	85 c0                	test   %eax,%eax
801056fb:	78 6f                	js     8010576c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801056fd:	83 ec 04             	sub    $0x4,%esp
80105700:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105706:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105708:	68 80 00 00 00       	push   $0x80
8010570d:	6a 00                	push   $0x0
8010570f:	56                   	push   %esi
80105710:	e8 8b f1 ff ff       	call   801048a0 <memset>
80105715:	83 c4 10             	add    $0x10,%esp
80105718:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010571f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105720:	83 ec 08             	sub    $0x8,%esp
80105723:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105729:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105730:	50                   	push   %eax
80105731:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105737:	01 f8                	add    %edi,%eax
80105739:	50                   	push   %eax
8010573a:	e8 81 f3 ff ff       	call   80104ac0 <fetchint>
8010573f:	83 c4 10             	add    $0x10,%esp
80105742:	85 c0                	test   %eax,%eax
80105744:	78 26                	js     8010576c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105746:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010574c:	85 c0                	test   %eax,%eax
8010574e:	74 30                	je     80105780 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105750:	83 ec 08             	sub    $0x8,%esp
80105753:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105756:	52                   	push   %edx
80105757:	50                   	push   %eax
80105758:	e8 a3 f3 ff ff       	call   80104b00 <fetchstr>
8010575d:	83 c4 10             	add    $0x10,%esp
80105760:	85 c0                	test   %eax,%eax
80105762:	78 08                	js     8010576c <sys_exec+0xac>
  for(i=0;; i++){
80105764:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105767:	83 fb 20             	cmp    $0x20,%ebx
8010576a:	75 b4                	jne    80105720 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010576c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010576f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105774:	5b                   	pop    %ebx
80105775:	5e                   	pop    %esi
80105776:	5f                   	pop    %edi
80105777:	5d                   	pop    %ebp
80105778:	c3                   	ret
80105779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105780:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105787:	00 00 00 00 
  return exec(path, argv);
8010578b:	83 ec 08             	sub    $0x8,%esp
8010578e:	56                   	push   %esi
8010578f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105795:	e8 46 b3 ff ff       	call   80100ae0 <exec>
8010579a:	83 c4 10             	add    $0x10,%esp
}
8010579d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057a0:	5b                   	pop    %ebx
801057a1:	5e                   	pop    %esi
801057a2:	5f                   	pop    %edi
801057a3:	5d                   	pop    %ebp
801057a4:	c3                   	ret
801057a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057b0 <sys_pipe>:

int
sys_pipe(void)
{
801057b0:	55                   	push   %ebp
801057b1:	89 e5                	mov    %esp,%ebp
801057b3:	57                   	push   %edi
801057b4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801057b5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801057b8:	53                   	push   %ebx
801057b9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801057bc:	6a 08                	push   $0x8
801057be:	50                   	push   %eax
801057bf:	6a 00                	push   $0x0
801057c1:	e8 da f3 ff ff       	call   80104ba0 <argptr>
801057c6:	83 c4 10             	add    $0x10,%esp
801057c9:	85 c0                	test   %eax,%eax
801057cb:	0f 88 8b 00 00 00    	js     8010585c <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801057d1:	83 ec 08             	sub    $0x8,%esp
801057d4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801057d7:	50                   	push   %eax
801057d8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801057db:	50                   	push   %eax
801057dc:	e8 5f de ff ff       	call   80103640 <pipealloc>
801057e1:	83 c4 10             	add    $0x10,%esp
801057e4:	85 c0                	test   %eax,%eax
801057e6:	78 74                	js     8010585c <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801057e8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801057eb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801057ed:	e8 9e e3 ff ff       	call   80103b90 <myproc>
    if(curproc->ofile[fd] == 0){
801057f2:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801057f6:	85 f6                	test   %esi,%esi
801057f8:	74 16                	je     80105810 <sys_pipe+0x60>
801057fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105800:	83 c3 01             	add    $0x1,%ebx
80105803:	83 fb 10             	cmp    $0x10,%ebx
80105806:	74 3d                	je     80105845 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
80105808:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010580c:	85 f6                	test   %esi,%esi
8010580e:	75 f0                	jne    80105800 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105810:	8d 73 08             	lea    0x8(%ebx),%esi
80105813:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105817:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010581a:	e8 71 e3 ff ff       	call   80103b90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010581f:	31 d2                	xor    %edx,%edx
80105821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105828:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010582c:	85 c9                	test   %ecx,%ecx
8010582e:	74 38                	je     80105868 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
80105830:	83 c2 01             	add    $0x1,%edx
80105833:	83 fa 10             	cmp    $0x10,%edx
80105836:	75 f0                	jne    80105828 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105838:	e8 53 e3 ff ff       	call   80103b90 <myproc>
8010583d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105844:	00 
    fileclose(rf);
80105845:	83 ec 0c             	sub    $0xc,%esp
80105848:	ff 75 e0             	push   -0x20(%ebp)
8010584b:	e8 f0 b6 ff ff       	call   80100f40 <fileclose>
    fileclose(wf);
80105850:	58                   	pop    %eax
80105851:	ff 75 e4             	push   -0x1c(%ebp)
80105854:	e8 e7 b6 ff ff       	call   80100f40 <fileclose>
    return -1;
80105859:	83 c4 10             	add    $0x10,%esp
    return -1;
8010585c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105861:	eb 16                	jmp    80105879 <sys_pipe+0xc9>
80105863:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105867:	90                   	nop
      curproc->ofile[fd] = f;
80105868:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
8010586c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010586f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105871:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105874:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105877:	31 c0                	xor    %eax,%eax
}
80105879:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010587c:	5b                   	pop    %ebx
8010587d:	5e                   	pop    %esi
8010587e:	5f                   	pop    %edi
8010587f:	5d                   	pop    %ebp
80105880:	c3                   	ret
80105881:	66 90                	xchg   %ax,%ax
80105883:	66 90                	xchg   %ax,%ax
80105885:	66 90                	xchg   %ax,%ax
80105887:	66 90                	xchg   %ax,%ax
80105889:	66 90                	xchg   %ax,%ax
8010588b:	66 90                	xchg   %ax,%ax
8010588d:	66 90                	xchg   %ax,%ax
8010588f:	90                   	nop

80105890 <sys_fork>:
extern int free_frame_cnt; // xv6 proj - cow

int
sys_fork(void)
{
  return fork();
80105890:	e9 bb e4 ff ff       	jmp    80103d50 <fork>
80105895:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010589c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058a0 <sys_exit>:
}

int
sys_exit(void)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	83 ec 08             	sub    $0x8,%esp
  exit();
801058a6:	e8 25 e7 ff ff       	call   80103fd0 <exit>
  return 0;  // not reached
}
801058ab:	31 c0                	xor    %eax,%eax
801058ad:	c9                   	leave
801058ae:	c3                   	ret
801058af:	90                   	nop

801058b0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801058b0:	e9 4b e8 ff ff       	jmp    80104100 <wait>
801058b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058c0 <sys_kill>:
}

int
sys_kill(void)
{
801058c0:	55                   	push   %ebp
801058c1:	89 e5                	mov    %esp,%ebp
801058c3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801058c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058c9:	50                   	push   %eax
801058ca:	6a 00                	push   $0x0
801058cc:	e8 7f f2 ff ff       	call   80104b50 <argint>
801058d1:	83 c4 10             	add    $0x10,%esp
801058d4:	85 c0                	test   %eax,%eax
801058d6:	78 18                	js     801058f0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801058d8:	83 ec 0c             	sub    $0xc,%esp
801058db:	ff 75 f4             	push   -0xc(%ebp)
801058de:	e8 bd ea ff ff       	call   801043a0 <kill>
801058e3:	83 c4 10             	add    $0x10,%esp
}
801058e6:	c9                   	leave
801058e7:	c3                   	ret
801058e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ef:	90                   	nop
801058f0:	c9                   	leave
    return -1;
801058f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058f6:	c3                   	ret
801058f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058fe:	66 90                	xchg   %ax,%ax

80105900 <sys_getpid>:

int
sys_getpid(void)
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105906:	e8 85 e2 ff ff       	call   80103b90 <myproc>
8010590b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010590e:	c9                   	leave
8010590f:	c3                   	ret

80105910 <sys_sbrk>:

int
sys_sbrk(void)
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105914:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105917:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010591a:	50                   	push   %eax
8010591b:	6a 00                	push   $0x0
8010591d:	e8 2e f2 ff ff       	call   80104b50 <argint>
80105922:	83 c4 10             	add    $0x10,%esp
80105925:	85 c0                	test   %eax,%eax
80105927:	78 27                	js     80105950 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105929:	e8 62 e2 ff ff       	call   80103b90 <myproc>
  if(growproc(n) < 0)
8010592e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105931:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105933:	ff 75 f4             	push   -0xc(%ebp)
80105936:	e8 75 e3 ff ff       	call   80103cb0 <growproc>
8010593b:	83 c4 10             	add    $0x10,%esp
8010593e:	85 c0                	test   %eax,%eax
80105940:	78 0e                	js     80105950 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105942:	89 d8                	mov    %ebx,%eax
80105944:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105947:	c9                   	leave
80105948:	c3                   	ret
80105949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105950:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105955:	eb eb                	jmp    80105942 <sys_sbrk+0x32>
80105957:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010595e:	66 90                	xchg   %ax,%ax

80105960 <sys_sleep>:

int
sys_sleep(void)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105964:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105967:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010596a:	50                   	push   %eax
8010596b:	6a 00                	push   $0x0
8010596d:	e8 de f1 ff ff       	call   80104b50 <argint>
80105972:	83 c4 10             	add    $0x10,%esp
80105975:	85 c0                	test   %eax,%eax
80105977:	78 64                	js     801059dd <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80105979:	83 ec 0c             	sub    $0xc,%esp
8010597c:	68 a0 4c 18 80       	push   $0x80184ca0
80105981:	e8 8a ed ff ff       	call   80104710 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105986:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105989:	8b 1d 80 4c 18 80    	mov    0x80184c80,%ebx
  while(ticks - ticks0 < n){
8010598f:	83 c4 10             	add    $0x10,%esp
80105992:	85 d2                	test   %edx,%edx
80105994:	75 2b                	jne    801059c1 <sys_sleep+0x61>
80105996:	eb 58                	jmp    801059f0 <sys_sleep+0x90>
80105998:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010599f:	90                   	nop
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801059a0:	83 ec 08             	sub    $0x8,%esp
801059a3:	68 a0 4c 18 80       	push   $0x80184ca0
801059a8:	68 80 4c 18 80       	push   $0x80184c80
801059ad:	e8 ce e8 ff ff       	call   80104280 <sleep>
  while(ticks - ticks0 < n){
801059b2:	a1 80 4c 18 80       	mov    0x80184c80,%eax
801059b7:	83 c4 10             	add    $0x10,%esp
801059ba:	29 d8                	sub    %ebx,%eax
801059bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801059bf:	73 2f                	jae    801059f0 <sys_sleep+0x90>
    if(myproc()->killed){
801059c1:	e8 ca e1 ff ff       	call   80103b90 <myproc>
801059c6:	8b 40 24             	mov    0x24(%eax),%eax
801059c9:	85 c0                	test   %eax,%eax
801059cb:	74 d3                	je     801059a0 <sys_sleep+0x40>
      release(&tickslock);
801059cd:	83 ec 0c             	sub    $0xc,%esp
801059d0:	68 a0 4c 18 80       	push   $0x80184ca0
801059d5:	e8 76 ee ff ff       	call   80104850 <release>
      return -1;
801059da:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
801059dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
801059e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059e5:	c9                   	leave
801059e6:	c3                   	ret
801059e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ee:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801059f0:	83 ec 0c             	sub    $0xc,%esp
801059f3:	68 a0 4c 18 80       	push   $0x80184ca0
801059f8:	e8 53 ee ff ff       	call   80104850 <release>
}
801059fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80105a00:	83 c4 10             	add    $0x10,%esp
80105a03:	31 c0                	xor    %eax,%eax
}
80105a05:	c9                   	leave
80105a06:	c3                   	ret
80105a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a0e:	66 90                	xchg   %ax,%ax

80105a10 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	53                   	push   %ebx
80105a14:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105a17:	68 a0 4c 18 80       	push   $0x80184ca0
80105a1c:	e8 ef ec ff ff       	call   80104710 <acquire>
  xticks = ticks;
80105a21:	8b 1d 80 4c 18 80    	mov    0x80184c80,%ebx
  release(&tickslock);
80105a27:	c7 04 24 a0 4c 18 80 	movl   $0x80184ca0,(%esp)
80105a2e:	e8 1d ee ff ff       	call   80104850 <release>
  return xticks;
}
80105a33:	89 d8                	mov    %ebx,%eax
80105a35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a38:	c9                   	leave
80105a39:	c3                   	ret
80105a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105a40 <sys_shutdown>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105a40:	b8 00 20 00 00       	mov    $0x2000,%eax
80105a45:	ba 04 b0 ff ff       	mov    $0xffffb004,%edx
80105a4a:	66 ef                	out    %ax,(%dx)
80105a4c:	ba 04 06 00 00       	mov    $0x604,%edx
80105a51:	66 ef                	out    %ax,(%dx)
  outw(0xB004, 0x0|0x2000); // working for old qemu
  outw(0x604, 0x0|0x2000); // working for newer qemu
  
  return 0;
  
}
80105a53:	31 c0                	xor    %eax,%eax
80105a55:	c3                   	ret
80105a56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a5d:	8d 76 00             	lea    0x0(%esi),%esi

80105a60 <sys_get_free_frame_cnt>:

int sys_get_free_frame_cnt(void)
{
    return free_frame_cnt;
}
80105a60:	a1 44 26 11 80       	mov    0x80112644,%eax
80105a65:	c3                   	ret
80105a66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a6d:	8d 76 00             	lea    0x0(%esi),%esi

80105a70 <sys_enable_cow>:

extern int cow_enabled;
int sys_enable_cow(void){
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	83 ec 10             	sub    $0x10,%esp

    if (argint(0, &cow_enabled) < 0){// set cow_enabled arg. If failure return -1 error
80105a76:	68 9c 26 18 80       	push   $0x8018269c
80105a7b:	6a 00                	push   $0x0
80105a7d:	e8 ce f0 ff ff       	call   80104b50 <argint>
80105a82:	83 c4 10             	add    $0x10,%esp
80105a85:	85 c0                	test   %eax,%eax
80105a87:	78 04                	js     80105a8d <sys_enable_cow+0x1d>
        cprintf("sys_enable_cow() failed!\n");
        return -1;
    }

    return 0;
}
80105a89:	c9                   	leave
    return 0;
80105a8a:	31 c0                	xor    %eax,%eax
}
80105a8c:	c3                   	ret
        cprintf("sys_enable_cow() failed!\n");
80105a8d:	83 ec 0c             	sub    $0xc,%esp
80105a90:	68 89 7e 10 80       	push   $0x80107e89
80105a95:	e8 16 ac ff ff       	call   801006b0 <cprintf>
        return -1;
80105a9a:	83 c4 10             	add    $0x10,%esp
80105a9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aa2:	c9                   	leave
80105aa3:	c3                   	ret
80105aa4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105aaf:	90                   	nop

80105ab0 <sys_get_cow_status>:

int sys_get_cow_status(void){
    return cow_enabled;
}
80105ab0:	a1 9c 26 18 80       	mov    0x8018269c,%eax
80105ab5:	c3                   	ret

80105ab6 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105ab6:	1e                   	push   %ds
  pushl %es
80105ab7:	06                   	push   %es
  pushl %fs
80105ab8:	0f a0                	push   %fs
  pushl %gs
80105aba:	0f a8                	push   %gs
  pushal
80105abc:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105abd:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105ac1:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105ac3:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105ac5:	54                   	push   %esp
  call trap
80105ac6:	e8 c5 00 00 00       	call   80105b90 <trap>
  addl $4, %esp
80105acb:	83 c4 04             	add    $0x4,%esp

80105ace <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105ace:	61                   	popa
  popl %gs
80105acf:	0f a9                	pop    %gs
  popl %fs
80105ad1:	0f a1                	pop    %fs
  popl %es
80105ad3:	07                   	pop    %es
  popl %ds
80105ad4:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105ad5:	83 c4 08             	add    $0x8,%esp
  iret
80105ad8:	cf                   	iret

80105ad9 <flush_tlb_all>:

# xv6 proj - cow
.globl flush_tlb_all
flush_tlb_all:
  movl %cr3,%eax
80105ad9:	0f 20 d8             	mov    %cr3,%eax
  movl %eax, %cr3
80105adc:	0f 22 d8             	mov    %eax,%cr3
80105adf:	c3                   	ret

80105ae0 <tvinit>:
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void
tvinit(void) {
80105ae0:	55                   	push   %ebp
    int i;

    for (i = 0; i < 256; i++) SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80105ae1:	31 c0                	xor    %eax,%eax
tvinit(void) {
80105ae3:	89 e5                	mov    %esp,%ebp
80105ae5:	83 ec 08             	sub    $0x8,%esp
80105ae8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aef:	90                   	nop
    for (i = 0; i < 256; i++) SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80105af0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105af7:	c7 04 c5 e2 4c 18 80 	movl   $0x8e000008,-0x7fe7b31e(,%eax,8)
80105afe:	08 00 00 8e 
80105b02:	66 89 14 c5 e0 4c 18 	mov    %dx,-0x7fe7b320(,%eax,8)
80105b09:	80 
80105b0a:	c1 ea 10             	shr    $0x10,%edx
80105b0d:	66 89 14 c5 e6 4c 18 	mov    %dx,-0x7fe7b31a(,%eax,8)
80105b14:	80 
80105b15:	83 c0 01             	add    $0x1,%eax
80105b18:	3d 00 01 00 00       	cmp    $0x100,%eax
80105b1d:	75 d1                	jne    80105af0 <tvinit+0x10>
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80105b1f:	a1 08 b1 10 80       	mov    0x8010b108,%eax

    initlock(&tickslock, "time");
80105b24:	83 ec 08             	sub    $0x8,%esp
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80105b27:	c7 05 e2 4e 18 80 08 	movl   $0xef000008,0x80184ee2
80105b2e:	00 00 ef 
80105b31:	66 a3 e0 4e 18 80    	mov    %ax,0x80184ee0
80105b37:	c1 e8 10             	shr    $0x10,%eax
80105b3a:	66 a3 e6 4e 18 80    	mov    %ax,0x80184ee6
    initlock(&tickslock, "time");
80105b40:	68 a3 7e 10 80       	push   $0x80107ea3
80105b45:	68 a0 4c 18 80       	push   $0x80184ca0
80105b4a:	e8 a1 ea ff ff       	call   801045f0 <initlock>
}
80105b4f:	83 c4 10             	add    $0x10,%esp
80105b52:	c9                   	leave
80105b53:	c3                   	ret
80105b54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b5f:	90                   	nop

80105b60 <idtinit>:

void
idtinit(void) {
80105b60:	55                   	push   %ebp
  pd[0] = size-1;
80105b61:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105b66:	89 e5                	mov    %esp,%ebp
80105b68:	83 ec 10             	sub    $0x10,%esp
80105b6b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105b6f:	b8 e0 4c 18 80       	mov    $0x80184ce0,%eax
80105b74:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105b78:	c1 e8 10             	shr    $0x10,%eax
80105b7b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105b7f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105b82:	0f 01 18             	lidtl  (%eax)
    lidt(idt, sizeof(idt));
}
80105b85:	c9                   	leave
80105b86:	c3                   	ret
80105b87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b8e:	66 90                	xchg   %ax,%ax

80105b90 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe* tf) {
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
80105b93:	57                   	push   %edi
80105b94:	56                   	push   %esi
80105b95:	53                   	push   %ebx
80105b96:	83 ec 1c             	sub    $0x1c,%esp
80105b99:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (tf->trapno == T_SYSCALL) {
80105b9c:	8b 43 30             	mov    0x30(%ebx),%eax
80105b9f:	83 f8 40             	cmp    $0x40,%eax
80105ba2:	0f 84 38 01 00 00    	je     80105ce0 <trap+0x150>
        if (myproc()->killed)
            exit();
        return;
    }

    if (tf->trapno == T_PGFLT) {
80105ba8:	83 f8 0e             	cmp    $0xe,%eax
80105bab:	0f 84 ef 01 00 00    	je     80105da0 <trap+0x210>
        if(myproc()->killed)
            exit();
        return;
    }

    switch (tf->trapno) {
80105bb1:	83 e8 20             	sub    $0x20,%eax
80105bb4:	83 f8 1f             	cmp    $0x1f,%eax
80105bb7:	0f 87 83 00 00 00    	ja     80105c40 <trap+0xb0>
80105bbd:	ff 24 85 4c 7f 10 80 	jmp    *-0x7fef80b4(,%eax,4)
80105bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                release(&tickslock);
            }
            lapiceoi();
            break;
        case T_IRQ0 + IRQ_IDE:
            ideintr();
80105bc8:	e8 03 c7 ff ff       	call   801022d0 <ideintr>
            lapiceoi();
80105bcd:	e8 4e cf ff ff       	call   80102b20 <lapiceoi>
    }

    // Force process exit if it has been killed and is in user space.
    // (If it is still executing in the kernel, let it keep running
    // until it gets to the regular system call return.)
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80105bd2:	e8 b9 df ff ff       	call   80103b90 <myproc>
80105bd7:	85 c0                	test   %eax,%eax
80105bd9:	74 1d                	je     80105bf8 <trap+0x68>
80105bdb:	e8 b0 df ff ff       	call   80103b90 <myproc>
80105be0:	8b 50 24             	mov    0x24(%eax),%edx
80105be3:	85 d2                	test   %edx,%edx
80105be5:	74 11                	je     80105bf8 <trap+0x68>
80105be7:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105beb:	83 e0 03             	and    $0x3,%eax
80105bee:	66 83 f8 03          	cmp    $0x3,%ax
80105bf2:	0f 84 d0 01 00 00    	je     80105dc8 <trap+0x238>
        exit();

    // Force process to give up CPU on clock tick.
    // If interrupts were on while locks held, would need to check nlock.
    if (myproc() && myproc()->state == RUNNING &&
80105bf8:	e8 93 df ff ff       	call   80103b90 <myproc>
80105bfd:	85 c0                	test   %eax,%eax
80105bff:	74 0f                	je     80105c10 <trap+0x80>
80105c01:	e8 8a df ff ff       	call   80103b90 <myproc>
80105c06:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105c0a:	0f 84 78 01 00 00    	je     80105d88 <trap+0x1f8>
        tf->trapno == T_IRQ0 + IRQ_TIMER)
        yield();

    // Check if the process has been killed since we yielded
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80105c10:	e8 7b df ff ff       	call   80103b90 <myproc>
80105c15:	85 c0                	test   %eax,%eax
80105c17:	74 1d                	je     80105c36 <trap+0xa6>
80105c19:	e8 72 df ff ff       	call   80103b90 <myproc>
80105c1e:	8b 40 24             	mov    0x24(%eax),%eax
80105c21:	85 c0                	test   %eax,%eax
80105c23:	74 11                	je     80105c36 <trap+0xa6>
80105c25:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105c29:	83 e0 03             	and    $0x3,%eax
80105c2c:	66 83 f8 03          	cmp    $0x3,%ax
80105c30:	0f 84 d7 00 00 00    	je     80105d0d <trap+0x17d>
        exit();
}
80105c36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c39:	5b                   	pop    %ebx
80105c3a:	5e                   	pop    %esi
80105c3b:	5f                   	pop    %edi
80105c3c:	5d                   	pop    %ebp
80105c3d:	c3                   	ret
80105c3e:	66 90                	xchg   %ax,%ax
            if (myproc() == 0 || (tf->cs & 3) == 0) {
80105c40:	e8 4b df ff ff       	call   80103b90 <myproc>
80105c45:	8b 7b 38             	mov    0x38(%ebx),%edi
80105c48:	85 c0                	test   %eax,%eax
80105c4a:	0f 84 92 01 00 00    	je     80105de2 <trap+0x252>
80105c50:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105c54:	0f 84 88 01 00 00    	je     80105de2 <trap+0x252>
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105c5a:	0f 20 d1             	mov    %cr2,%ecx
80105c5d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c60:	e8 0b df ff ff       	call   80103b70 <cpuid>
80105c65:	8b 73 30             	mov    0x30(%ebx),%esi
80105c68:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105c6b:	8b 43 34             	mov    0x34(%ebx),%eax
80105c6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                    myproc()->pid, myproc()->name, tf->trapno,
80105c71:	e8 1a df ff ff       	call   80103b90 <myproc>
80105c76:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105c79:	e8 12 df ff ff       	call   80103b90 <myproc>
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c7e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105c81:	51                   	push   %ecx
80105c82:	57                   	push   %edi
80105c83:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105c86:	52                   	push   %edx
80105c87:	ff 75 e4             	push   -0x1c(%ebp)
80105c8a:	56                   	push   %esi
                    myproc()->pid, myproc()->name, tf->trapno,
80105c8b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105c8e:	83 c6 6c             	add    $0x6c,%esi
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c91:	56                   	push   %esi
80105c92:	ff 70 10             	push   0x10(%eax)
80105c95:	68 08 7f 10 80       	push   $0x80107f08
80105c9a:	e8 11 aa ff ff       	call   801006b0 <cprintf>
            myproc()->killed = 1;
80105c9f:	83 c4 20             	add    $0x20,%esp
80105ca2:	e8 e9 de ff ff       	call   80103b90 <myproc>
80105ca7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105cae:	e9 1f ff ff ff       	jmp    80105bd2 <trap+0x42>
80105cb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cb7:	90                   	nop
            cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105cb8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105cbb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105cbf:	e8 ac de ff ff       	call   80103b70 <cpuid>
80105cc4:	57                   	push   %edi
80105cc5:	56                   	push   %esi
80105cc6:	50                   	push   %eax
80105cc7:	68 b0 7e 10 80       	push   $0x80107eb0
80105ccc:	e8 df a9 ff ff       	call   801006b0 <cprintf>
            lapiceoi();
80105cd1:	e8 4a ce ff ff       	call   80102b20 <lapiceoi>
            break;
80105cd6:	83 c4 10             	add    $0x10,%esp
80105cd9:	e9 f4 fe ff ff       	jmp    80105bd2 <trap+0x42>
80105cde:	66 90                	xchg   %ax,%ax
        if (myproc()->killed)
80105ce0:	e8 ab de ff ff       	call   80103b90 <myproc>
80105ce5:	8b 70 24             	mov    0x24(%eax),%esi
80105ce8:	85 f6                	test   %esi,%esi
80105cea:	0f 85 e8 00 00 00    	jne    80105dd8 <trap+0x248>
        myproc()->tf = tf;
80105cf0:	e8 9b de ff ff       	call   80103b90 <myproc>
80105cf5:	89 58 18             	mov    %ebx,0x18(%eax)
        syscall();
80105cf8:	e8 93 ef ff ff       	call   80104c90 <syscall>
        if (myproc()->killed)
80105cfd:	e8 8e de ff ff       	call   80103b90 <myproc>
80105d02:	8b 58 24             	mov    0x24(%eax),%ebx
80105d05:	85 db                	test   %ebx,%ebx
80105d07:	0f 84 29 ff ff ff    	je     80105c36 <trap+0xa6>
}
80105d0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d10:	5b                   	pop    %ebx
80105d11:	5e                   	pop    %esi
80105d12:	5f                   	pop    %edi
80105d13:	5d                   	pop    %ebp
            exit();
80105d14:	e9 b7 e2 ff ff       	jmp    80103fd0 <exit>
80105d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            uartintr();
80105d20:	e8 6b 02 00 00       	call   80105f90 <uartintr>
            lapiceoi();
80105d25:	e8 f6 cd ff ff       	call   80102b20 <lapiceoi>
            break;
80105d2a:	e9 a3 fe ff ff       	jmp    80105bd2 <trap+0x42>
80105d2f:	90                   	nop
            kbdintr();
80105d30:	e8 ab cc ff ff       	call   801029e0 <kbdintr>
            lapiceoi();
80105d35:	e8 e6 cd ff ff       	call   80102b20 <lapiceoi>
            break;
80105d3a:	e9 93 fe ff ff       	jmp    80105bd2 <trap+0x42>
80105d3f:	90                   	nop
            if (cpuid() == 0) {
80105d40:	e8 2b de ff ff       	call   80103b70 <cpuid>
80105d45:	85 c0                	test   %eax,%eax
80105d47:	0f 85 80 fe ff ff    	jne    80105bcd <trap+0x3d>
                acquire(&tickslock);
80105d4d:	83 ec 0c             	sub    $0xc,%esp
80105d50:	68 a0 4c 18 80       	push   $0x80184ca0
80105d55:	e8 b6 e9 ff ff       	call   80104710 <acquire>
                ticks++;
80105d5a:	83 05 80 4c 18 80 01 	addl   $0x1,0x80184c80
                wakeup(&ticks);
80105d61:	c7 04 24 80 4c 18 80 	movl   $0x80184c80,(%esp)
80105d68:	e8 d3 e5 ff ff       	call   80104340 <wakeup>
                release(&tickslock);
80105d6d:	c7 04 24 a0 4c 18 80 	movl   $0x80184ca0,(%esp)
80105d74:	e8 d7 ea ff ff       	call   80104850 <release>
80105d79:	83 c4 10             	add    $0x10,%esp
            lapiceoi();
80105d7c:	e9 4c fe ff ff       	jmp    80105bcd <trap+0x3d>
80105d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (myproc() && myproc()->state == RUNNING &&
80105d88:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105d8c:	0f 85 7e fe ff ff    	jne    80105c10 <trap+0x80>
        yield();
80105d92:	e8 99 e4 ff ff       	call   80104230 <yield>
80105d97:	e9 74 fe ff ff       	jmp    80105c10 <trap+0x80>
80105d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        myproc()->tf = tf;
80105da0:	e8 eb dd ff ff       	call   80103b90 <myproc>
80105da5:	89 58 18             	mov    %ebx,0x18(%eax)
        pagefault();
80105da8:	e8 83 16 00 00       	call   80107430 <pagefault>
        if(myproc()->killed)
80105dad:	e8 de dd ff ff       	call   80103b90 <myproc>
80105db2:	8b 48 24             	mov    0x24(%eax),%ecx
80105db5:	85 c9                	test   %ecx,%ecx
80105db7:	0f 84 79 fe ff ff    	je     80105c36 <trap+0xa6>
80105dbd:	e9 4b ff ff ff       	jmp    80105d0d <trap+0x17d>
80105dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        exit();
80105dc8:	e8 03 e2 ff ff       	call   80103fd0 <exit>
80105dcd:	e9 26 fe ff ff       	jmp    80105bf8 <trap+0x68>
80105dd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            exit();
80105dd8:	e8 f3 e1 ff ff       	call   80103fd0 <exit>
80105ddd:	e9 0e ff ff ff       	jmp    80105cf0 <trap+0x160>
80105de2:	0f 20 d6             	mov    %cr2,%esi
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105de5:	e8 86 dd ff ff       	call   80103b70 <cpuid>
80105dea:	83 ec 0c             	sub    $0xc,%esp
80105ded:	56                   	push   %esi
80105dee:	57                   	push   %edi
80105def:	50                   	push   %eax
80105df0:	ff 73 30             	push   0x30(%ebx)
80105df3:	68 d4 7e 10 80       	push   $0x80107ed4
80105df8:	e8 b3 a8 ff ff       	call   801006b0 <cprintf>
                panic("trap");
80105dfd:	83 c4 14             	add    $0x14,%esp
80105e00:	68 a8 7e 10 80       	push   $0x80107ea8
80105e05:	e8 76 a5 ff ff       	call   80100380 <panic>
80105e0a:	66 90                	xchg   %ax,%ax
80105e0c:	66 90                	xchg   %ax,%ax
80105e0e:	66 90                	xchg   %ax,%ax

80105e10 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105e10:	a1 e0 54 18 80       	mov    0x801854e0,%eax
80105e15:	85 c0                	test   %eax,%eax
80105e17:	74 17                	je     80105e30 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e19:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e1e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105e1f:	a8 01                	test   $0x1,%al
80105e21:	74 0d                	je     80105e30 <uartgetc+0x20>
80105e23:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e28:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105e29:	0f b6 c0             	movzbl %al,%eax
80105e2c:	c3                   	ret
80105e2d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105e30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e35:	c3                   	ret
80105e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e3d:	8d 76 00             	lea    0x0(%esi),%esi

80105e40 <uartinit>:
{
80105e40:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e41:	31 c9                	xor    %ecx,%ecx
80105e43:	89 c8                	mov    %ecx,%eax
80105e45:	89 e5                	mov    %esp,%ebp
80105e47:	57                   	push   %edi
80105e48:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105e4d:	56                   	push   %esi
80105e4e:	89 fa                	mov    %edi,%edx
80105e50:	53                   	push   %ebx
80105e51:	83 ec 1c             	sub    $0x1c,%esp
80105e54:	ee                   	out    %al,(%dx)
80105e55:	be fb 03 00 00       	mov    $0x3fb,%esi
80105e5a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105e5f:	89 f2                	mov    %esi,%edx
80105e61:	ee                   	out    %al,(%dx)
80105e62:	b8 0c 00 00 00       	mov    $0xc,%eax
80105e67:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e6c:	ee                   	out    %al,(%dx)
80105e6d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105e72:	89 c8                	mov    %ecx,%eax
80105e74:	89 da                	mov    %ebx,%edx
80105e76:	ee                   	out    %al,(%dx)
80105e77:	b8 03 00 00 00       	mov    $0x3,%eax
80105e7c:	89 f2                	mov    %esi,%edx
80105e7e:	ee                   	out    %al,(%dx)
80105e7f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105e84:	89 c8                	mov    %ecx,%eax
80105e86:	ee                   	out    %al,(%dx)
80105e87:	b8 01 00 00 00       	mov    $0x1,%eax
80105e8c:	89 da                	mov    %ebx,%edx
80105e8e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e8f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e94:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105e95:	3c ff                	cmp    $0xff,%al
80105e97:	0f 84 7c 00 00 00    	je     80105f19 <uartinit+0xd9>
  uart = 1;
80105e9d:	c7 05 e0 54 18 80 01 	movl   $0x1,0x801854e0
80105ea4:	00 00 00 
80105ea7:	89 fa                	mov    %edi,%edx
80105ea9:	ec                   	in     (%dx),%al
80105eaa:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105eaf:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105eb0:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105eb3:	bf cc 7f 10 80       	mov    $0x80107fcc,%edi
80105eb8:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105ebd:	6a 00                	push   $0x0
80105ebf:	6a 04                	push   $0x4
80105ec1:	e8 3a c6 ff ff       	call   80102500 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105ec6:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105eca:	83 c4 10             	add    $0x10,%esp
80105ecd:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80105ed0:	a1 e0 54 18 80       	mov    0x801854e0,%eax
80105ed5:	85 c0                	test   %eax,%eax
80105ed7:	74 32                	je     80105f0b <uartinit+0xcb>
80105ed9:	89 f2                	mov    %esi,%edx
80105edb:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105edc:	a8 20                	test   $0x20,%al
80105ede:	75 21                	jne    80105f01 <uartinit+0xc1>
80105ee0:	bb 80 00 00 00       	mov    $0x80,%ebx
80105ee5:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80105ee8:	83 ec 0c             	sub    $0xc,%esp
80105eeb:	6a 0a                	push   $0xa
80105eed:	e8 4e cc ff ff       	call   80102b40 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105ef2:	83 c4 10             	add    $0x10,%esp
80105ef5:	83 eb 01             	sub    $0x1,%ebx
80105ef8:	74 07                	je     80105f01 <uartinit+0xc1>
80105efa:	89 f2                	mov    %esi,%edx
80105efc:	ec                   	in     (%dx),%al
80105efd:	a8 20                	test   $0x20,%al
80105eff:	74 e7                	je     80105ee8 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f01:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f06:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105f0a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105f0b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105f0f:	83 c7 01             	add    $0x1,%edi
80105f12:	88 45 e7             	mov    %al,-0x19(%ebp)
80105f15:	84 c0                	test   %al,%al
80105f17:	75 b7                	jne    80105ed0 <uartinit+0x90>
}
80105f19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f1c:	5b                   	pop    %ebx
80105f1d:	5e                   	pop    %esi
80105f1e:	5f                   	pop    %edi
80105f1f:	5d                   	pop    %ebp
80105f20:	c3                   	ret
80105f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f2f:	90                   	nop

80105f30 <uartputc>:
  if(!uart)
80105f30:	a1 e0 54 18 80       	mov    0x801854e0,%eax
80105f35:	85 c0                	test   %eax,%eax
80105f37:	74 4f                	je     80105f88 <uartputc+0x58>
{
80105f39:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f3a:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f3f:	89 e5                	mov    %esp,%ebp
80105f41:	56                   	push   %esi
80105f42:	53                   	push   %ebx
80105f43:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f44:	a8 20                	test   $0x20,%al
80105f46:	75 29                	jne    80105f71 <uartputc+0x41>
80105f48:	bb 80 00 00 00       	mov    $0x80,%ebx
80105f4d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105f52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105f58:	83 ec 0c             	sub    $0xc,%esp
80105f5b:	6a 0a                	push   $0xa
80105f5d:	e8 de cb ff ff       	call   80102b40 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f62:	83 c4 10             	add    $0x10,%esp
80105f65:	83 eb 01             	sub    $0x1,%ebx
80105f68:	74 07                	je     80105f71 <uartputc+0x41>
80105f6a:	89 f2                	mov    %esi,%edx
80105f6c:	ec                   	in     (%dx),%al
80105f6d:	a8 20                	test   $0x20,%al
80105f6f:	74 e7                	je     80105f58 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f71:	8b 45 08             	mov    0x8(%ebp),%eax
80105f74:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f79:	ee                   	out    %al,(%dx)
}
80105f7a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f7d:	5b                   	pop    %ebx
80105f7e:	5e                   	pop    %esi
80105f7f:	5d                   	pop    %ebp
80105f80:	c3                   	ret
80105f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f88:	c3                   	ret
80105f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f90 <uartintr>:

void
uartintr(void)
{
80105f90:	55                   	push   %ebp
80105f91:	89 e5                	mov    %esp,%ebp
80105f93:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105f96:	68 10 5e 10 80       	push   $0x80105e10
80105f9b:	e8 20 a9 ff ff       	call   801008c0 <consoleintr>
}
80105fa0:	83 c4 10             	add    $0x10,%esp
80105fa3:	c9                   	leave
80105fa4:	c3                   	ret

80105fa5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105fa5:	6a 00                	push   $0x0
  pushl $0
80105fa7:	6a 00                	push   $0x0
  jmp alltraps
80105fa9:	e9 08 fb ff ff       	jmp    80105ab6 <alltraps>

80105fae <vector1>:
.globl vector1
vector1:
  pushl $0
80105fae:	6a 00                	push   $0x0
  pushl $1
80105fb0:	6a 01                	push   $0x1
  jmp alltraps
80105fb2:	e9 ff fa ff ff       	jmp    80105ab6 <alltraps>

80105fb7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105fb7:	6a 00                	push   $0x0
  pushl $2
80105fb9:	6a 02                	push   $0x2
  jmp alltraps
80105fbb:	e9 f6 fa ff ff       	jmp    80105ab6 <alltraps>

80105fc0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105fc0:	6a 00                	push   $0x0
  pushl $3
80105fc2:	6a 03                	push   $0x3
  jmp alltraps
80105fc4:	e9 ed fa ff ff       	jmp    80105ab6 <alltraps>

80105fc9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105fc9:	6a 00                	push   $0x0
  pushl $4
80105fcb:	6a 04                	push   $0x4
  jmp alltraps
80105fcd:	e9 e4 fa ff ff       	jmp    80105ab6 <alltraps>

80105fd2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105fd2:	6a 00                	push   $0x0
  pushl $5
80105fd4:	6a 05                	push   $0x5
  jmp alltraps
80105fd6:	e9 db fa ff ff       	jmp    80105ab6 <alltraps>

80105fdb <vector6>:
.globl vector6
vector6:
  pushl $0
80105fdb:	6a 00                	push   $0x0
  pushl $6
80105fdd:	6a 06                	push   $0x6
  jmp alltraps
80105fdf:	e9 d2 fa ff ff       	jmp    80105ab6 <alltraps>

80105fe4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105fe4:	6a 00                	push   $0x0
  pushl $7
80105fe6:	6a 07                	push   $0x7
  jmp alltraps
80105fe8:	e9 c9 fa ff ff       	jmp    80105ab6 <alltraps>

80105fed <vector8>:
.globl vector8
vector8:
  pushl $8
80105fed:	6a 08                	push   $0x8
  jmp alltraps
80105fef:	e9 c2 fa ff ff       	jmp    80105ab6 <alltraps>

80105ff4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105ff4:	6a 00                	push   $0x0
  pushl $9
80105ff6:	6a 09                	push   $0x9
  jmp alltraps
80105ff8:	e9 b9 fa ff ff       	jmp    80105ab6 <alltraps>

80105ffd <vector10>:
.globl vector10
vector10:
  pushl $10
80105ffd:	6a 0a                	push   $0xa
  jmp alltraps
80105fff:	e9 b2 fa ff ff       	jmp    80105ab6 <alltraps>

80106004 <vector11>:
.globl vector11
vector11:
  pushl $11
80106004:	6a 0b                	push   $0xb
  jmp alltraps
80106006:	e9 ab fa ff ff       	jmp    80105ab6 <alltraps>

8010600b <vector12>:
.globl vector12
vector12:
  pushl $12
8010600b:	6a 0c                	push   $0xc
  jmp alltraps
8010600d:	e9 a4 fa ff ff       	jmp    80105ab6 <alltraps>

80106012 <vector13>:
.globl vector13
vector13:
  pushl $13
80106012:	6a 0d                	push   $0xd
  jmp alltraps
80106014:	e9 9d fa ff ff       	jmp    80105ab6 <alltraps>

80106019 <vector14>:
.globl vector14
vector14:
  pushl $14
80106019:	6a 0e                	push   $0xe
  jmp alltraps
8010601b:	e9 96 fa ff ff       	jmp    80105ab6 <alltraps>

80106020 <vector15>:
.globl vector15
vector15:
  pushl $0
80106020:	6a 00                	push   $0x0
  pushl $15
80106022:	6a 0f                	push   $0xf
  jmp alltraps
80106024:	e9 8d fa ff ff       	jmp    80105ab6 <alltraps>

80106029 <vector16>:
.globl vector16
vector16:
  pushl $0
80106029:	6a 00                	push   $0x0
  pushl $16
8010602b:	6a 10                	push   $0x10
  jmp alltraps
8010602d:	e9 84 fa ff ff       	jmp    80105ab6 <alltraps>

80106032 <vector17>:
.globl vector17
vector17:
  pushl $17
80106032:	6a 11                	push   $0x11
  jmp alltraps
80106034:	e9 7d fa ff ff       	jmp    80105ab6 <alltraps>

80106039 <vector18>:
.globl vector18
vector18:
  pushl $0
80106039:	6a 00                	push   $0x0
  pushl $18
8010603b:	6a 12                	push   $0x12
  jmp alltraps
8010603d:	e9 74 fa ff ff       	jmp    80105ab6 <alltraps>

80106042 <vector19>:
.globl vector19
vector19:
  pushl $0
80106042:	6a 00                	push   $0x0
  pushl $19
80106044:	6a 13                	push   $0x13
  jmp alltraps
80106046:	e9 6b fa ff ff       	jmp    80105ab6 <alltraps>

8010604b <vector20>:
.globl vector20
vector20:
  pushl $0
8010604b:	6a 00                	push   $0x0
  pushl $20
8010604d:	6a 14                	push   $0x14
  jmp alltraps
8010604f:	e9 62 fa ff ff       	jmp    80105ab6 <alltraps>

80106054 <vector21>:
.globl vector21
vector21:
  pushl $0
80106054:	6a 00                	push   $0x0
  pushl $21
80106056:	6a 15                	push   $0x15
  jmp alltraps
80106058:	e9 59 fa ff ff       	jmp    80105ab6 <alltraps>

8010605d <vector22>:
.globl vector22
vector22:
  pushl $0
8010605d:	6a 00                	push   $0x0
  pushl $22
8010605f:	6a 16                	push   $0x16
  jmp alltraps
80106061:	e9 50 fa ff ff       	jmp    80105ab6 <alltraps>

80106066 <vector23>:
.globl vector23
vector23:
  pushl $0
80106066:	6a 00                	push   $0x0
  pushl $23
80106068:	6a 17                	push   $0x17
  jmp alltraps
8010606a:	e9 47 fa ff ff       	jmp    80105ab6 <alltraps>

8010606f <vector24>:
.globl vector24
vector24:
  pushl $0
8010606f:	6a 00                	push   $0x0
  pushl $24
80106071:	6a 18                	push   $0x18
  jmp alltraps
80106073:	e9 3e fa ff ff       	jmp    80105ab6 <alltraps>

80106078 <vector25>:
.globl vector25
vector25:
  pushl $0
80106078:	6a 00                	push   $0x0
  pushl $25
8010607a:	6a 19                	push   $0x19
  jmp alltraps
8010607c:	e9 35 fa ff ff       	jmp    80105ab6 <alltraps>

80106081 <vector26>:
.globl vector26
vector26:
  pushl $0
80106081:	6a 00                	push   $0x0
  pushl $26
80106083:	6a 1a                	push   $0x1a
  jmp alltraps
80106085:	e9 2c fa ff ff       	jmp    80105ab6 <alltraps>

8010608a <vector27>:
.globl vector27
vector27:
  pushl $0
8010608a:	6a 00                	push   $0x0
  pushl $27
8010608c:	6a 1b                	push   $0x1b
  jmp alltraps
8010608e:	e9 23 fa ff ff       	jmp    80105ab6 <alltraps>

80106093 <vector28>:
.globl vector28
vector28:
  pushl $0
80106093:	6a 00                	push   $0x0
  pushl $28
80106095:	6a 1c                	push   $0x1c
  jmp alltraps
80106097:	e9 1a fa ff ff       	jmp    80105ab6 <alltraps>

8010609c <vector29>:
.globl vector29
vector29:
  pushl $0
8010609c:	6a 00                	push   $0x0
  pushl $29
8010609e:	6a 1d                	push   $0x1d
  jmp alltraps
801060a0:	e9 11 fa ff ff       	jmp    80105ab6 <alltraps>

801060a5 <vector30>:
.globl vector30
vector30:
  pushl $0
801060a5:	6a 00                	push   $0x0
  pushl $30
801060a7:	6a 1e                	push   $0x1e
  jmp alltraps
801060a9:	e9 08 fa ff ff       	jmp    80105ab6 <alltraps>

801060ae <vector31>:
.globl vector31
vector31:
  pushl $0
801060ae:	6a 00                	push   $0x0
  pushl $31
801060b0:	6a 1f                	push   $0x1f
  jmp alltraps
801060b2:	e9 ff f9 ff ff       	jmp    80105ab6 <alltraps>

801060b7 <vector32>:
.globl vector32
vector32:
  pushl $0
801060b7:	6a 00                	push   $0x0
  pushl $32
801060b9:	6a 20                	push   $0x20
  jmp alltraps
801060bb:	e9 f6 f9 ff ff       	jmp    80105ab6 <alltraps>

801060c0 <vector33>:
.globl vector33
vector33:
  pushl $0
801060c0:	6a 00                	push   $0x0
  pushl $33
801060c2:	6a 21                	push   $0x21
  jmp alltraps
801060c4:	e9 ed f9 ff ff       	jmp    80105ab6 <alltraps>

801060c9 <vector34>:
.globl vector34
vector34:
  pushl $0
801060c9:	6a 00                	push   $0x0
  pushl $34
801060cb:	6a 22                	push   $0x22
  jmp alltraps
801060cd:	e9 e4 f9 ff ff       	jmp    80105ab6 <alltraps>

801060d2 <vector35>:
.globl vector35
vector35:
  pushl $0
801060d2:	6a 00                	push   $0x0
  pushl $35
801060d4:	6a 23                	push   $0x23
  jmp alltraps
801060d6:	e9 db f9 ff ff       	jmp    80105ab6 <alltraps>

801060db <vector36>:
.globl vector36
vector36:
  pushl $0
801060db:	6a 00                	push   $0x0
  pushl $36
801060dd:	6a 24                	push   $0x24
  jmp alltraps
801060df:	e9 d2 f9 ff ff       	jmp    80105ab6 <alltraps>

801060e4 <vector37>:
.globl vector37
vector37:
  pushl $0
801060e4:	6a 00                	push   $0x0
  pushl $37
801060e6:	6a 25                	push   $0x25
  jmp alltraps
801060e8:	e9 c9 f9 ff ff       	jmp    80105ab6 <alltraps>

801060ed <vector38>:
.globl vector38
vector38:
  pushl $0
801060ed:	6a 00                	push   $0x0
  pushl $38
801060ef:	6a 26                	push   $0x26
  jmp alltraps
801060f1:	e9 c0 f9 ff ff       	jmp    80105ab6 <alltraps>

801060f6 <vector39>:
.globl vector39
vector39:
  pushl $0
801060f6:	6a 00                	push   $0x0
  pushl $39
801060f8:	6a 27                	push   $0x27
  jmp alltraps
801060fa:	e9 b7 f9 ff ff       	jmp    80105ab6 <alltraps>

801060ff <vector40>:
.globl vector40
vector40:
  pushl $0
801060ff:	6a 00                	push   $0x0
  pushl $40
80106101:	6a 28                	push   $0x28
  jmp alltraps
80106103:	e9 ae f9 ff ff       	jmp    80105ab6 <alltraps>

80106108 <vector41>:
.globl vector41
vector41:
  pushl $0
80106108:	6a 00                	push   $0x0
  pushl $41
8010610a:	6a 29                	push   $0x29
  jmp alltraps
8010610c:	e9 a5 f9 ff ff       	jmp    80105ab6 <alltraps>

80106111 <vector42>:
.globl vector42
vector42:
  pushl $0
80106111:	6a 00                	push   $0x0
  pushl $42
80106113:	6a 2a                	push   $0x2a
  jmp alltraps
80106115:	e9 9c f9 ff ff       	jmp    80105ab6 <alltraps>

8010611a <vector43>:
.globl vector43
vector43:
  pushl $0
8010611a:	6a 00                	push   $0x0
  pushl $43
8010611c:	6a 2b                	push   $0x2b
  jmp alltraps
8010611e:	e9 93 f9 ff ff       	jmp    80105ab6 <alltraps>

80106123 <vector44>:
.globl vector44
vector44:
  pushl $0
80106123:	6a 00                	push   $0x0
  pushl $44
80106125:	6a 2c                	push   $0x2c
  jmp alltraps
80106127:	e9 8a f9 ff ff       	jmp    80105ab6 <alltraps>

8010612c <vector45>:
.globl vector45
vector45:
  pushl $0
8010612c:	6a 00                	push   $0x0
  pushl $45
8010612e:	6a 2d                	push   $0x2d
  jmp alltraps
80106130:	e9 81 f9 ff ff       	jmp    80105ab6 <alltraps>

80106135 <vector46>:
.globl vector46
vector46:
  pushl $0
80106135:	6a 00                	push   $0x0
  pushl $46
80106137:	6a 2e                	push   $0x2e
  jmp alltraps
80106139:	e9 78 f9 ff ff       	jmp    80105ab6 <alltraps>

8010613e <vector47>:
.globl vector47
vector47:
  pushl $0
8010613e:	6a 00                	push   $0x0
  pushl $47
80106140:	6a 2f                	push   $0x2f
  jmp alltraps
80106142:	e9 6f f9 ff ff       	jmp    80105ab6 <alltraps>

80106147 <vector48>:
.globl vector48
vector48:
  pushl $0
80106147:	6a 00                	push   $0x0
  pushl $48
80106149:	6a 30                	push   $0x30
  jmp alltraps
8010614b:	e9 66 f9 ff ff       	jmp    80105ab6 <alltraps>

80106150 <vector49>:
.globl vector49
vector49:
  pushl $0
80106150:	6a 00                	push   $0x0
  pushl $49
80106152:	6a 31                	push   $0x31
  jmp alltraps
80106154:	e9 5d f9 ff ff       	jmp    80105ab6 <alltraps>

80106159 <vector50>:
.globl vector50
vector50:
  pushl $0
80106159:	6a 00                	push   $0x0
  pushl $50
8010615b:	6a 32                	push   $0x32
  jmp alltraps
8010615d:	e9 54 f9 ff ff       	jmp    80105ab6 <alltraps>

80106162 <vector51>:
.globl vector51
vector51:
  pushl $0
80106162:	6a 00                	push   $0x0
  pushl $51
80106164:	6a 33                	push   $0x33
  jmp alltraps
80106166:	e9 4b f9 ff ff       	jmp    80105ab6 <alltraps>

8010616b <vector52>:
.globl vector52
vector52:
  pushl $0
8010616b:	6a 00                	push   $0x0
  pushl $52
8010616d:	6a 34                	push   $0x34
  jmp alltraps
8010616f:	e9 42 f9 ff ff       	jmp    80105ab6 <alltraps>

80106174 <vector53>:
.globl vector53
vector53:
  pushl $0
80106174:	6a 00                	push   $0x0
  pushl $53
80106176:	6a 35                	push   $0x35
  jmp alltraps
80106178:	e9 39 f9 ff ff       	jmp    80105ab6 <alltraps>

8010617d <vector54>:
.globl vector54
vector54:
  pushl $0
8010617d:	6a 00                	push   $0x0
  pushl $54
8010617f:	6a 36                	push   $0x36
  jmp alltraps
80106181:	e9 30 f9 ff ff       	jmp    80105ab6 <alltraps>

80106186 <vector55>:
.globl vector55
vector55:
  pushl $0
80106186:	6a 00                	push   $0x0
  pushl $55
80106188:	6a 37                	push   $0x37
  jmp alltraps
8010618a:	e9 27 f9 ff ff       	jmp    80105ab6 <alltraps>

8010618f <vector56>:
.globl vector56
vector56:
  pushl $0
8010618f:	6a 00                	push   $0x0
  pushl $56
80106191:	6a 38                	push   $0x38
  jmp alltraps
80106193:	e9 1e f9 ff ff       	jmp    80105ab6 <alltraps>

80106198 <vector57>:
.globl vector57
vector57:
  pushl $0
80106198:	6a 00                	push   $0x0
  pushl $57
8010619a:	6a 39                	push   $0x39
  jmp alltraps
8010619c:	e9 15 f9 ff ff       	jmp    80105ab6 <alltraps>

801061a1 <vector58>:
.globl vector58
vector58:
  pushl $0
801061a1:	6a 00                	push   $0x0
  pushl $58
801061a3:	6a 3a                	push   $0x3a
  jmp alltraps
801061a5:	e9 0c f9 ff ff       	jmp    80105ab6 <alltraps>

801061aa <vector59>:
.globl vector59
vector59:
  pushl $0
801061aa:	6a 00                	push   $0x0
  pushl $59
801061ac:	6a 3b                	push   $0x3b
  jmp alltraps
801061ae:	e9 03 f9 ff ff       	jmp    80105ab6 <alltraps>

801061b3 <vector60>:
.globl vector60
vector60:
  pushl $0
801061b3:	6a 00                	push   $0x0
  pushl $60
801061b5:	6a 3c                	push   $0x3c
  jmp alltraps
801061b7:	e9 fa f8 ff ff       	jmp    80105ab6 <alltraps>

801061bc <vector61>:
.globl vector61
vector61:
  pushl $0
801061bc:	6a 00                	push   $0x0
  pushl $61
801061be:	6a 3d                	push   $0x3d
  jmp alltraps
801061c0:	e9 f1 f8 ff ff       	jmp    80105ab6 <alltraps>

801061c5 <vector62>:
.globl vector62
vector62:
  pushl $0
801061c5:	6a 00                	push   $0x0
  pushl $62
801061c7:	6a 3e                	push   $0x3e
  jmp alltraps
801061c9:	e9 e8 f8 ff ff       	jmp    80105ab6 <alltraps>

801061ce <vector63>:
.globl vector63
vector63:
  pushl $0
801061ce:	6a 00                	push   $0x0
  pushl $63
801061d0:	6a 3f                	push   $0x3f
  jmp alltraps
801061d2:	e9 df f8 ff ff       	jmp    80105ab6 <alltraps>

801061d7 <vector64>:
.globl vector64
vector64:
  pushl $0
801061d7:	6a 00                	push   $0x0
  pushl $64
801061d9:	6a 40                	push   $0x40
  jmp alltraps
801061db:	e9 d6 f8 ff ff       	jmp    80105ab6 <alltraps>

801061e0 <vector65>:
.globl vector65
vector65:
  pushl $0
801061e0:	6a 00                	push   $0x0
  pushl $65
801061e2:	6a 41                	push   $0x41
  jmp alltraps
801061e4:	e9 cd f8 ff ff       	jmp    80105ab6 <alltraps>

801061e9 <vector66>:
.globl vector66
vector66:
  pushl $0
801061e9:	6a 00                	push   $0x0
  pushl $66
801061eb:	6a 42                	push   $0x42
  jmp alltraps
801061ed:	e9 c4 f8 ff ff       	jmp    80105ab6 <alltraps>

801061f2 <vector67>:
.globl vector67
vector67:
  pushl $0
801061f2:	6a 00                	push   $0x0
  pushl $67
801061f4:	6a 43                	push   $0x43
  jmp alltraps
801061f6:	e9 bb f8 ff ff       	jmp    80105ab6 <alltraps>

801061fb <vector68>:
.globl vector68
vector68:
  pushl $0
801061fb:	6a 00                	push   $0x0
  pushl $68
801061fd:	6a 44                	push   $0x44
  jmp alltraps
801061ff:	e9 b2 f8 ff ff       	jmp    80105ab6 <alltraps>

80106204 <vector69>:
.globl vector69
vector69:
  pushl $0
80106204:	6a 00                	push   $0x0
  pushl $69
80106206:	6a 45                	push   $0x45
  jmp alltraps
80106208:	e9 a9 f8 ff ff       	jmp    80105ab6 <alltraps>

8010620d <vector70>:
.globl vector70
vector70:
  pushl $0
8010620d:	6a 00                	push   $0x0
  pushl $70
8010620f:	6a 46                	push   $0x46
  jmp alltraps
80106211:	e9 a0 f8 ff ff       	jmp    80105ab6 <alltraps>

80106216 <vector71>:
.globl vector71
vector71:
  pushl $0
80106216:	6a 00                	push   $0x0
  pushl $71
80106218:	6a 47                	push   $0x47
  jmp alltraps
8010621a:	e9 97 f8 ff ff       	jmp    80105ab6 <alltraps>

8010621f <vector72>:
.globl vector72
vector72:
  pushl $0
8010621f:	6a 00                	push   $0x0
  pushl $72
80106221:	6a 48                	push   $0x48
  jmp alltraps
80106223:	e9 8e f8 ff ff       	jmp    80105ab6 <alltraps>

80106228 <vector73>:
.globl vector73
vector73:
  pushl $0
80106228:	6a 00                	push   $0x0
  pushl $73
8010622a:	6a 49                	push   $0x49
  jmp alltraps
8010622c:	e9 85 f8 ff ff       	jmp    80105ab6 <alltraps>

80106231 <vector74>:
.globl vector74
vector74:
  pushl $0
80106231:	6a 00                	push   $0x0
  pushl $74
80106233:	6a 4a                	push   $0x4a
  jmp alltraps
80106235:	e9 7c f8 ff ff       	jmp    80105ab6 <alltraps>

8010623a <vector75>:
.globl vector75
vector75:
  pushl $0
8010623a:	6a 00                	push   $0x0
  pushl $75
8010623c:	6a 4b                	push   $0x4b
  jmp alltraps
8010623e:	e9 73 f8 ff ff       	jmp    80105ab6 <alltraps>

80106243 <vector76>:
.globl vector76
vector76:
  pushl $0
80106243:	6a 00                	push   $0x0
  pushl $76
80106245:	6a 4c                	push   $0x4c
  jmp alltraps
80106247:	e9 6a f8 ff ff       	jmp    80105ab6 <alltraps>

8010624c <vector77>:
.globl vector77
vector77:
  pushl $0
8010624c:	6a 00                	push   $0x0
  pushl $77
8010624e:	6a 4d                	push   $0x4d
  jmp alltraps
80106250:	e9 61 f8 ff ff       	jmp    80105ab6 <alltraps>

80106255 <vector78>:
.globl vector78
vector78:
  pushl $0
80106255:	6a 00                	push   $0x0
  pushl $78
80106257:	6a 4e                	push   $0x4e
  jmp alltraps
80106259:	e9 58 f8 ff ff       	jmp    80105ab6 <alltraps>

8010625e <vector79>:
.globl vector79
vector79:
  pushl $0
8010625e:	6a 00                	push   $0x0
  pushl $79
80106260:	6a 4f                	push   $0x4f
  jmp alltraps
80106262:	e9 4f f8 ff ff       	jmp    80105ab6 <alltraps>

80106267 <vector80>:
.globl vector80
vector80:
  pushl $0
80106267:	6a 00                	push   $0x0
  pushl $80
80106269:	6a 50                	push   $0x50
  jmp alltraps
8010626b:	e9 46 f8 ff ff       	jmp    80105ab6 <alltraps>

80106270 <vector81>:
.globl vector81
vector81:
  pushl $0
80106270:	6a 00                	push   $0x0
  pushl $81
80106272:	6a 51                	push   $0x51
  jmp alltraps
80106274:	e9 3d f8 ff ff       	jmp    80105ab6 <alltraps>

80106279 <vector82>:
.globl vector82
vector82:
  pushl $0
80106279:	6a 00                	push   $0x0
  pushl $82
8010627b:	6a 52                	push   $0x52
  jmp alltraps
8010627d:	e9 34 f8 ff ff       	jmp    80105ab6 <alltraps>

80106282 <vector83>:
.globl vector83
vector83:
  pushl $0
80106282:	6a 00                	push   $0x0
  pushl $83
80106284:	6a 53                	push   $0x53
  jmp alltraps
80106286:	e9 2b f8 ff ff       	jmp    80105ab6 <alltraps>

8010628b <vector84>:
.globl vector84
vector84:
  pushl $0
8010628b:	6a 00                	push   $0x0
  pushl $84
8010628d:	6a 54                	push   $0x54
  jmp alltraps
8010628f:	e9 22 f8 ff ff       	jmp    80105ab6 <alltraps>

80106294 <vector85>:
.globl vector85
vector85:
  pushl $0
80106294:	6a 00                	push   $0x0
  pushl $85
80106296:	6a 55                	push   $0x55
  jmp alltraps
80106298:	e9 19 f8 ff ff       	jmp    80105ab6 <alltraps>

8010629d <vector86>:
.globl vector86
vector86:
  pushl $0
8010629d:	6a 00                	push   $0x0
  pushl $86
8010629f:	6a 56                	push   $0x56
  jmp alltraps
801062a1:	e9 10 f8 ff ff       	jmp    80105ab6 <alltraps>

801062a6 <vector87>:
.globl vector87
vector87:
  pushl $0
801062a6:	6a 00                	push   $0x0
  pushl $87
801062a8:	6a 57                	push   $0x57
  jmp alltraps
801062aa:	e9 07 f8 ff ff       	jmp    80105ab6 <alltraps>

801062af <vector88>:
.globl vector88
vector88:
  pushl $0
801062af:	6a 00                	push   $0x0
  pushl $88
801062b1:	6a 58                	push   $0x58
  jmp alltraps
801062b3:	e9 fe f7 ff ff       	jmp    80105ab6 <alltraps>

801062b8 <vector89>:
.globl vector89
vector89:
  pushl $0
801062b8:	6a 00                	push   $0x0
  pushl $89
801062ba:	6a 59                	push   $0x59
  jmp alltraps
801062bc:	e9 f5 f7 ff ff       	jmp    80105ab6 <alltraps>

801062c1 <vector90>:
.globl vector90
vector90:
  pushl $0
801062c1:	6a 00                	push   $0x0
  pushl $90
801062c3:	6a 5a                	push   $0x5a
  jmp alltraps
801062c5:	e9 ec f7 ff ff       	jmp    80105ab6 <alltraps>

801062ca <vector91>:
.globl vector91
vector91:
  pushl $0
801062ca:	6a 00                	push   $0x0
  pushl $91
801062cc:	6a 5b                	push   $0x5b
  jmp alltraps
801062ce:	e9 e3 f7 ff ff       	jmp    80105ab6 <alltraps>

801062d3 <vector92>:
.globl vector92
vector92:
  pushl $0
801062d3:	6a 00                	push   $0x0
  pushl $92
801062d5:	6a 5c                	push   $0x5c
  jmp alltraps
801062d7:	e9 da f7 ff ff       	jmp    80105ab6 <alltraps>

801062dc <vector93>:
.globl vector93
vector93:
  pushl $0
801062dc:	6a 00                	push   $0x0
  pushl $93
801062de:	6a 5d                	push   $0x5d
  jmp alltraps
801062e0:	e9 d1 f7 ff ff       	jmp    80105ab6 <alltraps>

801062e5 <vector94>:
.globl vector94
vector94:
  pushl $0
801062e5:	6a 00                	push   $0x0
  pushl $94
801062e7:	6a 5e                	push   $0x5e
  jmp alltraps
801062e9:	e9 c8 f7 ff ff       	jmp    80105ab6 <alltraps>

801062ee <vector95>:
.globl vector95
vector95:
  pushl $0
801062ee:	6a 00                	push   $0x0
  pushl $95
801062f0:	6a 5f                	push   $0x5f
  jmp alltraps
801062f2:	e9 bf f7 ff ff       	jmp    80105ab6 <alltraps>

801062f7 <vector96>:
.globl vector96
vector96:
  pushl $0
801062f7:	6a 00                	push   $0x0
  pushl $96
801062f9:	6a 60                	push   $0x60
  jmp alltraps
801062fb:	e9 b6 f7 ff ff       	jmp    80105ab6 <alltraps>

80106300 <vector97>:
.globl vector97
vector97:
  pushl $0
80106300:	6a 00                	push   $0x0
  pushl $97
80106302:	6a 61                	push   $0x61
  jmp alltraps
80106304:	e9 ad f7 ff ff       	jmp    80105ab6 <alltraps>

80106309 <vector98>:
.globl vector98
vector98:
  pushl $0
80106309:	6a 00                	push   $0x0
  pushl $98
8010630b:	6a 62                	push   $0x62
  jmp alltraps
8010630d:	e9 a4 f7 ff ff       	jmp    80105ab6 <alltraps>

80106312 <vector99>:
.globl vector99
vector99:
  pushl $0
80106312:	6a 00                	push   $0x0
  pushl $99
80106314:	6a 63                	push   $0x63
  jmp alltraps
80106316:	e9 9b f7 ff ff       	jmp    80105ab6 <alltraps>

8010631b <vector100>:
.globl vector100
vector100:
  pushl $0
8010631b:	6a 00                	push   $0x0
  pushl $100
8010631d:	6a 64                	push   $0x64
  jmp alltraps
8010631f:	e9 92 f7 ff ff       	jmp    80105ab6 <alltraps>

80106324 <vector101>:
.globl vector101
vector101:
  pushl $0
80106324:	6a 00                	push   $0x0
  pushl $101
80106326:	6a 65                	push   $0x65
  jmp alltraps
80106328:	e9 89 f7 ff ff       	jmp    80105ab6 <alltraps>

8010632d <vector102>:
.globl vector102
vector102:
  pushl $0
8010632d:	6a 00                	push   $0x0
  pushl $102
8010632f:	6a 66                	push   $0x66
  jmp alltraps
80106331:	e9 80 f7 ff ff       	jmp    80105ab6 <alltraps>

80106336 <vector103>:
.globl vector103
vector103:
  pushl $0
80106336:	6a 00                	push   $0x0
  pushl $103
80106338:	6a 67                	push   $0x67
  jmp alltraps
8010633a:	e9 77 f7 ff ff       	jmp    80105ab6 <alltraps>

8010633f <vector104>:
.globl vector104
vector104:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $104
80106341:	6a 68                	push   $0x68
  jmp alltraps
80106343:	e9 6e f7 ff ff       	jmp    80105ab6 <alltraps>

80106348 <vector105>:
.globl vector105
vector105:
  pushl $0
80106348:	6a 00                	push   $0x0
  pushl $105
8010634a:	6a 69                	push   $0x69
  jmp alltraps
8010634c:	e9 65 f7 ff ff       	jmp    80105ab6 <alltraps>

80106351 <vector106>:
.globl vector106
vector106:
  pushl $0
80106351:	6a 00                	push   $0x0
  pushl $106
80106353:	6a 6a                	push   $0x6a
  jmp alltraps
80106355:	e9 5c f7 ff ff       	jmp    80105ab6 <alltraps>

8010635a <vector107>:
.globl vector107
vector107:
  pushl $0
8010635a:	6a 00                	push   $0x0
  pushl $107
8010635c:	6a 6b                	push   $0x6b
  jmp alltraps
8010635e:	e9 53 f7 ff ff       	jmp    80105ab6 <alltraps>

80106363 <vector108>:
.globl vector108
vector108:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $108
80106365:	6a 6c                	push   $0x6c
  jmp alltraps
80106367:	e9 4a f7 ff ff       	jmp    80105ab6 <alltraps>

8010636c <vector109>:
.globl vector109
vector109:
  pushl $0
8010636c:	6a 00                	push   $0x0
  pushl $109
8010636e:	6a 6d                	push   $0x6d
  jmp alltraps
80106370:	e9 41 f7 ff ff       	jmp    80105ab6 <alltraps>

80106375 <vector110>:
.globl vector110
vector110:
  pushl $0
80106375:	6a 00                	push   $0x0
  pushl $110
80106377:	6a 6e                	push   $0x6e
  jmp alltraps
80106379:	e9 38 f7 ff ff       	jmp    80105ab6 <alltraps>

8010637e <vector111>:
.globl vector111
vector111:
  pushl $0
8010637e:	6a 00                	push   $0x0
  pushl $111
80106380:	6a 6f                	push   $0x6f
  jmp alltraps
80106382:	e9 2f f7 ff ff       	jmp    80105ab6 <alltraps>

80106387 <vector112>:
.globl vector112
vector112:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $112
80106389:	6a 70                	push   $0x70
  jmp alltraps
8010638b:	e9 26 f7 ff ff       	jmp    80105ab6 <alltraps>

80106390 <vector113>:
.globl vector113
vector113:
  pushl $0
80106390:	6a 00                	push   $0x0
  pushl $113
80106392:	6a 71                	push   $0x71
  jmp alltraps
80106394:	e9 1d f7 ff ff       	jmp    80105ab6 <alltraps>

80106399 <vector114>:
.globl vector114
vector114:
  pushl $0
80106399:	6a 00                	push   $0x0
  pushl $114
8010639b:	6a 72                	push   $0x72
  jmp alltraps
8010639d:	e9 14 f7 ff ff       	jmp    80105ab6 <alltraps>

801063a2 <vector115>:
.globl vector115
vector115:
  pushl $0
801063a2:	6a 00                	push   $0x0
  pushl $115
801063a4:	6a 73                	push   $0x73
  jmp alltraps
801063a6:	e9 0b f7 ff ff       	jmp    80105ab6 <alltraps>

801063ab <vector116>:
.globl vector116
vector116:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $116
801063ad:	6a 74                	push   $0x74
  jmp alltraps
801063af:	e9 02 f7 ff ff       	jmp    80105ab6 <alltraps>

801063b4 <vector117>:
.globl vector117
vector117:
  pushl $0
801063b4:	6a 00                	push   $0x0
  pushl $117
801063b6:	6a 75                	push   $0x75
  jmp alltraps
801063b8:	e9 f9 f6 ff ff       	jmp    80105ab6 <alltraps>

801063bd <vector118>:
.globl vector118
vector118:
  pushl $0
801063bd:	6a 00                	push   $0x0
  pushl $118
801063bf:	6a 76                	push   $0x76
  jmp alltraps
801063c1:	e9 f0 f6 ff ff       	jmp    80105ab6 <alltraps>

801063c6 <vector119>:
.globl vector119
vector119:
  pushl $0
801063c6:	6a 00                	push   $0x0
  pushl $119
801063c8:	6a 77                	push   $0x77
  jmp alltraps
801063ca:	e9 e7 f6 ff ff       	jmp    80105ab6 <alltraps>

801063cf <vector120>:
.globl vector120
vector120:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $120
801063d1:	6a 78                	push   $0x78
  jmp alltraps
801063d3:	e9 de f6 ff ff       	jmp    80105ab6 <alltraps>

801063d8 <vector121>:
.globl vector121
vector121:
  pushl $0
801063d8:	6a 00                	push   $0x0
  pushl $121
801063da:	6a 79                	push   $0x79
  jmp alltraps
801063dc:	e9 d5 f6 ff ff       	jmp    80105ab6 <alltraps>

801063e1 <vector122>:
.globl vector122
vector122:
  pushl $0
801063e1:	6a 00                	push   $0x0
  pushl $122
801063e3:	6a 7a                	push   $0x7a
  jmp alltraps
801063e5:	e9 cc f6 ff ff       	jmp    80105ab6 <alltraps>

801063ea <vector123>:
.globl vector123
vector123:
  pushl $0
801063ea:	6a 00                	push   $0x0
  pushl $123
801063ec:	6a 7b                	push   $0x7b
  jmp alltraps
801063ee:	e9 c3 f6 ff ff       	jmp    80105ab6 <alltraps>

801063f3 <vector124>:
.globl vector124
vector124:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $124
801063f5:	6a 7c                	push   $0x7c
  jmp alltraps
801063f7:	e9 ba f6 ff ff       	jmp    80105ab6 <alltraps>

801063fc <vector125>:
.globl vector125
vector125:
  pushl $0
801063fc:	6a 00                	push   $0x0
  pushl $125
801063fe:	6a 7d                	push   $0x7d
  jmp alltraps
80106400:	e9 b1 f6 ff ff       	jmp    80105ab6 <alltraps>

80106405 <vector126>:
.globl vector126
vector126:
  pushl $0
80106405:	6a 00                	push   $0x0
  pushl $126
80106407:	6a 7e                	push   $0x7e
  jmp alltraps
80106409:	e9 a8 f6 ff ff       	jmp    80105ab6 <alltraps>

8010640e <vector127>:
.globl vector127
vector127:
  pushl $0
8010640e:	6a 00                	push   $0x0
  pushl $127
80106410:	6a 7f                	push   $0x7f
  jmp alltraps
80106412:	e9 9f f6 ff ff       	jmp    80105ab6 <alltraps>

80106417 <vector128>:
.globl vector128
vector128:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $128
80106419:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010641e:	e9 93 f6 ff ff       	jmp    80105ab6 <alltraps>

80106423 <vector129>:
.globl vector129
vector129:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $129
80106425:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010642a:	e9 87 f6 ff ff       	jmp    80105ab6 <alltraps>

8010642f <vector130>:
.globl vector130
vector130:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $130
80106431:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106436:	e9 7b f6 ff ff       	jmp    80105ab6 <alltraps>

8010643b <vector131>:
.globl vector131
vector131:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $131
8010643d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106442:	e9 6f f6 ff ff       	jmp    80105ab6 <alltraps>

80106447 <vector132>:
.globl vector132
vector132:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $132
80106449:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010644e:	e9 63 f6 ff ff       	jmp    80105ab6 <alltraps>

80106453 <vector133>:
.globl vector133
vector133:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $133
80106455:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010645a:	e9 57 f6 ff ff       	jmp    80105ab6 <alltraps>

8010645f <vector134>:
.globl vector134
vector134:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $134
80106461:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106466:	e9 4b f6 ff ff       	jmp    80105ab6 <alltraps>

8010646b <vector135>:
.globl vector135
vector135:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $135
8010646d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106472:	e9 3f f6 ff ff       	jmp    80105ab6 <alltraps>

80106477 <vector136>:
.globl vector136
vector136:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $136
80106479:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010647e:	e9 33 f6 ff ff       	jmp    80105ab6 <alltraps>

80106483 <vector137>:
.globl vector137
vector137:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $137
80106485:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010648a:	e9 27 f6 ff ff       	jmp    80105ab6 <alltraps>

8010648f <vector138>:
.globl vector138
vector138:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $138
80106491:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106496:	e9 1b f6 ff ff       	jmp    80105ab6 <alltraps>

8010649b <vector139>:
.globl vector139
vector139:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $139
8010649d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801064a2:	e9 0f f6 ff ff       	jmp    80105ab6 <alltraps>

801064a7 <vector140>:
.globl vector140
vector140:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $140
801064a9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801064ae:	e9 03 f6 ff ff       	jmp    80105ab6 <alltraps>

801064b3 <vector141>:
.globl vector141
vector141:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $141
801064b5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801064ba:	e9 f7 f5 ff ff       	jmp    80105ab6 <alltraps>

801064bf <vector142>:
.globl vector142
vector142:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $142
801064c1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801064c6:	e9 eb f5 ff ff       	jmp    80105ab6 <alltraps>

801064cb <vector143>:
.globl vector143
vector143:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $143
801064cd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801064d2:	e9 df f5 ff ff       	jmp    80105ab6 <alltraps>

801064d7 <vector144>:
.globl vector144
vector144:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $144
801064d9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801064de:	e9 d3 f5 ff ff       	jmp    80105ab6 <alltraps>

801064e3 <vector145>:
.globl vector145
vector145:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $145
801064e5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801064ea:	e9 c7 f5 ff ff       	jmp    80105ab6 <alltraps>

801064ef <vector146>:
.globl vector146
vector146:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $146
801064f1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801064f6:	e9 bb f5 ff ff       	jmp    80105ab6 <alltraps>

801064fb <vector147>:
.globl vector147
vector147:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $147
801064fd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106502:	e9 af f5 ff ff       	jmp    80105ab6 <alltraps>

80106507 <vector148>:
.globl vector148
vector148:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $148
80106509:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010650e:	e9 a3 f5 ff ff       	jmp    80105ab6 <alltraps>

80106513 <vector149>:
.globl vector149
vector149:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $149
80106515:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010651a:	e9 97 f5 ff ff       	jmp    80105ab6 <alltraps>

8010651f <vector150>:
.globl vector150
vector150:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $150
80106521:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106526:	e9 8b f5 ff ff       	jmp    80105ab6 <alltraps>

8010652b <vector151>:
.globl vector151
vector151:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $151
8010652d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106532:	e9 7f f5 ff ff       	jmp    80105ab6 <alltraps>

80106537 <vector152>:
.globl vector152
vector152:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $152
80106539:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010653e:	e9 73 f5 ff ff       	jmp    80105ab6 <alltraps>

80106543 <vector153>:
.globl vector153
vector153:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $153
80106545:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010654a:	e9 67 f5 ff ff       	jmp    80105ab6 <alltraps>

8010654f <vector154>:
.globl vector154
vector154:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $154
80106551:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106556:	e9 5b f5 ff ff       	jmp    80105ab6 <alltraps>

8010655b <vector155>:
.globl vector155
vector155:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $155
8010655d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106562:	e9 4f f5 ff ff       	jmp    80105ab6 <alltraps>

80106567 <vector156>:
.globl vector156
vector156:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $156
80106569:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010656e:	e9 43 f5 ff ff       	jmp    80105ab6 <alltraps>

80106573 <vector157>:
.globl vector157
vector157:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $157
80106575:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010657a:	e9 37 f5 ff ff       	jmp    80105ab6 <alltraps>

8010657f <vector158>:
.globl vector158
vector158:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $158
80106581:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106586:	e9 2b f5 ff ff       	jmp    80105ab6 <alltraps>

8010658b <vector159>:
.globl vector159
vector159:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $159
8010658d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106592:	e9 1f f5 ff ff       	jmp    80105ab6 <alltraps>

80106597 <vector160>:
.globl vector160
vector160:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $160
80106599:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010659e:	e9 13 f5 ff ff       	jmp    80105ab6 <alltraps>

801065a3 <vector161>:
.globl vector161
vector161:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $161
801065a5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801065aa:	e9 07 f5 ff ff       	jmp    80105ab6 <alltraps>

801065af <vector162>:
.globl vector162
vector162:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $162
801065b1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801065b6:	e9 fb f4 ff ff       	jmp    80105ab6 <alltraps>

801065bb <vector163>:
.globl vector163
vector163:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $163
801065bd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801065c2:	e9 ef f4 ff ff       	jmp    80105ab6 <alltraps>

801065c7 <vector164>:
.globl vector164
vector164:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $164
801065c9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801065ce:	e9 e3 f4 ff ff       	jmp    80105ab6 <alltraps>

801065d3 <vector165>:
.globl vector165
vector165:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $165
801065d5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801065da:	e9 d7 f4 ff ff       	jmp    80105ab6 <alltraps>

801065df <vector166>:
.globl vector166
vector166:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $166
801065e1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801065e6:	e9 cb f4 ff ff       	jmp    80105ab6 <alltraps>

801065eb <vector167>:
.globl vector167
vector167:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $167
801065ed:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801065f2:	e9 bf f4 ff ff       	jmp    80105ab6 <alltraps>

801065f7 <vector168>:
.globl vector168
vector168:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $168
801065f9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801065fe:	e9 b3 f4 ff ff       	jmp    80105ab6 <alltraps>

80106603 <vector169>:
.globl vector169
vector169:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $169
80106605:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010660a:	e9 a7 f4 ff ff       	jmp    80105ab6 <alltraps>

8010660f <vector170>:
.globl vector170
vector170:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $170
80106611:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106616:	e9 9b f4 ff ff       	jmp    80105ab6 <alltraps>

8010661b <vector171>:
.globl vector171
vector171:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $171
8010661d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106622:	e9 8f f4 ff ff       	jmp    80105ab6 <alltraps>

80106627 <vector172>:
.globl vector172
vector172:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $172
80106629:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010662e:	e9 83 f4 ff ff       	jmp    80105ab6 <alltraps>

80106633 <vector173>:
.globl vector173
vector173:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $173
80106635:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010663a:	e9 77 f4 ff ff       	jmp    80105ab6 <alltraps>

8010663f <vector174>:
.globl vector174
vector174:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $174
80106641:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106646:	e9 6b f4 ff ff       	jmp    80105ab6 <alltraps>

8010664b <vector175>:
.globl vector175
vector175:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $175
8010664d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106652:	e9 5f f4 ff ff       	jmp    80105ab6 <alltraps>

80106657 <vector176>:
.globl vector176
vector176:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $176
80106659:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010665e:	e9 53 f4 ff ff       	jmp    80105ab6 <alltraps>

80106663 <vector177>:
.globl vector177
vector177:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $177
80106665:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010666a:	e9 47 f4 ff ff       	jmp    80105ab6 <alltraps>

8010666f <vector178>:
.globl vector178
vector178:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $178
80106671:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106676:	e9 3b f4 ff ff       	jmp    80105ab6 <alltraps>

8010667b <vector179>:
.globl vector179
vector179:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $179
8010667d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106682:	e9 2f f4 ff ff       	jmp    80105ab6 <alltraps>

80106687 <vector180>:
.globl vector180
vector180:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $180
80106689:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010668e:	e9 23 f4 ff ff       	jmp    80105ab6 <alltraps>

80106693 <vector181>:
.globl vector181
vector181:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $181
80106695:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010669a:	e9 17 f4 ff ff       	jmp    80105ab6 <alltraps>

8010669f <vector182>:
.globl vector182
vector182:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $182
801066a1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801066a6:	e9 0b f4 ff ff       	jmp    80105ab6 <alltraps>

801066ab <vector183>:
.globl vector183
vector183:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $183
801066ad:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801066b2:	e9 ff f3 ff ff       	jmp    80105ab6 <alltraps>

801066b7 <vector184>:
.globl vector184
vector184:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $184
801066b9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801066be:	e9 f3 f3 ff ff       	jmp    80105ab6 <alltraps>

801066c3 <vector185>:
.globl vector185
vector185:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $185
801066c5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801066ca:	e9 e7 f3 ff ff       	jmp    80105ab6 <alltraps>

801066cf <vector186>:
.globl vector186
vector186:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $186
801066d1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801066d6:	e9 db f3 ff ff       	jmp    80105ab6 <alltraps>

801066db <vector187>:
.globl vector187
vector187:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $187
801066dd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801066e2:	e9 cf f3 ff ff       	jmp    80105ab6 <alltraps>

801066e7 <vector188>:
.globl vector188
vector188:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $188
801066e9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801066ee:	e9 c3 f3 ff ff       	jmp    80105ab6 <alltraps>

801066f3 <vector189>:
.globl vector189
vector189:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $189
801066f5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801066fa:	e9 b7 f3 ff ff       	jmp    80105ab6 <alltraps>

801066ff <vector190>:
.globl vector190
vector190:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $190
80106701:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106706:	e9 ab f3 ff ff       	jmp    80105ab6 <alltraps>

8010670b <vector191>:
.globl vector191
vector191:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $191
8010670d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106712:	e9 9f f3 ff ff       	jmp    80105ab6 <alltraps>

80106717 <vector192>:
.globl vector192
vector192:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $192
80106719:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010671e:	e9 93 f3 ff ff       	jmp    80105ab6 <alltraps>

80106723 <vector193>:
.globl vector193
vector193:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $193
80106725:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010672a:	e9 87 f3 ff ff       	jmp    80105ab6 <alltraps>

8010672f <vector194>:
.globl vector194
vector194:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $194
80106731:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106736:	e9 7b f3 ff ff       	jmp    80105ab6 <alltraps>

8010673b <vector195>:
.globl vector195
vector195:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $195
8010673d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106742:	e9 6f f3 ff ff       	jmp    80105ab6 <alltraps>

80106747 <vector196>:
.globl vector196
vector196:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $196
80106749:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010674e:	e9 63 f3 ff ff       	jmp    80105ab6 <alltraps>

80106753 <vector197>:
.globl vector197
vector197:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $197
80106755:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010675a:	e9 57 f3 ff ff       	jmp    80105ab6 <alltraps>

8010675f <vector198>:
.globl vector198
vector198:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $198
80106761:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106766:	e9 4b f3 ff ff       	jmp    80105ab6 <alltraps>

8010676b <vector199>:
.globl vector199
vector199:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $199
8010676d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106772:	e9 3f f3 ff ff       	jmp    80105ab6 <alltraps>

80106777 <vector200>:
.globl vector200
vector200:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $200
80106779:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010677e:	e9 33 f3 ff ff       	jmp    80105ab6 <alltraps>

80106783 <vector201>:
.globl vector201
vector201:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $201
80106785:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010678a:	e9 27 f3 ff ff       	jmp    80105ab6 <alltraps>

8010678f <vector202>:
.globl vector202
vector202:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $202
80106791:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106796:	e9 1b f3 ff ff       	jmp    80105ab6 <alltraps>

8010679b <vector203>:
.globl vector203
vector203:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $203
8010679d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801067a2:	e9 0f f3 ff ff       	jmp    80105ab6 <alltraps>

801067a7 <vector204>:
.globl vector204
vector204:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $204
801067a9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801067ae:	e9 03 f3 ff ff       	jmp    80105ab6 <alltraps>

801067b3 <vector205>:
.globl vector205
vector205:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $205
801067b5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801067ba:	e9 f7 f2 ff ff       	jmp    80105ab6 <alltraps>

801067bf <vector206>:
.globl vector206
vector206:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $206
801067c1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801067c6:	e9 eb f2 ff ff       	jmp    80105ab6 <alltraps>

801067cb <vector207>:
.globl vector207
vector207:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $207
801067cd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801067d2:	e9 df f2 ff ff       	jmp    80105ab6 <alltraps>

801067d7 <vector208>:
.globl vector208
vector208:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $208
801067d9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801067de:	e9 d3 f2 ff ff       	jmp    80105ab6 <alltraps>

801067e3 <vector209>:
.globl vector209
vector209:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $209
801067e5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801067ea:	e9 c7 f2 ff ff       	jmp    80105ab6 <alltraps>

801067ef <vector210>:
.globl vector210
vector210:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $210
801067f1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801067f6:	e9 bb f2 ff ff       	jmp    80105ab6 <alltraps>

801067fb <vector211>:
.globl vector211
vector211:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $211
801067fd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106802:	e9 af f2 ff ff       	jmp    80105ab6 <alltraps>

80106807 <vector212>:
.globl vector212
vector212:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $212
80106809:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010680e:	e9 a3 f2 ff ff       	jmp    80105ab6 <alltraps>

80106813 <vector213>:
.globl vector213
vector213:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $213
80106815:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010681a:	e9 97 f2 ff ff       	jmp    80105ab6 <alltraps>

8010681f <vector214>:
.globl vector214
vector214:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $214
80106821:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106826:	e9 8b f2 ff ff       	jmp    80105ab6 <alltraps>

8010682b <vector215>:
.globl vector215
vector215:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $215
8010682d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106832:	e9 7f f2 ff ff       	jmp    80105ab6 <alltraps>

80106837 <vector216>:
.globl vector216
vector216:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $216
80106839:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010683e:	e9 73 f2 ff ff       	jmp    80105ab6 <alltraps>

80106843 <vector217>:
.globl vector217
vector217:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $217
80106845:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010684a:	e9 67 f2 ff ff       	jmp    80105ab6 <alltraps>

8010684f <vector218>:
.globl vector218
vector218:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $218
80106851:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106856:	e9 5b f2 ff ff       	jmp    80105ab6 <alltraps>

8010685b <vector219>:
.globl vector219
vector219:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $219
8010685d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106862:	e9 4f f2 ff ff       	jmp    80105ab6 <alltraps>

80106867 <vector220>:
.globl vector220
vector220:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $220
80106869:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010686e:	e9 43 f2 ff ff       	jmp    80105ab6 <alltraps>

80106873 <vector221>:
.globl vector221
vector221:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $221
80106875:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010687a:	e9 37 f2 ff ff       	jmp    80105ab6 <alltraps>

8010687f <vector222>:
.globl vector222
vector222:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $222
80106881:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106886:	e9 2b f2 ff ff       	jmp    80105ab6 <alltraps>

8010688b <vector223>:
.globl vector223
vector223:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $223
8010688d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106892:	e9 1f f2 ff ff       	jmp    80105ab6 <alltraps>

80106897 <vector224>:
.globl vector224
vector224:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $224
80106899:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010689e:	e9 13 f2 ff ff       	jmp    80105ab6 <alltraps>

801068a3 <vector225>:
.globl vector225
vector225:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $225
801068a5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801068aa:	e9 07 f2 ff ff       	jmp    80105ab6 <alltraps>

801068af <vector226>:
.globl vector226
vector226:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $226
801068b1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801068b6:	e9 fb f1 ff ff       	jmp    80105ab6 <alltraps>

801068bb <vector227>:
.globl vector227
vector227:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $227
801068bd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801068c2:	e9 ef f1 ff ff       	jmp    80105ab6 <alltraps>

801068c7 <vector228>:
.globl vector228
vector228:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $228
801068c9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801068ce:	e9 e3 f1 ff ff       	jmp    80105ab6 <alltraps>

801068d3 <vector229>:
.globl vector229
vector229:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $229
801068d5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801068da:	e9 d7 f1 ff ff       	jmp    80105ab6 <alltraps>

801068df <vector230>:
.globl vector230
vector230:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $230
801068e1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801068e6:	e9 cb f1 ff ff       	jmp    80105ab6 <alltraps>

801068eb <vector231>:
.globl vector231
vector231:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $231
801068ed:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801068f2:	e9 bf f1 ff ff       	jmp    80105ab6 <alltraps>

801068f7 <vector232>:
.globl vector232
vector232:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $232
801068f9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801068fe:	e9 b3 f1 ff ff       	jmp    80105ab6 <alltraps>

80106903 <vector233>:
.globl vector233
vector233:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $233
80106905:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010690a:	e9 a7 f1 ff ff       	jmp    80105ab6 <alltraps>

8010690f <vector234>:
.globl vector234
vector234:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $234
80106911:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106916:	e9 9b f1 ff ff       	jmp    80105ab6 <alltraps>

8010691b <vector235>:
.globl vector235
vector235:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $235
8010691d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106922:	e9 8f f1 ff ff       	jmp    80105ab6 <alltraps>

80106927 <vector236>:
.globl vector236
vector236:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $236
80106929:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010692e:	e9 83 f1 ff ff       	jmp    80105ab6 <alltraps>

80106933 <vector237>:
.globl vector237
vector237:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $237
80106935:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010693a:	e9 77 f1 ff ff       	jmp    80105ab6 <alltraps>

8010693f <vector238>:
.globl vector238
vector238:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $238
80106941:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106946:	e9 6b f1 ff ff       	jmp    80105ab6 <alltraps>

8010694b <vector239>:
.globl vector239
vector239:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $239
8010694d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106952:	e9 5f f1 ff ff       	jmp    80105ab6 <alltraps>

80106957 <vector240>:
.globl vector240
vector240:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $240
80106959:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010695e:	e9 53 f1 ff ff       	jmp    80105ab6 <alltraps>

80106963 <vector241>:
.globl vector241
vector241:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $241
80106965:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010696a:	e9 47 f1 ff ff       	jmp    80105ab6 <alltraps>

8010696f <vector242>:
.globl vector242
vector242:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $242
80106971:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106976:	e9 3b f1 ff ff       	jmp    80105ab6 <alltraps>

8010697b <vector243>:
.globl vector243
vector243:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $243
8010697d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106982:	e9 2f f1 ff ff       	jmp    80105ab6 <alltraps>

80106987 <vector244>:
.globl vector244
vector244:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $244
80106989:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010698e:	e9 23 f1 ff ff       	jmp    80105ab6 <alltraps>

80106993 <vector245>:
.globl vector245
vector245:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $245
80106995:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010699a:	e9 17 f1 ff ff       	jmp    80105ab6 <alltraps>

8010699f <vector246>:
.globl vector246
vector246:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $246
801069a1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801069a6:	e9 0b f1 ff ff       	jmp    80105ab6 <alltraps>

801069ab <vector247>:
.globl vector247
vector247:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $247
801069ad:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801069b2:	e9 ff f0 ff ff       	jmp    80105ab6 <alltraps>

801069b7 <vector248>:
.globl vector248
vector248:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $248
801069b9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801069be:	e9 f3 f0 ff ff       	jmp    80105ab6 <alltraps>

801069c3 <vector249>:
.globl vector249
vector249:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $249
801069c5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801069ca:	e9 e7 f0 ff ff       	jmp    80105ab6 <alltraps>

801069cf <vector250>:
.globl vector250
vector250:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $250
801069d1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801069d6:	e9 db f0 ff ff       	jmp    80105ab6 <alltraps>

801069db <vector251>:
.globl vector251
vector251:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $251
801069dd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801069e2:	e9 cf f0 ff ff       	jmp    80105ab6 <alltraps>

801069e7 <vector252>:
.globl vector252
vector252:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $252
801069e9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801069ee:	e9 c3 f0 ff ff       	jmp    80105ab6 <alltraps>

801069f3 <vector253>:
.globl vector253
vector253:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $253
801069f5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801069fa:	e9 b7 f0 ff ff       	jmp    80105ab6 <alltraps>

801069ff <vector254>:
.globl vector254
vector254:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $254
80106a01:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106a06:	e9 ab f0 ff ff       	jmp    80105ab6 <alltraps>

80106a0b <vector255>:
.globl vector255
vector255:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $255
80106a0d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106a12:	e9 9f f0 ff ff       	jmp    80105ab6 <alltraps>
80106a17:	66 90                	xchg   %ax,%ax
80106a19:	66 90                	xchg   %ax,%ax
80106a1b:	66 90                	xchg   %ax,%ax
80106a1d:	66 90                	xchg   %ax,%ax
80106a1f:	90                   	nop

80106a20 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t* pgdir, uint oldsz, uint newsz) {
80106a20:	55                   	push   %ebp
80106a21:	89 e5                	mov    %esp,%ebp
80106a23:	57                   	push   %edi
80106a24:	89 cf                	mov    %ecx,%edi
80106a26:	56                   	push   %esi
80106a27:	53                   	push   %ebx
    uint a, pa;

    if (newsz >= oldsz)
        return oldsz;

    a = PGROUNDUP(newsz);
80106a28:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106a2e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t* pgdir, uint oldsz, uint newsz) {
80106a34:	83 ec 1c             	sub    $0x1c,%esp
80106a37:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for (; a < oldsz; a += PGSIZE) {
80106a3a:	39 d3                	cmp    %edx,%ebx
80106a3c:	0f 83 8f 00 00 00    	jae    80106ad1 <deallocuvm.part.0+0xb1>
80106a42:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80106a45:	89 d7                	mov    %edx,%edi
80106a47:	eb 13                	jmp    80106a5c <deallocuvm.part.0+0x3c>
80106a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        pte = walkpgdir(pgdir, (char*) a, 0);
        if (!pte)
            a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106a50:	83 c2 01             	add    $0x1,%edx
80106a53:	89 d3                	mov    %edx,%ebx
80106a55:	c1 e3 16             	shl    $0x16,%ebx
    for (; a < oldsz; a += PGSIZE) {
80106a58:	39 fb                	cmp    %edi,%ebx
80106a5a:	73 72                	jae    80106ace <deallocuvm.part.0+0xae>
    if (*pde & PTE_P) {
80106a5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    pde = &pgdir[PDX(va)];
80106a5f:	89 da                	mov    %ebx,%edx
80106a61:	c1 ea 16             	shr    $0x16,%edx
    if (*pde & PTE_P) {
80106a64:	8b 04 90             	mov    (%eax,%edx,4),%eax
80106a67:	a8 01                	test   $0x1,%al
80106a69:	74 e5                	je     80106a50 <deallocuvm.part.0+0x30>
    return &pgtab[PTX(va)];
80106a6b:	89 d9                	mov    %ebx,%ecx
        pgtab = (pte_t*) P2V(PTE_ADDR(*pde));
80106a6d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    return &pgtab[PTX(va)];
80106a72:	c1 e9 0a             	shr    $0xa,%ecx
80106a75:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106a7b:	8d b4 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%esi
        if (!pte)
80106a82:	85 f6                	test   %esi,%esi
80106a84:	74 ca                	je     80106a50 <deallocuvm.part.0+0x30>
        else if ((*pte & PTE_P) != 0) {
80106a86:	8b 16                	mov    (%esi),%edx
80106a88:	f6 c2 01             	test   $0x1,%dl
80106a8b:	74 37                	je     80106ac4 <deallocuvm.part.0+0xa4>
            pa = PTE_ADDR(*pte);
            if (pa == 0)
80106a8d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106a93:	74 59                	je     80106aee <deallocuvm.part.0+0xce>
                panic("kfree");
            char* v = P2V(pa);
80106a95:	81 c2 00 00 00 80    	add    $0x80000000,%edx

            if (getRefs(v) == 1)
80106a9b:	83 ec 0c             	sub    $0xc,%esp
80106a9e:	52                   	push   %edx
80106a9f:	89 55 e0             	mov    %edx,-0x20(%ebp)
80106aa2:	e8 39 be ff ff       	call   801028e0 <getRefs>
80106aa7:	83 c4 10             	add    $0x10,%esp
80106aaa:	8b 55 e0             	mov    -0x20(%ebp),%edx
80106aad:	83 f8 01             	cmp    $0x1,%eax
80106ab0:	74 2e                	je     80106ae0 <deallocuvm.part.0+0xc0>
                kfree(v);
            else
                kdec(v);
80106ab2:	83 ec 0c             	sub    $0xc,%esp
80106ab5:	52                   	push   %edx
80106ab6:	e8 b5 bd ff ff       	call   80102870 <kdec>
80106abb:	83 c4 10             	add    $0x10,%esp
            *pte = 0;
80106abe:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
    for (; a < oldsz; a += PGSIZE) {
80106ac4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106aca:	39 fb                	cmp    %edi,%ebx
80106acc:	72 8e                	jb     80106a5c <deallocuvm.part.0+0x3c>
80106ace:	8b 7d dc             	mov    -0x24(%ebp),%edi
        }
    }
    return newsz;
}
80106ad1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ad4:	89 f8                	mov    %edi,%eax
80106ad6:	5b                   	pop    %ebx
80106ad7:	5e                   	pop    %esi
80106ad8:	5f                   	pop    %edi
80106ad9:	5d                   	pop    %ebp
80106ada:	c3                   	ret
80106adb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106adf:	90                   	nop
                kfree(v);
80106ae0:	83 ec 0c             	sub    $0xc,%esp
80106ae3:	52                   	push   %edx
80106ae4:	e8 57 ba ff ff       	call   80102540 <kfree>
80106ae9:	83 c4 10             	add    $0x10,%esp
80106aec:	eb d0                	jmp    80106abe <deallocuvm.part.0+0x9e>
                panic("kfree");
80106aee:	83 ec 0c             	sub    $0xc,%esp
80106af1:	68 26 79 10 80       	push   $0x80107926
80106af6:	e8 85 98 ff ff       	call   80100380 <panic>
80106afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106aff:	90                   	nop

80106b00 <mappages>:
mappages(pde_t* pgdir, void* va, uint size, uint pa, int perm) {
80106b00:	55                   	push   %ebp
80106b01:	89 e5                	mov    %esp,%ebp
80106b03:	57                   	push   %edi
80106b04:	56                   	push   %esi
80106b05:	53                   	push   %ebx
    a = (char*) PGROUNDDOWN((uint) va);
80106b06:	89 d3                	mov    %edx,%ebx
80106b08:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
mappages(pde_t* pgdir, void* va, uint size, uint pa, int perm) {
80106b0e:	83 ec 1c             	sub    $0x1c,%esp
80106b11:	89 45 e0             	mov    %eax,-0x20(%ebp)
    last = (char*) PGROUNDDOWN(((uint) va) + size - 1);
80106b14:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106b18:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b1d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106b20:	8b 45 08             	mov    0x8(%ebp),%eax
80106b23:	29 d8                	sub    %ebx,%eax
80106b25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b28:	eb 3f                	jmp    80106b69 <mappages+0x69>
80106b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return &pgtab[PTX(va)];
80106b30:	89 da                	mov    %ebx,%edx
        pgtab = (pte_t*) P2V(PTE_ADDR(*pde));
80106b32:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    return &pgtab[PTX(va)];
80106b37:	c1 ea 0a             	shr    $0xa,%edx
80106b3a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106b40:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
        if ((pte = walkpgdir(pgdir, a, 1)) == 0)
80106b47:	85 c0                	test   %eax,%eax
80106b49:	74 75                	je     80106bc0 <mappages+0xc0>
        if (*pte & PTE_P)
80106b4b:	f6 00 01             	testb  $0x1,(%eax)
80106b4e:	0f 85 86 00 00 00    	jne    80106bda <mappages+0xda>
        *pte = pa | perm | PTE_P;
80106b54:	0b 75 0c             	or     0xc(%ebp),%esi
80106b57:	83 ce 01             	or     $0x1,%esi
80106b5a:	89 30                	mov    %esi,(%eax)
        if (a == last)
80106b5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106b5f:	39 c3                	cmp    %eax,%ebx
80106b61:	74 6d                	je     80106bd0 <mappages+0xd0>
        a += PGSIZE;
80106b63:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    for (;;) {
80106b69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    pde = &pgdir[PDX(va)];
80106b6c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106b6f:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80106b72:	89 d8                	mov    %ebx,%eax
80106b74:	c1 e8 16             	shr    $0x16,%eax
80106b77:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
    if (*pde & PTE_P) {
80106b7a:	8b 07                	mov    (%edi),%eax
80106b7c:	a8 01                	test   $0x1,%al
80106b7e:	75 b0                	jne    80106b30 <mappages+0x30>
        if (!alloc || (pgtab = (pte_t*) kalloc()) == 0)
80106b80:	e8 cb bb ff ff       	call   80102750 <kalloc>
80106b85:	85 c0                	test   %eax,%eax
80106b87:	74 37                	je     80106bc0 <mappages+0xc0>
        memset(pgtab, 0, PGSIZE);
80106b89:	83 ec 04             	sub    $0x4,%esp
80106b8c:	68 00 10 00 00       	push   $0x1000
80106b91:	6a 00                	push   $0x0
80106b93:	50                   	push   %eax
80106b94:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106b97:	e8 04 dd ff ff       	call   801048a0 <memset>
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b9c:	8b 55 d8             	mov    -0x28(%ebp),%edx
    return &pgtab[PTX(va)];
80106b9f:	83 c4 10             	add    $0x10,%esp
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106ba2:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106ba8:	83 c8 07             	or     $0x7,%eax
80106bab:	89 07                	mov    %eax,(%edi)
    return &pgtab[PTX(va)];
80106bad:	89 d8                	mov    %ebx,%eax
80106baf:	c1 e8 0a             	shr    $0xa,%eax
80106bb2:	25 fc 0f 00 00       	and    $0xffc,%eax
80106bb7:	01 d0                	add    %edx,%eax
80106bb9:	eb 90                	jmp    80106b4b <mappages+0x4b>
80106bbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106bbf:	90                   	nop
}
80106bc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
80106bc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106bc8:	5b                   	pop    %ebx
80106bc9:	5e                   	pop    %esi
80106bca:	5f                   	pop    %edi
80106bcb:	5d                   	pop    %ebp
80106bcc:	c3                   	ret
80106bcd:	8d 76 00             	lea    0x0(%esi),%esi
80106bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106bd3:	31 c0                	xor    %eax,%eax
}
80106bd5:	5b                   	pop    %ebx
80106bd6:	5e                   	pop    %esi
80106bd7:	5f                   	pop    %edi
80106bd8:	5d                   	pop    %ebp
80106bd9:	c3                   	ret
            panic("remap");
80106bda:	83 ec 0c             	sub    $0xc,%esp
80106bdd:	68 d4 7f 10 80       	push   $0x80107fd4
80106be2:	e8 99 97 ff ff       	call   80100380 <panic>
80106be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bee:	66 90                	xchg   %ax,%ax

80106bf0 <seginit>:
seginit(void) {
80106bf0:	55                   	push   %ebp
80106bf1:	89 e5                	mov    %esp,%ebp
80106bf3:	83 ec 18             	sub    $0x18,%esp
    c = &cpus[cpuid()];
80106bf6:	e8 75 cf ff ff       	call   80103b70 <cpuid>
  pd[0] = size-1;
80106bfb:	ba 2f 00 00 00       	mov    $0x2f,%edx
    c->gdt[SEG_KCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, 0);
80106c00:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106c06:	c7 80 38 28 18 80 ff 	movl   $0xffff,-0x7fe7d7c8(%eax)
80106c0d:	ff 00 00 
    c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106c10:	c7 80 40 28 18 80 ff 	movl   $0xffff,-0x7fe7d7c0(%eax)
80106c17:	ff 00 00 
    c->gdt[SEG_UCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, DPL_USER);
80106c1a:	c7 80 48 28 18 80 ff 	movl   $0xffff,-0x7fe7d7b8(%eax)
80106c21:	ff 00 00 
    c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106c24:	c7 80 50 28 18 80 ff 	movl   $0xffff,-0x7fe7d7b0(%eax)
80106c2b:	ff 00 00 
    c->gdt[SEG_KCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, 0);
80106c2e:	c7 80 3c 28 18 80 00 	movl   $0xcf9a00,-0x7fe7d7c4(%eax)
80106c35:	9a cf 00 
    c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106c38:	c7 80 44 28 18 80 00 	movl   $0xcf9200,-0x7fe7d7bc(%eax)
80106c3f:	92 cf 00 
    c->gdt[SEG_UCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, DPL_USER);
80106c42:	c7 80 4c 28 18 80 00 	movl   $0xcffa00,-0x7fe7d7b4(%eax)
80106c49:	fa cf 00 
    c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106c4c:	c7 80 54 28 18 80 00 	movl   $0xcff200,-0x7fe7d7ac(%eax)
80106c53:	f2 cf 00 
    lgdt(c->gdt, sizeof(c->gdt));
80106c56:	05 30 28 18 80       	add    $0x80182830,%eax
80106c5b:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80106c5f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106c63:	c1 e8 10             	shr    $0x10,%eax
80106c66:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106c6a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106c6d:	0f 01 10             	lgdtl  (%eax)
}
80106c70:	c9                   	leave
80106c71:	c3                   	ret
80106c72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c80 <switchkvm>:
    lcr3(V2P(kpgdir));   // switch to the kernel page table
80106c80:	a1 e4 54 18 80       	mov    0x801854e4,%eax
80106c85:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106c8a:	0f 22 d8             	mov    %eax,%cr3
}
80106c8d:	c3                   	ret
80106c8e:	66 90                	xchg   %ax,%ax

80106c90 <switchuvm>:
switchuvm(struct proc* p) {
80106c90:	55                   	push   %ebp
80106c91:	89 e5                	mov    %esp,%ebp
80106c93:	57                   	push   %edi
80106c94:	56                   	push   %esi
80106c95:	53                   	push   %ebx
80106c96:	83 ec 1c             	sub    $0x1c,%esp
80106c99:	8b 75 08             	mov    0x8(%ebp),%esi
    if (p == 0)
80106c9c:	85 f6                	test   %esi,%esi
80106c9e:	0f 84 cb 00 00 00    	je     80106d6f <switchuvm+0xdf>
    if (p->kstack == 0)
80106ca4:	8b 46 08             	mov    0x8(%esi),%eax
80106ca7:	85 c0                	test   %eax,%eax
80106ca9:	0f 84 da 00 00 00    	je     80106d89 <switchuvm+0xf9>
    if (p->pgdir == 0)
80106caf:	8b 46 04             	mov    0x4(%esi),%eax
80106cb2:	85 c0                	test   %eax,%eax
80106cb4:	0f 84 c2 00 00 00    	je     80106d7c <switchuvm+0xec>
    pushcli();
80106cba:	e8 01 da ff ff       	call   801046c0 <pushcli>
    mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106cbf:	e8 4c ce ff ff       	call   80103b10 <mycpu>
80106cc4:	89 c3                	mov    %eax,%ebx
80106cc6:	e8 45 ce ff ff       	call   80103b10 <mycpu>
80106ccb:	89 c7                	mov    %eax,%edi
80106ccd:	e8 3e ce ff ff       	call   80103b10 <mycpu>
80106cd2:	83 c7 08             	add    $0x8,%edi
80106cd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106cd8:	e8 33 ce ff ff       	call   80103b10 <mycpu>
80106cdd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106ce0:	ba 67 00 00 00       	mov    $0x67,%edx
80106ce5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106cec:	83 c0 08             	add    $0x8,%eax
80106cef:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
    mycpu()->ts.iomb = (ushort) 0xFFFF;
80106cf6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
    mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106cfb:	83 c1 08             	add    $0x8,%ecx
80106cfe:	c1 e8 18             	shr    $0x18,%eax
80106d01:	c1 e9 10             	shr    $0x10,%ecx
80106d04:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106d0a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106d10:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106d15:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
    mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d1c:	bb 10 00 00 00       	mov    $0x10,%ebx
    mycpu()->gdt[SEG_TSS].s = 0;
80106d21:	e8 ea cd ff ff       	call   80103b10 <mycpu>
80106d26:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
    mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d2d:	e8 de cd ff ff       	call   80103b10 <mycpu>
80106d32:	66 89 58 10          	mov    %bx,0x10(%eax)
    mycpu()->ts.esp0 = (uint) p->kstack + KSTACKSIZE;
80106d36:	8b 5e 08             	mov    0x8(%esi),%ebx
80106d39:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d3f:	e8 cc cd ff ff       	call   80103b10 <mycpu>
80106d44:	89 58 0c             	mov    %ebx,0xc(%eax)
    mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d47:	e8 c4 cd ff ff       	call   80103b10 <mycpu>
80106d4c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106d50:	b8 28 00 00 00       	mov    $0x28,%eax
80106d55:	0f 00 d8             	ltr    %ax
    lcr3(V2P(p->pgdir));  // switch to process's address space
80106d58:	8b 46 04             	mov    0x4(%esi),%eax
80106d5b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d60:	0f 22 d8             	mov    %eax,%cr3
}
80106d63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d66:	5b                   	pop    %ebx
80106d67:	5e                   	pop    %esi
80106d68:	5f                   	pop    %edi
80106d69:	5d                   	pop    %ebp
    popcli();
80106d6a:	e9 81 da ff ff       	jmp    801047f0 <popcli>
        panic("switchuvm: no process");
80106d6f:	83 ec 0c             	sub    $0xc,%esp
80106d72:	68 da 7f 10 80       	push   $0x80107fda
80106d77:	e8 04 96 ff ff       	call   80100380 <panic>
        panic("switchuvm: no pgdir");
80106d7c:	83 ec 0c             	sub    $0xc,%esp
80106d7f:	68 05 80 10 80       	push   $0x80108005
80106d84:	e8 f7 95 ff ff       	call   80100380 <panic>
        panic("switchuvm: no kstack");
80106d89:	83 ec 0c             	sub    $0xc,%esp
80106d8c:	68 f0 7f 10 80       	push   $0x80107ff0
80106d91:	e8 ea 95 ff ff       	call   80100380 <panic>
80106d96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d9d:	8d 76 00             	lea    0x0(%esi),%esi

80106da0 <inituvm>:
inituvm(pde_t* pgdir, char* init, uint sz) {
80106da0:	55                   	push   %ebp
80106da1:	89 e5                	mov    %esp,%ebp
80106da3:	57                   	push   %edi
80106da4:	56                   	push   %esi
80106da5:	53                   	push   %ebx
80106da6:	83 ec 1c             	sub    $0x1c,%esp
80106da9:	8b 45 08             	mov    0x8(%ebp),%eax
80106dac:	8b 75 10             	mov    0x10(%ebp),%esi
80106daf:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106db2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (sz >= PGSIZE)
80106db5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106dbb:	77 49                	ja     80106e06 <inituvm+0x66>
    mem = kalloc();
80106dbd:	e8 8e b9 ff ff       	call   80102750 <kalloc>
    memset(mem, 0, PGSIZE);
80106dc2:	83 ec 04             	sub    $0x4,%esp
80106dc5:	68 00 10 00 00       	push   $0x1000
    mem = kalloc();
80106dca:	89 c3                	mov    %eax,%ebx
    memset(mem, 0, PGSIZE);
80106dcc:	6a 00                	push   $0x0
80106dce:	50                   	push   %eax
80106dcf:	e8 cc da ff ff       	call   801048a0 <memset>
    mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W | PTE_U);
80106dd4:	58                   	pop    %eax
80106dd5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ddb:	5a                   	pop    %edx
80106ddc:	6a 06                	push   $0x6
80106dde:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106de3:	31 d2                	xor    %edx,%edx
80106de5:	50                   	push   %eax
80106de6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106de9:	e8 12 fd ff ff       	call   80106b00 <mappages>
    memmove(mem, init, sz);
80106dee:	89 75 10             	mov    %esi,0x10(%ebp)
80106df1:	83 c4 10             	add    $0x10,%esp
80106df4:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106df7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106dfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106dfd:	5b                   	pop    %ebx
80106dfe:	5e                   	pop    %esi
80106dff:	5f                   	pop    %edi
80106e00:	5d                   	pop    %ebp
    memmove(mem, init, sz);
80106e01:	e9 2a db ff ff       	jmp    80104930 <memmove>
        panic("inituvm: more than a page");
80106e06:	83 ec 0c             	sub    $0xc,%esp
80106e09:	68 19 80 10 80       	push   $0x80108019
80106e0e:	e8 6d 95 ff ff       	call   80100380 <panic>
80106e13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e20 <loaduvm>:
loaduvm(pde_t* pgdir, char* addr, struct inode* ip, uint offset, uint sz) {
80106e20:	55                   	push   %ebp
80106e21:	89 e5                	mov    %esp,%ebp
80106e23:	57                   	push   %edi
80106e24:	56                   	push   %esi
80106e25:	53                   	push   %ebx
80106e26:	83 ec 0c             	sub    $0xc,%esp
    if ((uint) addr % PGSIZE != 0)
80106e29:	8b 75 0c             	mov    0xc(%ebp),%esi
loaduvm(pde_t* pgdir, char* addr, struct inode* ip, uint offset, uint sz) {
80106e2c:	8b 7d 18             	mov    0x18(%ebp),%edi
    if ((uint) addr % PGSIZE != 0)
80106e2f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106e35:	0f 85 a2 00 00 00    	jne    80106edd <loaduvm+0xbd>
    for (i = 0; i < sz; i += PGSIZE) {
80106e3b:	85 ff                	test   %edi,%edi
80106e3d:	74 7d                	je     80106ebc <loaduvm+0x9c>
80106e3f:	90                   	nop
    pde = &pgdir[PDX(va)];
80106e40:	8b 45 0c             	mov    0xc(%ebp),%eax
    if (*pde & PTE_P) {
80106e43:	8b 55 08             	mov    0x8(%ebp),%edx
80106e46:	01 f0                	add    %esi,%eax
    pde = &pgdir[PDX(va)];
80106e48:	89 c1                	mov    %eax,%ecx
80106e4a:	c1 e9 16             	shr    $0x16,%ecx
    if (*pde & PTE_P) {
80106e4d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80106e50:	f6 c1 01             	test   $0x1,%cl
80106e53:	75 13                	jne    80106e68 <loaduvm+0x48>
            panic("loaduvm: address should exist");
80106e55:	83 ec 0c             	sub    $0xc,%esp
80106e58:	68 33 80 10 80       	push   $0x80108033
80106e5d:	e8 1e 95 ff ff       	call   80100380 <panic>
80106e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return &pgtab[PTX(va)];
80106e68:	c1 e8 0a             	shr    $0xa,%eax
        pgtab = (pte_t*) P2V(PTE_ADDR(*pde));
80106e6b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
    return &pgtab[PTX(va)];
80106e71:	25 fc 0f 00 00       	and    $0xffc,%eax
80106e76:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
        if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0)
80106e7d:	85 c9                	test   %ecx,%ecx
80106e7f:	74 d4                	je     80106e55 <loaduvm+0x35>
        if (sz - i < PGSIZE)
80106e81:	89 fb                	mov    %edi,%ebx
80106e83:	b8 00 10 00 00       	mov    $0x1000,%eax
80106e88:	29 f3                	sub    %esi,%ebx
80106e8a:	39 c3                	cmp    %eax,%ebx
80106e8c:	0f 47 d8             	cmova  %eax,%ebx
        if (readi(ip, P2V(pa), offset + i, n) != n)
80106e8f:	53                   	push   %ebx
80106e90:	8b 45 14             	mov    0x14(%ebp),%eax
80106e93:	01 f0                	add    %esi,%eax
80106e95:	50                   	push   %eax
        pa = PTE_ADDR(*pte);
80106e96:	8b 01                	mov    (%ecx),%eax
80106e98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
        if (readi(ip, P2V(pa), offset + i, n) != n)
80106e9d:	05 00 00 00 80       	add    $0x80000000,%eax
80106ea2:	50                   	push   %eax
80106ea3:	ff 75 10             	push   0x10(%ebp)
80106ea6:	e8 55 ac ff ff       	call   80101b00 <readi>
80106eab:	83 c4 10             	add    $0x10,%esp
80106eae:	39 d8                	cmp    %ebx,%eax
80106eb0:	75 1e                	jne    80106ed0 <loaduvm+0xb0>
    for (i = 0; i < sz; i += PGSIZE) {
80106eb2:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106eb8:	39 fe                	cmp    %edi,%esi
80106eba:	72 84                	jb     80106e40 <loaduvm+0x20>
}
80106ebc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106ebf:	31 c0                	xor    %eax,%eax
}
80106ec1:	5b                   	pop    %ebx
80106ec2:	5e                   	pop    %esi
80106ec3:	5f                   	pop    %edi
80106ec4:	5d                   	pop    %ebp
80106ec5:	c3                   	ret
80106ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ecd:	8d 76 00             	lea    0x0(%esi),%esi
80106ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
80106ed3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ed8:	5b                   	pop    %ebx
80106ed9:	5e                   	pop    %esi
80106eda:	5f                   	pop    %edi
80106edb:	5d                   	pop    %ebp
80106edc:	c3                   	ret
        panic("loaduvm: addr must be page aligned");
80106edd:	83 ec 0c             	sub    $0xc,%esp
80106ee0:	68 08 81 10 80       	push   $0x80108108
80106ee5:	e8 96 94 ff ff       	call   80100380 <panic>
80106eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ef0 <allocuvm>:
allocuvm(pde_t* pgdir, uint oldsz, uint newsz) {
80106ef0:	55                   	push   %ebp
80106ef1:	89 e5                	mov    %esp,%ebp
80106ef3:	57                   	push   %edi
80106ef4:	56                   	push   %esi
80106ef5:	53                   	push   %ebx
80106ef6:	83 ec 1c             	sub    $0x1c,%esp
80106ef9:	8b 75 10             	mov    0x10(%ebp),%esi
    if (newsz >= KERNBASE)
80106efc:	85 f6                	test   %esi,%esi
80106efe:	0f 88 98 00 00 00    	js     80106f9c <allocuvm+0xac>
80106f04:	89 f2                	mov    %esi,%edx
    if (newsz < oldsz)
80106f06:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106f09:	0f 82 a1 00 00 00    	jb     80106fb0 <allocuvm+0xc0>
    a = PGROUNDUP(oldsz);
80106f0f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f12:	05 ff 0f 00 00       	add    $0xfff,%eax
80106f17:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f1c:	89 c7                	mov    %eax,%edi
    for (; a < newsz; a += PGSIZE) {
80106f1e:	39 f0                	cmp    %esi,%eax
80106f20:	0f 83 8d 00 00 00    	jae    80106fb3 <allocuvm+0xc3>
80106f26:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80106f29:	eb 44                	jmp    80106f6f <allocuvm+0x7f>
80106f2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f2f:	90                   	nop
        memset(mem, 0, PGSIZE);
80106f30:	83 ec 04             	sub    $0x4,%esp
80106f33:	68 00 10 00 00       	push   $0x1000
80106f38:	6a 00                	push   $0x0
80106f3a:	50                   	push   %eax
80106f3b:	e8 60 d9 ff ff       	call   801048a0 <memset>
        if (mappages(pgdir, (char*) a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
80106f40:	58                   	pop    %eax
80106f41:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f47:	5a                   	pop    %edx
80106f48:	6a 06                	push   $0x6
80106f4a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f4f:	89 fa                	mov    %edi,%edx
80106f51:	50                   	push   %eax
80106f52:	8b 45 08             	mov    0x8(%ebp),%eax
80106f55:	e8 a6 fb ff ff       	call   80106b00 <mappages>
80106f5a:	83 c4 10             	add    $0x10,%esp
80106f5d:	85 c0                	test   %eax,%eax
80106f5f:	78 5f                	js     80106fc0 <allocuvm+0xd0>
    for (; a < newsz; a += PGSIZE) {
80106f61:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106f67:	39 f7                	cmp    %esi,%edi
80106f69:	0f 83 89 00 00 00    	jae    80106ff8 <allocuvm+0x108>
        mem = kalloc();
80106f6f:	e8 dc b7 ff ff       	call   80102750 <kalloc>
80106f74:	89 c3                	mov    %eax,%ebx
        if (mem == 0) {
80106f76:	85 c0                	test   %eax,%eax
80106f78:	75 b6                	jne    80106f30 <allocuvm+0x40>
            cprintf("allocuvm out of memory\n");
80106f7a:	83 ec 0c             	sub    $0xc,%esp
80106f7d:	68 51 80 10 80       	push   $0x80108051
80106f82:	e8 29 97 ff ff       	call   801006b0 <cprintf>
    if (newsz >= oldsz)
80106f87:	83 c4 10             	add    $0x10,%esp
80106f8a:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106f8d:	74 0d                	je     80106f9c <allocuvm+0xac>
80106f8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106f92:	8b 45 08             	mov    0x8(%ebp),%eax
80106f95:	89 f2                	mov    %esi,%edx
80106f97:	e8 84 fa ff ff       	call   80106a20 <deallocuvm.part.0>
        return 0;
80106f9c:	31 d2                	xor    %edx,%edx
}
80106f9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fa1:	89 d0                	mov    %edx,%eax
80106fa3:	5b                   	pop    %ebx
80106fa4:	5e                   	pop    %esi
80106fa5:	5f                   	pop    %edi
80106fa6:	5d                   	pop    %ebp
80106fa7:	c3                   	ret
80106fa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106faf:	90                   	nop
        return oldsz;
80106fb0:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80106fb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fb6:	89 d0                	mov    %edx,%eax
80106fb8:	5b                   	pop    %ebx
80106fb9:	5e                   	pop    %esi
80106fba:	5f                   	pop    %edi
80106fbb:	5d                   	pop    %ebp
80106fbc:	c3                   	ret
80106fbd:	8d 76 00             	lea    0x0(%esi),%esi
            cprintf("allocuvm out of memory (2)\n");
80106fc0:	83 ec 0c             	sub    $0xc,%esp
80106fc3:	68 69 80 10 80       	push   $0x80108069
80106fc8:	e8 e3 96 ff ff       	call   801006b0 <cprintf>
    if (newsz >= oldsz)
80106fcd:	83 c4 10             	add    $0x10,%esp
80106fd0:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106fd3:	74 0d                	je     80106fe2 <allocuvm+0xf2>
80106fd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106fd8:	8b 45 08             	mov    0x8(%ebp),%eax
80106fdb:	89 f2                	mov    %esi,%edx
80106fdd:	e8 3e fa ff ff       	call   80106a20 <deallocuvm.part.0>
            kfree(mem);
80106fe2:	83 ec 0c             	sub    $0xc,%esp
80106fe5:	53                   	push   %ebx
80106fe6:	e8 55 b5 ff ff       	call   80102540 <kfree>
            return 0;
80106feb:	83 c4 10             	add    $0x10,%esp
        return 0;
80106fee:	31 d2                	xor    %edx,%edx
80106ff0:	eb ac                	jmp    80106f9e <allocuvm+0xae>
80106ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ff8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
80106ffb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ffe:	5b                   	pop    %ebx
80106fff:	5e                   	pop    %esi
80107000:	89 d0                	mov    %edx,%eax
80107002:	5f                   	pop    %edi
80107003:	5d                   	pop    %ebp
80107004:	c3                   	ret
80107005:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010700c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107010 <deallocuvm>:
deallocuvm(pde_t* pgdir, uint oldsz, uint newsz) {
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	8b 55 0c             	mov    0xc(%ebp),%edx
80107016:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107019:	8b 45 08             	mov    0x8(%ebp),%eax
    if (newsz >= oldsz)
8010701c:	39 d1                	cmp    %edx,%ecx
8010701e:	73 10                	jae    80107030 <deallocuvm+0x20>
}
80107020:	5d                   	pop    %ebp
80107021:	e9 fa f9 ff ff       	jmp    80106a20 <deallocuvm.part.0>
80107026:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010702d:	8d 76 00             	lea    0x0(%esi),%esi
80107030:	89 d0                	mov    %edx,%eax
80107032:	5d                   	pop    %ebp
80107033:	c3                   	ret
80107034:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010703b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010703f:	90                   	nop

80107040 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t* pgdir) {
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	57                   	push   %edi
80107044:	56                   	push   %esi
80107045:	53                   	push   %ebx
80107046:	83 ec 0c             	sub    $0xc,%esp
80107049:	8b 75 08             	mov    0x8(%ebp),%esi
    uint i;

    if (pgdir == 0)
8010704c:	85 f6                	test   %esi,%esi
8010704e:	74 59                	je     801070a9 <freevm+0x69>
    if (newsz >= oldsz)
80107050:	31 c9                	xor    %ecx,%ecx
80107052:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107057:	89 f0                	mov    %esi,%eax
80107059:	89 f3                	mov    %esi,%ebx
8010705b:	e8 c0 f9 ff ff       	call   80106a20 <deallocuvm.part.0>
        panic("freevm: no pgdir");
    deallocuvm(pgdir, KERNBASE, 0);
    for (i = 0; i < NPDENTRIES; i++) {
80107060:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107066:	eb 0f                	jmp    80107077 <freevm+0x37>
80107068:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010706f:	90                   	nop
80107070:	83 c3 04             	add    $0x4,%ebx
80107073:	39 fb                	cmp    %edi,%ebx
80107075:	74 23                	je     8010709a <freevm+0x5a>
        if (pgdir[i] & PTE_P) {
80107077:	8b 03                	mov    (%ebx),%eax
80107079:	a8 01                	test   $0x1,%al
8010707b:	74 f3                	je     80107070 <freevm+0x30>
            char* v = P2V(PTE_ADDR(pgdir[i]));
8010707d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
            kfree(v);
80107082:	83 ec 0c             	sub    $0xc,%esp
    for (i = 0; i < NPDENTRIES; i++) {
80107085:	83 c3 04             	add    $0x4,%ebx
            char* v = P2V(PTE_ADDR(pgdir[i]));
80107088:	05 00 00 00 80       	add    $0x80000000,%eax
            kfree(v);
8010708d:	50                   	push   %eax
8010708e:	e8 ad b4 ff ff       	call   80102540 <kfree>
80107093:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NPDENTRIES; i++) {
80107096:	39 fb                	cmp    %edi,%ebx
80107098:	75 dd                	jne    80107077 <freevm+0x37>
        }
    }
    kfree((char*) pgdir);
8010709a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010709d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070a0:	5b                   	pop    %ebx
801070a1:	5e                   	pop    %esi
801070a2:	5f                   	pop    %edi
801070a3:	5d                   	pop    %ebp
    kfree((char*) pgdir);
801070a4:	e9 97 b4 ff ff       	jmp    80102540 <kfree>
        panic("freevm: no pgdir");
801070a9:	83 ec 0c             	sub    $0xc,%esp
801070ac:	68 85 80 10 80       	push   $0x80108085
801070b1:	e8 ca 92 ff ff       	call   80100380 <panic>
801070b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070bd:	8d 76 00             	lea    0x0(%esi),%esi

801070c0 <setupkvm>:
setupkvm(void) {
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	56                   	push   %esi
801070c4:	53                   	push   %ebx
    if ((pgdir = (pde_t*) kalloc()) == 0)
801070c5:	e8 86 b6 ff ff       	call   80102750 <kalloc>
801070ca:	85 c0                	test   %eax,%eax
801070cc:	74 5e                	je     8010712c <setupkvm+0x6c>
    memset(pgdir, 0, PGSIZE);
801070ce:	83 ec 04             	sub    $0x4,%esp
801070d1:	89 c6                	mov    %eax,%esi
    for (k = kmap; k < &kmap[NELEM(kmap)];
801070d3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
    memset(pgdir, 0, PGSIZE);
801070d8:	68 00 10 00 00       	push   $0x1000
801070dd:	6a 00                	push   $0x0
801070df:	50                   	push   %eax
801070e0:	e8 bb d7 ff ff       	call   801048a0 <memset>
801070e5:	83 c4 10             	add    $0x10,%esp
                 (uint) k->phys_start, k->perm) < 0) {
801070e8:	8b 43 04             	mov    0x4(%ebx),%eax
    if (mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801070eb:	83 ec 08             	sub    $0x8,%esp
801070ee:	8b 4b 08             	mov    0x8(%ebx),%ecx
801070f1:	8b 13                	mov    (%ebx),%edx
801070f3:	ff 73 0c             	push   0xc(%ebx)
801070f6:	50                   	push   %eax
801070f7:	29 c1                	sub    %eax,%ecx
801070f9:	89 f0                	mov    %esi,%eax
801070fb:	e8 00 fa ff ff       	call   80106b00 <mappages>
80107100:	83 c4 10             	add    $0x10,%esp
80107103:	85 c0                	test   %eax,%eax
80107105:	78 19                	js     80107120 <setupkvm+0x60>
    k++)
80107107:	83 c3 10             	add    $0x10,%ebx
    for (k = kmap; k < &kmap[NELEM(kmap)];
8010710a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107110:	75 d6                	jne    801070e8 <setupkvm+0x28>
}
80107112:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107115:	89 f0                	mov    %esi,%eax
80107117:	5b                   	pop    %ebx
80107118:	5e                   	pop    %esi
80107119:	5d                   	pop    %ebp
8010711a:	c3                   	ret
8010711b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010711f:	90                   	nop
        freevm(pgdir);
80107120:	83 ec 0c             	sub    $0xc,%esp
80107123:	56                   	push   %esi
80107124:	e8 17 ff ff ff       	call   80107040 <freevm>
        return 0;
80107129:	83 c4 10             	add    $0x10,%esp
}
8010712c:	8d 65 f8             	lea    -0x8(%ebp),%esp
        return 0;
8010712f:	31 f6                	xor    %esi,%esi
}
80107131:	89 f0                	mov    %esi,%eax
80107133:	5b                   	pop    %ebx
80107134:	5e                   	pop    %esi
80107135:	5d                   	pop    %ebp
80107136:	c3                   	ret
80107137:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010713e:	66 90                	xchg   %ax,%ax

80107140 <kvmalloc>:
kvmalloc(void) {
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	83 ec 08             	sub    $0x8,%esp
    kpgdir = setupkvm();
80107146:	e8 75 ff ff ff       	call   801070c0 <setupkvm>
8010714b:	a3 e4 54 18 80       	mov    %eax,0x801854e4
    lcr3(V2P(kpgdir));   // switch to the kernel page table
80107150:	05 00 00 00 80       	add    $0x80000000,%eax
80107155:	0f 22 d8             	mov    %eax,%cr3
}
80107158:	c9                   	leave
80107159:	c3                   	ret
8010715a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107160 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t* pgdir, char* uva) {
80107160:	55                   	push   %ebp
80107161:	89 e5                	mov    %esp,%ebp
80107163:	83 ec 08             	sub    $0x8,%esp
80107166:	8b 45 0c             	mov    0xc(%ebp),%eax
    if (*pde & PTE_P) {
80107169:	8b 55 08             	mov    0x8(%ebp),%edx
    pde = &pgdir[PDX(va)];
8010716c:	89 c1                	mov    %eax,%ecx
8010716e:	c1 e9 16             	shr    $0x16,%ecx
    if (*pde & PTE_P) {
80107171:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107174:	f6 c2 01             	test   $0x1,%dl
80107177:	75 17                	jne    80107190 <clearpteu+0x30>
    pte_t* pte;

    pte = walkpgdir(pgdir, uva, 0);
    if (pte == 0)
        panic("clearpteu");
80107179:	83 ec 0c             	sub    $0xc,%esp
8010717c:	68 96 80 10 80       	push   $0x80108096
80107181:	e8 fa 91 ff ff       	call   80100380 <panic>
80107186:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010718d:	8d 76 00             	lea    0x0(%esi),%esi
    return &pgtab[PTX(va)];
80107190:	c1 e8 0a             	shr    $0xa,%eax
        pgtab = (pte_t*) P2V(PTE_ADDR(*pde));
80107193:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
    return &pgtab[PTX(va)];
80107199:	25 fc 0f 00 00       	and    $0xffc,%eax
8010719e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if (pte == 0)
801071a5:	85 c0                	test   %eax,%eax
801071a7:	74 d0                	je     80107179 <clearpteu+0x19>
    *pte &= ~PTE_U;
801071a9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801071ac:	c9                   	leave
801071ad:	c3                   	ret
801071ae:	66 90                	xchg   %ax,%ax

801071b0 <copyuvm>:

extern int cow_enabled;
// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t* pgdir, uint sz) {
801071b0:	55                   	push   %ebp
801071b1:	89 e5                	mov    %esp,%ebp
801071b3:	57                   	push   %edi
801071b4:	56                   	push   %esi
801071b5:	53                   	push   %ebx
801071b6:	83 ec 1c             	sub    $0x1c,%esp
    pde_t* d;
    pte_t* pte;
    uint pa, i, flags;
    char* mem;

    if ((d = setupkvm()) == 0)
801071b9:	e8 02 ff ff ff       	call   801070c0 <setupkvm>
801071be:	85 c0                	test   %eax,%eax
801071c0:	0f 84 39 01 00 00    	je     801072ff <copyuvm+0x14f>
        return 0;

    for (i = 0; i < sz; i += PGSIZE) {
801071c6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801071c9:	89 c1                	mov    %eax,%ecx
801071cb:	85 db                	test   %ebx,%ebx
801071cd:	0f 84 c5 00 00 00    	je     80107298 <copyuvm+0xe8>
801071d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801071d6:	31 ff                	xor    %edi,%edi
801071d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071df:	90                   	nop
    if (*pde & PTE_P) {
801071e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
    pde = &pgdir[PDX(va)];
801071e3:	89 f8                	mov    %edi,%eax
801071e5:	c1 e8 16             	shr    $0x16,%eax
    if (*pde & PTE_P) {
801071e8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801071eb:	a8 01                	test   $0x1,%al
801071ed:	75 11                	jne    80107200 <copyuvm+0x50>
        if ((pte = walkpgdir(pgdir, (void*) i, 0)) == 0)
            panic("copyuvm: pte should exist");
801071ef:	83 ec 0c             	sub    $0xc,%esp
801071f2:	68 a0 80 10 80       	push   $0x801080a0
801071f7:	e8 84 91 ff ff       	call   80100380 <panic>
801071fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return &pgtab[PTX(va)];
80107200:	89 fa                	mov    %edi,%edx
        pgtab = (pte_t*) P2V(PTE_ADDR(*pde));
80107202:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    return &pgtab[PTX(va)];
80107207:	c1 ea 0a             	shr    $0xa,%edx
8010720a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107210:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
        if ((pte = walkpgdir(pgdir, (void*) i, 0)) == 0)
80107217:	85 c0                	test   %eax,%eax
80107219:	74 d4                	je     801071ef <copyuvm+0x3f>
        if (!(*pte & PTE_P))
8010721b:	8b 18                	mov    (%eax),%ebx
8010721d:	f6 c3 01             	test   $0x1,%bl
80107220:	0f 84 e5 00 00 00    	je     8010730b <copyuvm+0x15b>
            panic("copyuvm: page not present");

        if (cow_enabled == 0) {
80107226:	8b 0d 9c 26 18 80    	mov    0x8018269c,%ecx
            pa = PTE_ADDR(*pte);
8010722c:	89 de                	mov    %ebx,%esi
8010722e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
        if (cow_enabled == 0) {
80107234:	85 c9                	test   %ecx,%ecx
80107236:	75 70                	jne    801072a8 <copyuvm+0xf8>
            flags = PTE_FLAGS(*pte);
80107238:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
            if ((mem = kalloc()) == 0)
8010723e:	e8 0d b5 ff ff       	call   80102750 <kalloc>
80107243:	85 c0                	test   %eax,%eax
80107245:	0f 84 a5 00 00 00    	je     801072f0 <copyuvm+0x140>
                goto bad;
            memmove(mem, (char*) P2V(pa), PGSIZE);
8010724b:	83 ec 04             	sub    $0x4,%esp
8010724e:	81 c6 00 00 00 80    	add    $0x80000000,%esi
80107254:	68 00 10 00 00       	push   $0x1000
80107259:	56                   	push   %esi
8010725a:	50                   	push   %eax
8010725b:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010725e:	e8 cd d6 ff ff       	call   80104930 <memmove>
            if (mappages(d, (void*) i, PGSIZE, V2P(mem), flags) < 0)
80107263:	58                   	pop    %eax
80107264:	5a                   	pop    %edx
80107265:	53                   	push   %ebx
80107266:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107269:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010726e:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107274:	52                   	push   %edx
80107275:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107278:	89 fa                	mov    %edi,%edx
8010727a:	e8 81 f8 ff ff       	call   80106b00 <mappages>
8010727f:	83 c4 10             	add    $0x10,%esp
80107282:	85 c0                	test   %eax,%eax
80107284:	78 6a                	js     801072f0 <copyuvm+0x140>
    for (i = 0; i < sz; i += PGSIZE) {
80107286:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010728c:	3b 7d 0c             	cmp    0xc(%ebp),%edi
8010728f:	0f 82 4b ff ff ff    	jb     801071e0 <copyuvm+0x30>
80107295:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    return d;

    bad:
    freevm(d);
    return 0;
}
80107298:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010729b:	89 c8                	mov    %ecx,%eax
8010729d:	5b                   	pop    %ebx
8010729e:	5e                   	pop    %esi
8010729f:	5f                   	pop    %edi
801072a0:	5d                   	pop    %ebp
801072a1:	c3                   	ret
801072a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            *pte &= ~PTE_W;
801072a8:	89 da                	mov    %ebx,%edx
            flags = PTE_FLAGS(*pte);
801072aa:	81 e3 fd 0f 00 00    	and    $0xffd,%ebx
            if (mappages(d, (void*) i, PGSIZE, pa, flags) < 0) {
801072b0:	83 ec 08             	sub    $0x8,%esp
801072b3:	b9 00 10 00 00       	mov    $0x1000,%ecx
            *pte &= ~PTE_W;
801072b8:	83 e2 fd             	and    $0xfffffffd,%edx
            flags = PTE_FLAGS(*pte);
801072bb:	83 cb 08             	or     $0x8,%ebx
            *pte &= ~PTE_W;
801072be:	83 ca 08             	or     $0x8,%edx
801072c1:	89 10                	mov    %edx,(%eax)
            if (mappages(d, (void*) i, PGSIZE, pa, flags) < 0) {
801072c3:	89 fa                	mov    %edi,%edx
801072c5:	53                   	push   %ebx
801072c6:	56                   	push   %esi
801072c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072ca:	e8 31 f8 ff ff       	call   80106b00 <mappages>
801072cf:	83 c4 10             	add    $0x10,%esp
801072d2:	85 c0                	test   %eax,%eax
801072d4:	78 1a                	js     801072f0 <copyuvm+0x140>
            kinc(v);
801072d6:	83 ec 0c             	sub    $0xc,%esp
            char* v = P2V(pa);
801072d9:	81 c6 00 00 00 80    	add    $0x80000000,%esi
            kinc(v);
801072df:	56                   	push   %esi
801072e0:	e8 1b b5 ff ff       	call   80102800 <kinc>
    __asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
801072e5:	0f 01 3f             	invlpg (%edi)
}
801072e8:	83 c4 10             	add    $0x10,%esp
801072eb:	eb 99                	jmp    80107286 <copyuvm+0xd6>
801072ed:	8d 76 00             	lea    0x0(%esi),%esi
801072f0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    freevm(d);
801072f3:	83 ec 0c             	sub    $0xc,%esp
801072f6:	51                   	push   %ecx
801072f7:	e8 44 fd ff ff       	call   80107040 <freevm>
    return 0;
801072fc:	83 c4 10             	add    $0x10,%esp
}
801072ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
80107302:	31 c9                	xor    %ecx,%ecx
}
80107304:	5b                   	pop    %ebx
80107305:	89 c8                	mov    %ecx,%eax
80107307:	5e                   	pop    %esi
80107308:	5f                   	pop    %edi
80107309:	5d                   	pop    %ebp
8010730a:	c3                   	ret
            panic("copyuvm: page not present");
8010730b:	83 ec 0c             	sub    $0xc,%esp
8010730e:	68 ba 80 10 80       	push   $0x801080ba
80107313:	e8 68 90 ff ff       	call   80100380 <panic>
80107318:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010731f:	90                   	nop

80107320 <copyuvm_2>:


pde_t*
copyuvm_2(pde_t* pgdir, uint sz) {
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	57                   	push   %edi
80107324:	56                   	push   %esi
80107325:	53                   	push   %ebx
80107326:	83 ec 1c             	sub    $0x1c,%esp
    pde_t* d;
    pte_t* pte;
    uint pa, I;
    uint flags;

    if ((d = setupkvm()) == 0)
80107329:	e8 92 fd ff ff       	call   801070c0 <setupkvm>
8010732e:	85 c0                	test   %eax,%eax
80107330:	0f 84 d9 00 00 00    	je     8010740f <copyuvm_2+0xef>
80107336:	89 c6                	mov    %eax,%esi
        return 0;

    for (I = 0; I < sz; I += PGSIZE) {
80107338:	8b 45 0c             	mov    0xc(%ebp),%eax
8010733b:	85 c0                	test   %eax,%eax
8010733d:	0f 84 ae 00 00 00    	je     801073f1 <copyuvm_2+0xd1>
80107343:	31 ff                	xor    %edi,%edi
80107345:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80107348:	89 fe                	mov    %edi,%esi
8010734a:	8b 7d 08             	mov    0x8(%ebp),%edi
8010734d:	8d 76 00             	lea    0x0(%esi),%esi
    pde = &pgdir[PDX(va)];
80107350:	89 f0                	mov    %esi,%eax
80107352:	c1 e8 16             	shr    $0x16,%eax
    if (*pde & PTE_P) {
80107355:	8b 04 87             	mov    (%edi,%eax,4),%eax
80107358:	a8 01                	test   $0x1,%al
8010735a:	75 14                	jne    80107370 <copyuvm_2+0x50>
        if ((pte = walkpgdir(pgdir, (void*) I, 0)) == 0)
            panic("uvmcopy: pte should exist");
8010735c:	83 ec 0c             	sub    $0xc,%esp
8010735f:	68 d4 80 10 80       	push   $0x801080d4
80107364:	e8 17 90 ff ff       	call   80100380 <panic>
80107369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return &pgtab[PTX(va)];
80107370:	89 f1                	mov    %esi,%ecx
        pgtab = (pte_t*) P2V(PTE_ADDR(*pde));
80107372:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    return &pgtab[PTX(va)];
80107377:	c1 e9 0a             	shr    $0xa,%ecx
8010737a:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80107380:	8d 9c 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%ebx
        if ((pte = walkpgdir(pgdir, (void*) I, 0)) == 0)
80107387:	85 db                	test   %ebx,%ebx
80107389:	74 d1                	je     8010735c <copyuvm_2+0x3c>
        if ((*pte & PTE_P) == 0)
8010738b:	8b 03                	mov    (%ebx),%eax
8010738d:	a8 01                	test   $0x1,%al
8010738f:	0f 84 86 00 00 00    	je     8010741b <copyuvm_2+0xfb>
            panic("uvmcopy: page not present");

        *pte |= PTE_PWT;
        *pte &= ~PTE_W;
80107395:	89 c1                	mov    %eax,%ecx

        pa = PTE_ADDR(*pte);
        flags = PTE_FLAGS(*pte);

        // map the parent’s physical pages into the child
        if (mappages(d, (void*) I, PGSIZE, pa, flags) < 0) {
80107397:	83 ec 08             	sub    $0x8,%esp
8010739a:	89 f2                	mov    %esi,%edx
        *pte &= ~PTE_W;
8010739c:	83 e1 fd             	and    $0xfffffffd,%ecx
8010739f:	83 c9 08             	or     $0x8,%ecx
801073a2:	89 0b                	mov    %ecx,(%ebx)
        pa = PTE_ADDR(*pte);
801073a4:	89 c3                	mov    %eax,%ebx
        flags = PTE_FLAGS(*pte);
801073a6:	25 fd 0f 00 00       	and    $0xffd,%eax
        if (mappages(d, (void*) I, PGSIZE, pa, flags) < 0) {
801073ab:	b9 00 10 00 00       	mov    $0x1000,%ecx
        flags = PTE_FLAGS(*pte);
801073b0:	83 c8 08             	or     $0x8,%eax
801073b3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
        if (mappages(d, (void*) I, PGSIZE, pa, flags) < 0) {
801073b9:	50                   	push   %eax
801073ba:	53                   	push   %ebx
801073bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801073be:	e8 3d f7 ff ff       	call   80106b00 <mappages>
801073c3:	83 c4 10             	add    $0x10,%esp
801073c6:	85 c0                	test   %eax,%eax
801073c8:	78 36                	js     80107400 <copyuvm_2+0xe0>
            goto err;
        }

        char* v = P2V(pa);
        kinc(v);
801073ca:	83 ec 0c             	sub    $0xc,%esp
        char* v = P2V(pa);
801073cd:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
        kinc(v);
801073d3:	53                   	push   %ebx
801073d4:	e8 27 b4 ff ff       	call   80102800 <kinc>
    __asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
801073d9:	0f 01 3e             	invlpg (%esi)
    for (I = 0; I < sz; I += PGSIZE) {
801073dc:	81 c6 00 10 00 00    	add    $0x1000,%esi
801073e2:	83 c4 10             	add    $0x10,%esp
801073e5:	3b 75 0c             	cmp    0xc(%ebp),%esi
801073e8:	0f 82 62 ff ff ff    	jb     80107350 <copyuvm_2+0x30>
801073ee:	8b 75 e4             	mov    -0x1c(%ebp),%esi

    err:
    freevm(d);
    return 0;

}
801073f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073f4:	89 f0                	mov    %esi,%eax
801073f6:	5b                   	pop    %ebx
801073f7:	5e                   	pop    %esi
801073f8:	5f                   	pop    %edi
801073f9:	5d                   	pop    %ebp
801073fa:	c3                   	ret
801073fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073ff:	90                   	nop
    freevm(d);
80107400:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80107403:	83 ec 0c             	sub    $0xc,%esp
80107406:	56                   	push   %esi
80107407:	e8 34 fc ff ff       	call   80107040 <freevm>
    return 0;
8010740c:	83 c4 10             	add    $0x10,%esp
}
8010740f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
80107412:	31 f6                	xor    %esi,%esi
}
80107414:	5b                   	pop    %ebx
80107415:	89 f0                	mov    %esi,%eax
80107417:	5e                   	pop    %esi
80107418:	5f                   	pop    %edi
80107419:	5d                   	pop    %ebp
8010741a:	c3                   	ret
            panic("uvmcopy: page not present");
8010741b:	83 ec 0c             	sub    $0xc,%esp
8010741e:	68 ee 80 10 80       	push   $0x801080ee
80107423:	e8 58 8f ff ff       	call   80100380 <panic>
80107428:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010742f:	90                   	nop

80107430 <pagefault>:

void
pagefault() {
80107430:	55                   	push   %ebp
80107431:	89 e5                	mov    %esp,%ebp
80107433:	57                   	push   %edi
80107434:	56                   	push   %esi
80107435:	53                   	push   %ebx
80107436:	83 ec 1c             	sub    $0x1c,%esp
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107439:	0f 20 d6             	mov    %cr2,%esi
    pte_t* pte;
    uint pa, npa, va = rcr2(), er = myproc()->tf->err, flags;
8010743c:	e8 4f c7 ff ff       	call   80103b90 <myproc>
80107441:	8b 40 18             	mov    0x18(%eax),%eax
80107444:	8b 78 34             	mov    0x34(%eax),%edi

    // Obtain the start of the page that the faulty virtual address belongs to
    char* a = (char*) PGROUNDDOWN((uint) va);

    // fault is not for user address - kill process
    if (va >= KERNBASE || (pte = walkpgdir(myproc()->pgdir, a, 0)) == 0) {
80107447:	85 f6                	test   %esi,%esi
80107449:	0f 88 81 00 00 00    	js     801074d0 <pagefault+0xa0>
8010744f:	e8 3c c7 ff ff       	call   80103b90 <myproc>
    char* a = (char*) PGROUNDDOWN((uint) va);
80107454:	89 f3                	mov    %esi,%ebx
80107456:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    if (*pde & PTE_P) {
8010745c:	8b 40 04             	mov    0x4(%eax),%eax
    pde = &pgdir[PDX(va)];
8010745f:	89 da                	mov    %ebx,%edx
80107461:	c1 ea 16             	shr    $0x16,%edx
    if (*pde & PTE_P) {
80107464:	8b 04 90             	mov    (%eax,%edx,4),%eax
80107467:	a8 01                	test   $0x1,%al
80107469:	74 65                	je     801074d0 <pagefault+0xa0>
    return &pgtab[PTX(va)];
8010746b:	c1 eb 0a             	shr    $0xa,%ebx
        pgtab = (pte_t*) P2V(PTE_ADDR(*pde));
8010746e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    return &pgtab[PTX(va)];
80107473:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
80107479:	8d 94 18 00 00 00 80 	lea    -0x80000000(%eax,%ebx,1),%edx
    if (va >= KERNBASE || (pte = walkpgdir(myproc()->pgdir, a, 0)) == 0) {
80107480:	85 d2                	test   %edx,%edx
80107482:	74 4c                	je     801074d0 <pagefault+0xa0>
        myproc()->killed = 1;
        return;
    }

    // write fault for a user address
    if (er & FEC_WR) {
80107484:	83 e7 02             	and    $0x2,%edi
80107487:	0f 84 83 00 00 00    	je     80107510 <pagefault+0xe0>
        // Check if the fault is for an address whose page table includes the PTE_PWT flag
        // If not, kill the program as usual
        if (!(*pte & PTE_PWT)) {
8010748d:	8b 1a                	mov    (%edx),%ebx
8010748f:	f6 c3 08             	test   $0x8,%bl
80107492:	74 7c                	je     80107510 <pagefault+0xe0>
            myproc()->killed = 1;
            return;
        } else {
            pa = PTE_ADDR(*pte);
80107494:	89 df                	mov    %ebx,%edi
            char* v = P2V(pa);
            flags = PTE_FLAGS(*pte);

            // get reference count for faulty page
            int refs = getRefs(v);
80107496:	83 ec 0c             	sub    $0xc,%esp
80107499:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            pa = PTE_ADDR(*pte);
8010749c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
            char* v = P2V(pa);
801074a2:	81 c7 00 00 00 80    	add    $0x80000000,%edi
            int refs = getRefs(v);
801074a8:	57                   	push   %edi
801074a9:	e8 32 b4 ff ff       	call   801028e0 <getRefs>

            // page has more than one reference
            if (refs > 1) {
801074ae:	83 c4 10             	add    $0x10,%esp
801074b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801074b4:	83 f8 01             	cmp    $0x1,%eax
801074b7:	7f 6f                	jg     80107528 <pagefault+0xf8>
                kdec(v);
            }
                // page has only one reference
            else {
                *pte |= PTE_W;
                *pte &= ~PTE_PWT;
801074b9:	8b 02                	mov    (%edx),%eax
801074bb:	83 e0 f7             	and    $0xfffffff7,%eax
801074be:	83 c8 02             	or     $0x2,%eax
801074c1:	89 02                	mov    %eax,(%edx)
    __asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
801074c3:	0f 01 3e             	invlpg (%esi)
        }
    } else { // not a write fault
        myproc()->killed = 1;
        return;
    }
}
801074c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074c9:	5b                   	pop    %ebx
801074ca:	5e                   	pop    %esi
801074cb:	5f                   	pop    %edi
801074cc:	5d                   	pop    %ebp
801074cd:	c3                   	ret
801074ce:	66 90                	xchg   %ax,%ax
        cprintf("pid %d %s: Page fault--access to invalid address.\n", myproc()->pid, myproc()->name);
801074d0:	e8 bb c6 ff ff       	call   80103b90 <myproc>
801074d5:	89 c3                	mov    %eax,%ebx
801074d7:	e8 b4 c6 ff ff       	call   80103b90 <myproc>
801074dc:	83 c3 6c             	add    $0x6c,%ebx
801074df:	83 ec 04             	sub    $0x4,%esp
801074e2:	53                   	push   %ebx
801074e3:	ff 70 10             	push   0x10(%eax)
801074e6:	68 2c 81 10 80       	push   $0x8010812c
801074eb:	e8 c0 91 ff ff       	call   801006b0 <cprintf>
        myproc()->killed = 1;
801074f0:	e8 9b c6 ff ff       	call   80103b90 <myproc>
        return;
801074f5:	83 c4 10             	add    $0x10,%esp
        myproc()->killed = 1;
801074f8:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
}
801074ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107502:	5b                   	pop    %ebx
80107503:	5e                   	pop    %esi
80107504:	5f                   	pop    %edi
80107505:	5d                   	pop    %ebp
80107506:	c3                   	ret
80107507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010750e:	66 90                	xchg   %ax,%ax
        myproc()->killed = 1;
80107510:	e8 7b c6 ff ff       	call   80103b90 <myproc>
80107515:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
}
8010751c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010751f:	5b                   	pop    %ebx
80107520:	5e                   	pop    %esi
80107521:	5f                   	pop    %edi
80107522:	5d                   	pop    %ebp
80107523:	c3                   	ret
80107524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107528:	89 55 e0             	mov    %edx,-0x20(%ebp)
            flags = PTE_FLAGS(*pte);
8010752b:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
                mem = kalloc();
80107531:	e8 1a b2 ff ff       	call   80102750 <kalloc>
                memmove(mem, v, PGSIZE);
80107536:	83 ec 04             	sub    $0x4,%esp
80107539:	68 00 10 00 00       	push   $0x1000
8010753e:	57                   	push   %edi
8010753f:	50                   	push   %eax
80107540:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107543:	e8 e8 d3 ff ff       	call   80104930 <memmove>
                npa = V2P(mem);
80107548:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
                *pte = npa | flags | PTE_P | PTE_W;
8010754b:	8b 55 e0             	mov    -0x20(%ebp),%edx
                npa = V2P(mem);
8010754e:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
                *pte = npa | flags | PTE_P | PTE_W;
80107554:	09 cb                	or     %ecx,%ebx
80107556:	83 cb 03             	or     $0x3,%ebx
80107559:	89 1a                	mov    %ebx,(%edx)
8010755b:	0f 01 3e             	invlpg (%esi)
                kdec(v);
8010755e:	89 3c 24             	mov    %edi,(%esp)
80107561:	e8 0a b3 ff ff       	call   80102870 <kdec>
80107566:	83 c4 10             	add    $0x10,%esp
}
80107569:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010756c:	5b                   	pop    %ebx
8010756d:	5e                   	pop    %esi
8010756e:	5f                   	pop    %edi
8010756f:	5d                   	pop    %ebp
80107570:	c3                   	ret
80107571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107578:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010757f:	90                   	nop

80107580 <uva2ka>:


//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t* pgdir, char* uva) {
80107580:	55                   	push   %ebp
80107581:	89 e5                	mov    %esp,%ebp
80107583:	8b 45 0c             	mov    0xc(%ebp),%eax
    if (*pde & PTE_P) {
80107586:	8b 55 08             	mov    0x8(%ebp),%edx
    pde = &pgdir[PDX(va)];
80107589:	89 c1                	mov    %eax,%ecx
8010758b:	c1 e9 16             	shr    $0x16,%ecx
    if (*pde & PTE_P) {
8010758e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107591:	f6 c2 01             	test   $0x1,%dl
80107594:	0f 84 00 01 00 00    	je     8010769a <uva2ka.cold>
    return &pgtab[PTX(va)];
8010759a:	c1 e8 0c             	shr    $0xc,%eax
        pgtab = (pte_t*) P2V(PTE_ADDR(*pde));
8010759d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
    if ((*pte & PTE_P) == 0)
        return 0;
    if ((*pte & PTE_U) == 0)
        return 0;
    return (char*) P2V(PTE_ADDR(*pte));
}
801075a3:	5d                   	pop    %ebp
    return &pgtab[PTX(va)];
801075a4:	25 ff 03 00 00       	and    $0x3ff,%eax
    if ((*pte & PTE_P) == 0)
801075a9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
    if ((*pte & PTE_U) == 0)
801075b0:	89 c2                	mov    %eax,%edx
    return (char*) P2V(PTE_ADDR(*pte));
801075b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if ((*pte & PTE_U) == 0)
801075b7:	83 e2 05             	and    $0x5,%edx
    return (char*) P2V(PTE_ADDR(*pte));
801075ba:	05 00 00 00 80       	add    $0x80000000,%eax
801075bf:	83 fa 05             	cmp    $0x5,%edx
801075c2:	ba 00 00 00 00       	mov    $0x0,%edx
801075c7:	0f 45 c2             	cmovne %edx,%eax
}
801075ca:	c3                   	ret
801075cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801075cf:	90                   	nop

801075d0 <copyout>:

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t* pgdir, uint va, void* p, uint len) {
801075d0:	55                   	push   %ebp
801075d1:	89 e5                	mov    %esp,%ebp
801075d3:	57                   	push   %edi
801075d4:	56                   	push   %esi
801075d5:	53                   	push   %ebx
801075d6:	83 ec 0c             	sub    $0xc,%esp
801075d9:	8b 75 14             	mov    0x14(%ebp),%esi
801075dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801075df:	8b 55 10             	mov    0x10(%ebp),%edx
    char* buf, * pa0;
    uint n, va0;

    buf = (char*) p;
    while (len > 0) {
801075e2:	85 f6                	test   %esi,%esi
801075e4:	75 51                	jne    80107637 <copyout+0x67>
801075e6:	e9 a5 00 00 00       	jmp    80107690 <copyout+0xc0>
801075eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801075ef:	90                   	nop
    return (char*) P2V(PTE_ADDR(*pte));
801075f0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801075f6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
        va0 = (uint) PGROUNDDOWN(va);
        pa0 = uva2ka(pgdir, (char*) va0);
        if (pa0 == 0)
801075fc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107602:	74 75                	je     80107679 <copyout+0xa9>
            return -1;
        n = PGSIZE - (va - va0);
80107604:	89 fb                	mov    %edi,%ebx
80107606:	29 c3                	sub    %eax,%ebx
80107608:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010760e:	39 f3                	cmp    %esi,%ebx
80107610:	0f 47 de             	cmova  %esi,%ebx
        if (n > len)
            n = len;
        memmove(pa0 + (va - va0), buf, n);
80107613:	29 f8                	sub    %edi,%eax
80107615:	83 ec 04             	sub    $0x4,%esp
80107618:	01 c1                	add    %eax,%ecx
8010761a:	53                   	push   %ebx
8010761b:	52                   	push   %edx
8010761c:	89 55 10             	mov    %edx,0x10(%ebp)
8010761f:	51                   	push   %ecx
80107620:	e8 0b d3 ff ff       	call   80104930 <memmove>
        len -= n;
        buf += n;
80107625:	8b 55 10             	mov    0x10(%ebp),%edx
        va = va0 + PGSIZE;
80107628:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
    while (len > 0) {
8010762e:	83 c4 10             	add    $0x10,%esp
        buf += n;
80107631:	01 da                	add    %ebx,%edx
    while (len > 0) {
80107633:	29 de                	sub    %ebx,%esi
80107635:	74 59                	je     80107690 <copyout+0xc0>
    if (*pde & PTE_P) {
80107637:	8b 5d 08             	mov    0x8(%ebp),%ebx
    pde = &pgdir[PDX(va)];
8010763a:	89 c1                	mov    %eax,%ecx
        va0 = (uint) PGROUNDDOWN(va);
8010763c:	89 c7                	mov    %eax,%edi
    pde = &pgdir[PDX(va)];
8010763e:	c1 e9 16             	shr    $0x16,%ecx
        va0 = (uint) PGROUNDDOWN(va);
80107641:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if (*pde & PTE_P) {
80107647:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010764a:	f6 c1 01             	test   $0x1,%cl
8010764d:	0f 84 4e 00 00 00    	je     801076a1 <copyout.cold>
    return &pgtab[PTX(va)];
80107653:	89 fb                	mov    %edi,%ebx
        pgtab = (pte_t*) P2V(PTE_ADDR(*pde));
80107655:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
    return &pgtab[PTX(va)];
8010765b:	c1 eb 0c             	shr    $0xc,%ebx
8010765e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
    if ((*pte & PTE_P) == 0)
80107664:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
    if ((*pte & PTE_U) == 0)
8010766b:	89 d9                	mov    %ebx,%ecx
8010766d:	83 e1 05             	and    $0x5,%ecx
80107670:	83 f9 05             	cmp    $0x5,%ecx
80107673:	0f 84 77 ff ff ff    	je     801075f0 <copyout+0x20>
    }
    return 0;
}
80107679:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
8010767c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107681:	5b                   	pop    %ebx
80107682:	5e                   	pop    %esi
80107683:	5f                   	pop    %edi
80107684:	5d                   	pop    %ebp
80107685:	c3                   	ret
80107686:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010768d:	8d 76 00             	lea    0x0(%esi),%esi
80107690:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107693:	31 c0                	xor    %eax,%eax
}
80107695:	5b                   	pop    %ebx
80107696:	5e                   	pop    %esi
80107697:	5f                   	pop    %edi
80107698:	5d                   	pop    %ebp
80107699:	c3                   	ret

8010769a <uva2ka.cold>:
    if ((*pte & PTE_P) == 0)
8010769a:	a1 00 00 00 00       	mov    0x0,%eax
8010769f:	0f 0b                	ud2

801076a1 <copyout.cold>:
801076a1:	a1 00 00 00 00       	mov    0x0,%eax
801076a6:	0f 0b                	ud2
