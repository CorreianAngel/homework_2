
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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 c0 2f 10 80       	mov    $0x80102fc0,%eax
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
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 c0 71 10 80       	push   $0x801071c0
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 65 44 00 00       	call   801044c0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
  bcache.head.prev = &bcache.head;
80100063:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	83 ec 08             	sub    $0x8,%esp
80100085:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 71 10 80       	push   $0x801071c7
80100097:	50                   	push   %eax
80100098:	e8 13 43 00 00       	call   801043b0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a2:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a4:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

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
801000d9:	8b 7d 08             	mov    0x8(%ebp),%edi
801000dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 d7 44 00 00       	call   801045c0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 79 45 00 00       	call   801046e0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 7e 42 00 00       	call   801043f0 <acquiresleep>
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
8010018c:	e8 7f 20 00 00       	call   80102210 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 ce 71 10 80       	push   $0x801071ce
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

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
801001be:	e8 cd 42 00 00       	call   80104490 <holdingsleep>
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
801001d4:	e9 37 20 00 00       	jmp    80102210 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 df 71 10 80       	push   $0x801071df
801001e1:	e8 aa 01 00 00       	call   80100390 <panic>
801001e6:	8d 76 00             	lea    0x0(%esi),%esi
801001e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

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
801001ff:	e8 8c 42 00 00       	call   80104490 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 3c 42 00 00       	call   80104450 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010021b:	e8 a0 43 00 00       	call   801045c0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 6f 44 00 00       	jmp    801046e0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 e6 71 10 80       	push   $0x801071e6
80100279:	e8 12 01 00 00       	call   80100390 <panic>
8010027e:	66 90                	xchg   %ax,%ax

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
80100286:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100289:	ff 75 08             	pushl  0x8(%ebp)
{
8010028c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010028f:	e8 7c 15 00 00       	call   80101810 <iunlock>
  target = n;
  acquire(&cons.lock);
80100294:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010029b:	e8 20 43 00 00       	call   801045c0 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002a0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002a3:	83 c4 10             	add    $0x10,%esp
801002a6:	31 c0                	xor    %eax,%eax
    *dst++ = c;
801002a8:	01 f7                	add    %esi,%edi
  while(n > 0){
801002aa:	85 f6                	test   %esi,%esi
801002ac:	0f 8e a0 00 00 00    	jle    80100352 <consoleread+0xd2>
801002b2:	89 f3                	mov    %esi,%ebx
    while(input.r == input.w){
801002b4:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002ba:	39 15 a4 ff 10 80    	cmp    %edx,0x8010ffa4
801002c0:	74 29                	je     801002eb <consoleread+0x6b>
801002c2:	eb 5c                	jmp    80100320 <consoleread+0xa0>
801002c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      sleep(&input.r, &cons.lock);
801002c8:	83 ec 08             	sub    $0x8,%esp
801002cb:	68 20 a5 10 80       	push   $0x8010a520
801002d0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002d5:	e8 e6 3b 00 00       	call   80103ec0 <sleep>
    while(input.r == input.w){
801002da:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002e0:	83 c4 10             	add    $0x10,%esp
801002e3:	3b 15 a4 ff 10 80    	cmp    0x8010ffa4,%edx
801002e9:	75 35                	jne    80100320 <consoleread+0xa0>
      if(myproc()->killed){
801002eb:	e8 10 36 00 00       	call   80103900 <myproc>
801002f0:	8b 48 24             	mov    0x24(%eax),%ecx
801002f3:	85 c9                	test   %ecx,%ecx
801002f5:	74 d1                	je     801002c8 <consoleread+0x48>
        release(&cons.lock);
801002f7:	83 ec 0c             	sub    $0xc,%esp
801002fa:	68 20 a5 10 80       	push   $0x8010a520
801002ff:	e8 dc 43 00 00       	call   801046e0 <release>
        ilock(ip);
80100304:	5a                   	pop    %edx
80100305:	ff 75 08             	pushl  0x8(%ebp)
80100308:	e8 23 14 00 00       	call   80101730 <ilock>
        return -1;
8010030d:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100310:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100313:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100318:	5b                   	pop    %ebx
80100319:	5e                   	pop    %esi
8010031a:	5f                   	pop    %edi
8010031b:	5d                   	pop    %ebp
8010031c:	c3                   	ret    
8010031d:	8d 76 00             	lea    0x0(%esi),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100320:	8d 42 01             	lea    0x1(%edx),%eax
80100323:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100328:	89 d0                	mov    %edx,%eax
8010032a:	83 e0 7f             	and    $0x7f,%eax
8010032d:	0f be 80 20 ff 10 80 	movsbl -0x7fef00e0(%eax),%eax
    if(c == C('D')){  // EOF
80100334:	83 f8 04             	cmp    $0x4,%eax
80100337:	74 46                	je     8010037f <consoleread+0xff>
    *dst++ = c;
80100339:	89 da                	mov    %ebx,%edx
    --n;
8010033b:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010033e:	f7 da                	neg    %edx
80100340:	88 04 17             	mov    %al,(%edi,%edx,1)
    if(c == '\n')
80100343:	83 f8 0a             	cmp    $0xa,%eax
80100346:	74 31                	je     80100379 <consoleread+0xf9>
  while(n > 0){
80100348:	85 db                	test   %ebx,%ebx
8010034a:	0f 85 64 ff ff ff    	jne    801002b4 <consoleread+0x34>
80100350:	89 f0                	mov    %esi,%eax
  release(&cons.lock);
80100352:	83 ec 0c             	sub    $0xc,%esp
80100355:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100358:	68 20 a5 10 80       	push   $0x8010a520
8010035d:	e8 7e 43 00 00       	call   801046e0 <release>
  ilock(ip);
80100362:	58                   	pop    %eax
80100363:	ff 75 08             	pushl  0x8(%ebp)
80100366:	e8 c5 13 00 00       	call   80101730 <ilock>
  return target - n;
8010036b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010036e:	83 c4 10             	add    $0x10,%esp
}
80100371:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100374:	5b                   	pop    %ebx
80100375:	5e                   	pop    %esi
80100376:	5f                   	pop    %edi
80100377:	5d                   	pop    %ebp
80100378:	c3                   	ret    
80100379:	89 f0                	mov    %esi,%eax
8010037b:	29 d8                	sub    %ebx,%eax
8010037d:	eb d3                	jmp    80100352 <consoleread+0xd2>
      if(n < target){
8010037f:	89 f0                	mov    %esi,%eax
80100381:	29 d8                	sub    %ebx,%eax
80100383:	39 f3                	cmp    %esi,%ebx
80100385:	73 cb                	jae    80100352 <consoleread+0xd2>
        input.r--;
80100387:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
8010038d:	eb c3                	jmp    80100352 <consoleread+0xd2>
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 92 24 00 00       	call   80102840 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ed 71 10 80       	push   $0x801071ed
801003b7:	e8 f4 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 eb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 23 78 10 80 	movl   $0x80107823,(%esp)
801003cc:	e8 df 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	8d 45 08             	lea    0x8(%ebp),%eax
801003d4:	5a                   	pop    %edx
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 03 41 00 00       	call   801044e0 <getcallerpcs>
  for(i=0; i<10; i++)
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 01 72 10 80       	push   $0x80107201
801003ed:	e8 be 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100400:	00 00 00 
    ;
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 c1 59 00 00       	call   80105df0 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004ec:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 d6 58 00 00       	call   80105df0 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 ca 58 00 00       	call   80105df0 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 be 58 00 00       	call   80105df0 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010054b:	68 60 0e 00 00       	push   $0xe60
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100550:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 6a 42 00 00       	call   801047d0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 b5 41 00 00       	call   80104730 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 05 72 10 80       	push   $0x80107205
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 68                	js     8010061c <printint+0x7c>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	31 db                	xor    %ebx,%ebx
801005ba:	eb 04                	jmp    801005c0 <printint+0x20>
  }while((x /= base) != 0);
801005bc:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
801005be:	89 fb                	mov    %edi,%ebx
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	8d 7b 01             	lea    0x1(%ebx),%edi
801005c7:	f7 75 d4             	divl   -0x2c(%ebp)
801005ca:	0f b6 92 30 72 10 80 	movzbl -0x7fef8dd0(%edx),%edx
801005d1:	88 54 3d d7          	mov    %dl,-0x29(%ebp,%edi,1)
  }while((x /= base) != 0);
801005d5:	39 4d d4             	cmp    %ecx,-0x2c(%ebp)
801005d8:	76 e2                	jbe    801005bc <printint+0x1c>
  if(sign)
801005da:	85 f6                	test   %esi,%esi
801005dc:	75 32                	jne    80100610 <printint+0x70>
801005de:	0f be c2             	movsbl %dl,%eax
801005e1:	89 df                	mov    %ebx,%edi
  if(panicked){
801005e3:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801005e9:	85 c9                	test   %ecx,%ecx
801005eb:	75 20                	jne    8010060d <printint+0x6d>
801005ed:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005f1:	e8 1a fe ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
801005f6:	8d 45 d7             	lea    -0x29(%ebp),%eax
801005f9:	39 d8                	cmp    %ebx,%eax
801005fb:	74 27                	je     80100624 <printint+0x84>
  if(panicked){
801005fd:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
    consputc(buf[i]);
80100603:	0f be 03             	movsbl (%ebx),%eax
  if(panicked){
80100606:	83 eb 01             	sub    $0x1,%ebx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 e4                	je     801005f1 <printint+0x51>
  asm volatile("cli");
8010060d:	fa                   	cli    
      ;
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
    buf[i++] = '-';
80100610:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
80100615:	b8 2d 00 00 00       	mov    $0x2d,%eax
8010061a:	eb c7                	jmp    801005e3 <printint+0x43>
    x = -xx;
8010061c:	f7 d8                	neg    %eax
8010061e:	89 ce                	mov    %ecx,%esi
80100620:	89 c1                	mov    %eax,%ecx
80100622:	eb 94                	jmp    801005b8 <printint+0x18>
}
80100624:	83 c4 2c             	add    $0x2c,%esp
80100627:	5b                   	pop    %ebx
80100628:	5e                   	pop    %esi
80100629:	5f                   	pop    %edi
8010062a:	5d                   	pop    %ebp
8010062b:	c3                   	ret    
8010062c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100630 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100630:	55                   	push   %ebp
80100631:	89 e5                	mov    %esp,%ebp
80100633:	57                   	push   %edi
80100634:	56                   	push   %esi
80100635:	53                   	push   %ebx
80100636:	83 ec 18             	sub    $0x18,%esp
80100639:	8b 7d 10             	mov    0x10(%ebp),%edi
8010063c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  int i;

  iunlock(ip);
8010063f:	ff 75 08             	pushl  0x8(%ebp)
80100642:	e8 c9 11 00 00       	call   80101810 <iunlock>
  acquire(&cons.lock);
80100647:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010064e:	e8 6d 3f 00 00       	call   801045c0 <acquire>
  for(i = 0; i < n; i++)
80100653:	83 c4 10             	add    $0x10,%esp
80100656:	85 ff                	test   %edi,%edi
80100658:	7e 36                	jle    80100690 <consolewrite+0x60>
  if(panicked){
8010065a:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100660:	85 c9                	test   %ecx,%ecx
80100662:	75 21                	jne    80100685 <consolewrite+0x55>
    consputc(buf[i] & 0xff);
80100664:	0f b6 03             	movzbl (%ebx),%eax
80100667:	8d 73 01             	lea    0x1(%ebx),%esi
8010066a:	01 fb                	add    %edi,%ebx
8010066c:	e8 9f fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
80100671:	39 de                	cmp    %ebx,%esi
80100673:	74 1b                	je     80100690 <consolewrite+0x60>
  if(panicked){
80100675:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
    consputc(buf[i] & 0xff);
8010067b:	0f b6 06             	movzbl (%esi),%eax
  if(panicked){
8010067e:	83 c6 01             	add    $0x1,%esi
80100681:	85 d2                	test   %edx,%edx
80100683:	74 e7                	je     8010066c <consolewrite+0x3c>
80100685:	fa                   	cli    
      ;
80100686:	eb fe                	jmp    80100686 <consolewrite+0x56>
80100688:	90                   	nop
80100689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100690:	83 ec 0c             	sub    $0xc,%esp
80100693:	68 20 a5 10 80       	push   $0x8010a520
80100698:	e8 43 40 00 00       	call   801046e0 <release>
  ilock(ip);
8010069d:	58                   	pop    %eax
8010069e:	ff 75 08             	pushl  0x8(%ebp)
801006a1:	e8 8a 10 00 00       	call   80101730 <ilock>

  return n;
}
801006a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a9:	89 f8                	mov    %edi,%eax
801006ab:	5b                   	pop    %ebx
801006ac:	5e                   	pop    %esi
801006ad:	5f                   	pop    %edi
801006ae:	5d                   	pop    %ebp
801006af:	c3                   	ret    

801006b0 <cprintf>:
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006b9:	a1 54 a5 10 80       	mov    0x8010a554,%eax
801006be:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c1:	85 c0                	test   %eax,%eax
801006c3:	0f 85 df 00 00 00    	jne    801007a8 <cprintf+0xf8>
  if (fmt == 0)
801006c9:	8b 45 08             	mov    0x8(%ebp),%eax
801006cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006cf:	85 c0                	test   %eax,%eax
801006d1:	0f 84 5e 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d7:	0f b6 00             	movzbl (%eax),%eax
801006da:	85 c0                	test   %eax,%eax
801006dc:	74 32                	je     80100710 <cprintf+0x60>
  argp = (uint*)(void*)(&fmt + 1);
801006de:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e1:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e3:	83 f8 25             	cmp    $0x25,%eax
801006e6:	74 40                	je     80100728 <cprintf+0x78>
  if(panicked){
801006e8:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801006ee:	85 c9                	test   %ecx,%ecx
801006f0:	74 0b                	je     801006fd <cprintf+0x4d>
801006f2:	fa                   	cli    
      ;
801006f3:	eb fe                	jmp    801006f3 <cprintf+0x43>
801006f5:	8d 76 00             	lea    0x0(%esi),%esi
801006f8:	b8 25 00 00 00       	mov    $0x25,%eax
801006fd:	e8 0e fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100702:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100705:	83 c6 01             	add    $0x1,%esi
80100708:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
8010070c:	85 c0                	test   %eax,%eax
8010070e:	75 d3                	jne    801006e3 <cprintf+0x33>
  if(locking)
80100710:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80100713:	85 db                	test   %ebx,%ebx
80100715:	0f 85 05 01 00 00    	jne    80100820 <cprintf+0x170>
}
8010071b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010071e:	5b                   	pop    %ebx
8010071f:	5e                   	pop    %esi
80100720:	5f                   	pop    %edi
80100721:	5d                   	pop    %ebp
80100722:	c3                   	ret    
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[++i] & 0xff;
80100728:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010072b:	83 c6 01             	add    $0x1,%esi
8010072e:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
80100732:	85 ff                	test   %edi,%edi
80100734:	74 da                	je     80100710 <cprintf+0x60>
    switch(c){
80100736:	83 ff 70             	cmp    $0x70,%edi
80100739:	0f 84 7e 00 00 00    	je     801007bd <cprintf+0x10d>
8010073f:	7f 26                	jg     80100767 <cprintf+0xb7>
80100741:	83 ff 25             	cmp    $0x25,%edi
80100744:	0f 84 be 00 00 00    	je     80100808 <cprintf+0x158>
8010074a:	83 ff 64             	cmp    $0x64,%edi
8010074d:	75 46                	jne    80100795 <cprintf+0xe5>
      printint(*argp++, 10, 1);
8010074f:	8b 03                	mov    (%ebx),%eax
80100751:	8d 7b 04             	lea    0x4(%ebx),%edi
80100754:	b9 01 00 00 00       	mov    $0x1,%ecx
80100759:	ba 0a 00 00 00       	mov    $0xa,%edx
8010075e:	89 fb                	mov    %edi,%ebx
80100760:	e8 3b fe ff ff       	call   801005a0 <printint>
      break;
80100765:	eb 9b                	jmp    80100702 <cprintf+0x52>
80100767:	83 ff 73             	cmp    $0x73,%edi
8010076a:	75 24                	jne    80100790 <cprintf+0xe0>
      if((s = (char*)*argp++) == 0)
8010076c:	8d 7b 04             	lea    0x4(%ebx),%edi
8010076f:	8b 1b                	mov    (%ebx),%ebx
80100771:	85 db                	test   %ebx,%ebx
80100773:	75 68                	jne    801007dd <cprintf+0x12d>
80100775:	b8 28 00 00 00       	mov    $0x28,%eax
        s = "(null)";
8010077a:	bb 18 72 10 80       	mov    $0x80107218,%ebx
  if(panicked){
8010077f:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100785:	85 d2                	test   %edx,%edx
80100787:	74 4c                	je     801007d5 <cprintf+0x125>
80100789:	fa                   	cli    
      ;
8010078a:	eb fe                	jmp    8010078a <cprintf+0xda>
8010078c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100790:	83 ff 78             	cmp    $0x78,%edi
80100793:	74 28                	je     801007bd <cprintf+0x10d>
  if(panicked){
80100795:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
8010079b:	85 d2                	test   %edx,%edx
8010079d:	74 4c                	je     801007eb <cprintf+0x13b>
8010079f:	fa                   	cli    
      ;
801007a0:	eb fe                	jmp    801007a0 <cprintf+0xf0>
801007a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&cons.lock);
801007a8:	83 ec 0c             	sub    $0xc,%esp
801007ab:	68 20 a5 10 80       	push   $0x8010a520
801007b0:	e8 0b 3e 00 00       	call   801045c0 <acquire>
801007b5:	83 c4 10             	add    $0x10,%esp
801007b8:	e9 0c ff ff ff       	jmp    801006c9 <cprintf+0x19>
      printint(*argp++, 16, 0);
801007bd:	8b 03                	mov    (%ebx),%eax
801007bf:	8d 7b 04             	lea    0x4(%ebx),%edi
801007c2:	31 c9                	xor    %ecx,%ecx
801007c4:	ba 10 00 00 00       	mov    $0x10,%edx
801007c9:	89 fb                	mov    %edi,%ebx
801007cb:	e8 d0 fd ff ff       	call   801005a0 <printint>
      break;
801007d0:	e9 2d ff ff ff       	jmp    80100702 <cprintf+0x52>
801007d5:	e8 36 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007da:	83 c3 01             	add    $0x1,%ebx
801007dd:	0f be 03             	movsbl (%ebx),%eax
801007e0:	84 c0                	test   %al,%al
801007e2:	75 9b                	jne    8010077f <cprintf+0xcf>
      if((s = (char*)*argp++) == 0)
801007e4:	89 fb                	mov    %edi,%ebx
801007e6:	e9 17 ff ff ff       	jmp    80100702 <cprintf+0x52>
801007eb:	b8 25 00 00 00       	mov    $0x25,%eax
801007f0:	e8 1b fc ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
801007f5:	a1 58 a5 10 80       	mov    0x8010a558,%eax
801007fa:	85 c0                	test   %eax,%eax
801007fc:	74 4a                	je     80100848 <cprintf+0x198>
801007fe:	fa                   	cli    
      ;
801007ff:	eb fe                	jmp    801007ff <cprintf+0x14f>
80100801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
80100808:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
8010080e:	85 c9                	test   %ecx,%ecx
80100810:	0f 84 e2 fe ff ff    	je     801006f8 <cprintf+0x48>
80100816:	fa                   	cli    
      ;
80100817:	eb fe                	jmp    80100817 <cprintf+0x167>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 a5 10 80       	push   $0x8010a520
80100828:	e8 b3 3e 00 00       	call   801046e0 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 e6 fe ff ff       	jmp    8010071b <cprintf+0x6b>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 1f 72 10 80       	push   $0x8010721f
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 ae fe ff ff       	jmp    80100702 <cprintf+0x52>
80100854:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010085a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100860 <consoleintr>:
{
80100860:	55                   	push   %ebp
80100861:	89 e5                	mov    %esp,%ebp
80100863:	57                   	push   %edi
80100864:	56                   	push   %esi
  int c, doprocdump = 0;
80100865:	31 f6                	xor    %esi,%esi
{
80100867:	53                   	push   %ebx
80100868:	83 ec 18             	sub    $0x18,%esp
8010086b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010086e:	68 20 a5 10 80       	push   $0x8010a520
80100873:	e8 48 3d 00 00       	call   801045c0 <acquire>
  while((c = getc()) >= 0){
80100878:	83 c4 10             	add    $0x10,%esp
8010087b:	ff d7                	call   *%edi
8010087d:	89 c3                	mov    %eax,%ebx
8010087f:	85 c0                	test   %eax,%eax
80100881:	0f 88 38 01 00 00    	js     801009bf <consoleintr+0x15f>
    switch(c){
80100887:	83 fb 10             	cmp    $0x10,%ebx
8010088a:	0f 84 f0 00 00 00    	je     80100980 <consoleintr+0x120>
80100890:	0f 8e ba 00 00 00    	jle    80100950 <consoleintr+0xf0>
80100896:	83 fb 15             	cmp    $0x15,%ebx
80100899:	75 35                	jne    801008d0 <consoleintr+0x70>
      while(input.e != input.w &&
8010089b:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008a0:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
801008a6:	74 d3                	je     8010087b <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008a8:	83 e8 01             	sub    $0x1,%eax
801008ab:	89 c2                	mov    %eax,%edx
801008ad:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801008b0:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
801008b7:	74 c2                	je     8010087b <consoleintr+0x1b>
  if(panicked){
801008b9:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
        input.e--;
801008bf:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
801008c4:	85 d2                	test   %edx,%edx
801008c6:	0f 84 be 00 00 00    	je     8010098a <consoleintr+0x12a>
801008cc:	fa                   	cli    
      ;
801008cd:	eb fe                	jmp    801008cd <consoleintr+0x6d>
801008cf:	90                   	nop
801008d0:	83 fb 7f             	cmp    $0x7f,%ebx
801008d3:	0f 84 7c 00 00 00    	je     80100955 <consoleintr+0xf5>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d9:	85 db                	test   %ebx,%ebx
801008db:	74 9e                	je     8010087b <consoleintr+0x1b>
801008dd:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008e2:	89 c2                	mov    %eax,%edx
801008e4:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008ea:	83 fa 7f             	cmp    $0x7f,%edx
801008ed:	77 8c                	ja     8010087b <consoleintr+0x1b>
        c = (c == '\r') ? '\n' : c;
801008ef:	8d 48 01             	lea    0x1(%eax),%ecx
801008f2:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801008f8:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008fb:	89 0d a8 ff 10 80    	mov    %ecx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
80100901:	83 fb 0d             	cmp    $0xd,%ebx
80100904:	0f 84 d1 00 00 00    	je     801009db <consoleintr+0x17b>
        input.buf[input.e++ % INPUT_BUF] = c;
8010090a:	88 98 20 ff 10 80    	mov    %bl,-0x7fef00e0(%eax)
  if(panicked){
80100910:	85 d2                	test   %edx,%edx
80100912:	0f 85 ce 00 00 00    	jne    801009e6 <consoleintr+0x186>
80100918:	89 d8                	mov    %ebx,%eax
8010091a:	e8 f1 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010091f:	83 fb 0a             	cmp    $0xa,%ebx
80100922:	0f 84 d2 00 00 00    	je     801009fa <consoleintr+0x19a>
80100928:	83 fb 04             	cmp    $0x4,%ebx
8010092b:	0f 84 c9 00 00 00    	je     801009fa <consoleintr+0x19a>
80100931:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
80100936:	83 e8 80             	sub    $0xffffff80,%eax
80100939:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
8010093f:	0f 85 36 ff ff ff    	jne    8010087b <consoleintr+0x1b>
80100945:	e9 b5 00 00 00       	jmp    801009ff <consoleintr+0x19f>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100950:	83 fb 08             	cmp    $0x8,%ebx
80100953:	75 84                	jne    801008d9 <consoleintr+0x79>
      if(input.e != input.w){
80100955:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010095a:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100960:	0f 84 15 ff ff ff    	je     8010087b <consoleintr+0x1b>
        input.e--;
80100966:	83 e8 01             	sub    $0x1,%eax
80100969:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
8010096e:	a1 58 a5 10 80       	mov    0x8010a558,%eax
80100973:	85 c0                	test   %eax,%eax
80100975:	74 39                	je     801009b0 <consoleintr+0x150>
80100977:	fa                   	cli    
      ;
80100978:	eb fe                	jmp    80100978 <consoleintr+0x118>
8010097a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      doprocdump = 1;
80100980:	be 01 00 00 00       	mov    $0x1,%esi
80100985:	e9 f1 fe ff ff       	jmp    8010087b <consoleintr+0x1b>
8010098a:	b8 00 01 00 00       	mov    $0x100,%eax
8010098f:	e8 7c fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
80100994:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100999:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010099f:	0f 85 03 ff ff ff    	jne    801008a8 <consoleintr+0x48>
801009a5:	e9 d1 fe ff ff       	jmp    8010087b <consoleintr+0x1b>
801009aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801009b0:	b8 00 01 00 00       	mov    $0x100,%eax
801009b5:	e8 56 fa ff ff       	call   80100410 <consputc.part.0>
801009ba:	e9 bc fe ff ff       	jmp    8010087b <consoleintr+0x1b>
  release(&cons.lock);
801009bf:	83 ec 0c             	sub    $0xc,%esp
801009c2:	68 20 a5 10 80       	push   $0x8010a520
801009c7:	e8 14 3d 00 00       	call   801046e0 <release>
  if(doprocdump) {
801009cc:	83 c4 10             	add    $0x10,%esp
801009cf:	85 f6                	test   %esi,%esi
801009d1:	75 46                	jne    80100a19 <consoleintr+0x1b9>
}
801009d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009d6:	5b                   	pop    %ebx
801009d7:	5e                   	pop    %esi
801009d8:	5f                   	pop    %edi
801009d9:	5d                   	pop    %ebp
801009da:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009db:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
  if(panicked){
801009e2:	85 d2                	test   %edx,%edx
801009e4:	74 0a                	je     801009f0 <consoleintr+0x190>
801009e6:	fa                   	cli    
      ;
801009e7:	eb fe                	jmp    801009e7 <consoleintr+0x187>
801009e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f0:	b8 0a 00 00 00       	mov    $0xa,%eax
801009f5:	e8 16 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009fa:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
          wakeup(&input.r);
801009ff:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a02:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100a07:	68 a0 ff 10 80       	push   $0x8010ffa0
80100a0c:	e8 5f 36 00 00       	call   80104070 <wakeup>
80100a11:	83 c4 10             	add    $0x10,%esp
80100a14:	e9 62 fe ff ff       	jmp    8010087b <consoleintr+0x1b>
}
80100a19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a1c:	5b                   	pop    %ebx
80100a1d:	5e                   	pop    %esi
80100a1e:	5f                   	pop    %edi
80100a1f:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a20:	e9 cb 38 00 00       	jmp    801042f0 <procdump>
80100a25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	55                   	push   %ebp
80100a31:	89 e5                	mov    %esp,%ebp
80100a33:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a36:	68 28 72 10 80       	push   $0x80107228
80100a3b:	68 20 a5 10 80       	push   $0x8010a520
80100a40:	e8 7b 3a 00 00       	call   801044c0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a45:	58                   	pop    %eax
80100a46:	5a                   	pop    %edx
80100a47:	6a 00                	push   $0x0
80100a49:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4b:	c7 05 6c 09 11 80 30 	movl   $0x80100630,0x8011096c
80100a52:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a55:	c7 05 68 09 11 80 80 	movl   $0x80100280,0x80110968
80100a5c:	02 10 80 
  cons.locking = 1;
80100a5f:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100a66:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a69:	e8 52 19 00 00       	call   801023c0 <ioapicenable>
}
80100a6e:	83 c4 10             	add    $0x10,%esp
80100a71:	c9                   	leave  
80100a72:	c3                   	ret    
80100a73:	66 90                	xchg   %ax,%ax
80100a75:	66 90                	xchg   %ax,%ax
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	55                   	push   %ebp
80100a81:	89 e5                	mov    %esp,%ebp
80100a83:	57                   	push   %edi
80100a84:	56                   	push   %esi
80100a85:	53                   	push   %ebx
80100a86:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a8c:	e8 6f 2e 00 00       	call   80103900 <myproc>
80100a91:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a97:	e8 14 22 00 00       	call   80102cb0 <begin_op>

  if((ip = namei(path)) == 0){
80100a9c:	83 ec 0c             	sub    $0xc,%esp
80100a9f:	ff 75 08             	pushl  0x8(%ebp)
80100aa2:	e8 29 15 00 00       	call   80101fd0 <namei>
80100aa7:	83 c4 10             	add    $0x10,%esp
80100aaa:	85 c0                	test   %eax,%eax
80100aac:	0f 84 09 03 00 00    	je     80100dbb <exec+0x33b>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab2:	83 ec 0c             	sub    $0xc,%esp
80100ab5:	89 c3                	mov    %eax,%ebx
80100ab7:	50                   	push   %eax
80100ab8:	e8 73 0c 00 00       	call   80101730 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100abd:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac3:	6a 34                	push   $0x34
80100ac5:	6a 00                	push   $0x0
80100ac7:	50                   	push   %eax
80100ac8:	53                   	push   %ebx
80100ac9:	e8 42 0f 00 00       	call   80101a10 <readi>
80100ace:	83 c4 20             	add    $0x20,%esp
80100ad1:	83 f8 34             	cmp    $0x34,%eax
80100ad4:	74 22                	je     80100af8 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ad6:	83 ec 0c             	sub    $0xc,%esp
80100ad9:	53                   	push   %ebx
80100ada:	e8 e1 0e 00 00       	call   801019c0 <iunlockput>
    end_op();
80100adf:	e8 3c 22 00 00       	call   80102d20 <end_op>
80100ae4:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100ae7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100aec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100aef:	5b                   	pop    %ebx
80100af0:	5e                   	pop    %esi
80100af1:	5f                   	pop    %edi
80100af2:	5d                   	pop    %ebp
80100af3:	c3                   	ret    
80100af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100af8:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100aff:	45 4c 46 
80100b02:	75 d2                	jne    80100ad6 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b04:	e8 37 64 00 00       	call   80106f40 <setupkvm>
80100b09:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b0f:	85 c0                	test   %eax,%eax
80100b11:	74 c3                	je     80100ad6 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b13:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b1a:	00 
80100b1b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b21:	0f 84 b3 02 00 00    	je     80100dda <exec+0x35a>
  sz = 0;
80100b27:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b2e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b31:	31 ff                	xor    %edi,%edi
80100b33:	e9 8e 00 00 00       	jmp    80100bc6 <exec+0x146>
80100b38:	90                   	nop
80100b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 e8 61 00 00       	call   80106d60 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 f2 60 00 00       	call   80106ca0 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 3a 0e 00 00       	call   80101a10 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 d0 62 00 00       	call   80106ec0 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 de fe ff ff       	jmp    80100ad6 <exec+0x56>
80100bf8:	90                   	nop
80100bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 9f 0d 00 00       	call   801019c0 <iunlockput>
  end_op();
80100c21:	e8 fa 20 00 00       	call   80102d20 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 29 61 00 00       	call   80106d60 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 94 00 00 00    	je     80100cd8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c53:	e8 88 63 00 00       	call   80106fe0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c64:	8b 00                	mov    (%eax),%eax
80100c66:	85 c0                	test   %eax,%eax
80100c68:	0f 84 8b 00 00 00    	je     80100cf9 <exec+0x279>
80100c6e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c74:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7a:	eb 23                	jmp    80100c9f <exec+0x21f>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 59                	je     80100cf3 <exec+0x273>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 39                	je     80100cd8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 88 3c 00 00       	call   80104930 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 75 3c 00 00       	call   80104930 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 64 64 00 00       	call   80107130 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	90                   	nop
80100cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 da 61 00 00       	call   80106ec0 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 f9 fd ff ff       	jmp    80100aec <exec+0x6c>
80100cf3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d00:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d02:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d09:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d0d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d0f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d12:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d18:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d1a:	50                   	push   %eax
80100d1b:	52                   	push   %edx
80100d1c:	53                   	push   %ebx
80100d1d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d33:	e8 f8 63 00 00       	call   80107130 <copyout>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	85 c0                	test   %eax,%eax
80100d3d:	78 99                	js     80100cd8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d42:	8b 55 08             	mov    0x8(%ebp),%edx
80100d45:	0f b6 00             	movzbl (%eax),%eax
80100d48:	84 c0                	test   %al,%al
80100d4a:	74 13                	je     80100d5f <exec+0x2df>
80100d4c:	89 d1                	mov    %edx,%ecx
80100d4e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 c0 6c             	add    $0x6c,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 7a 3b 00 00       	call   801048f0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d81:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d83:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d86:	89 c1                	mov    %eax,%ecx
80100d88:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d8e:	8b 40 18             	mov    0x18(%eax),%eax
80100d91:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d94:	8b 41 18             	mov    0x18(%ecx),%eax
80100d97:	89 58 44             	mov    %ebx,0x44(%eax)
  curproc->priority = 2;
80100d9a:	c7 41 7c 02 00 00 00 	movl   $0x2,0x7c(%ecx)
  switchuvm(curproc);
80100da1:	89 0c 24             	mov    %ecx,(%esp)
80100da4:	e8 67 5d 00 00       	call   80106b10 <switchuvm>
  freevm(oldpgdir);
80100da9:	89 3c 24             	mov    %edi,(%esp)
80100dac:	e8 0f 61 00 00       	call   80106ec0 <freevm>
  return 0;
80100db1:	83 c4 10             	add    $0x10,%esp
80100db4:	31 c0                	xor    %eax,%eax
80100db6:	e9 31 fd ff ff       	jmp    80100aec <exec+0x6c>
    end_op();
80100dbb:	e8 60 1f 00 00       	call   80102d20 <end_op>
    cprintf("exec: fail\n");
80100dc0:	83 ec 0c             	sub    $0xc,%esp
80100dc3:	68 41 72 10 80       	push   $0x80107241
80100dc8:	e8 e3 f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dcd:	83 c4 10             	add    $0x10,%esp
80100dd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dd5:	e9 12 fd ff ff       	jmp    80100aec <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dda:	31 ff                	xor    %edi,%edi
80100ddc:	be 00 20 00 00       	mov    $0x2000,%esi
80100de1:	e9 32 fe ff ff       	jmp    80100c18 <exec+0x198>
80100de6:	66 90                	xchg   %ax,%ax
80100de8:	66 90                	xchg   %ax,%ax
80100dea:	66 90                	xchg   %ax,%ax
80100dec:	66 90                	xchg   %ax,%ax
80100dee:	66 90                	xchg   %ax,%ax

80100df0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100df6:	68 4d 72 10 80       	push   $0x8010724d
80100dfb:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e00:	e8 bb 36 00 00       	call   801044c0 <initlock>
}
80100e05:	83 c4 10             	add    $0x10,%esp
80100e08:	c9                   	leave  
80100e09:	c3                   	ret    
80100e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e10 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e14:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100e19:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e1c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e21:	e8 9a 37 00 00       	call   801045c0 <acquire>
80100e26:	83 c4 10             	add    $0x10,%esp
80100e29:	eb 10                	jmp    80100e3b <filealloc+0x2b>
80100e2b:	90                   	nop
80100e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e30:	83 c3 18             	add    $0x18,%ebx
80100e33:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100e39:	74 25                	je     80100e60 <filealloc+0x50>
    if(f->ref == 0){
80100e3b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e3e:	85 c0                	test   %eax,%eax
80100e40:	75 ee                	jne    80100e30 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e42:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e45:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e4c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e51:	e8 8a 38 00 00       	call   801046e0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e56:	89 d8                	mov    %ebx,%eax
      return f;
80100e58:	83 c4 10             	add    $0x10,%esp
}
80100e5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e5e:	c9                   	leave  
80100e5f:	c3                   	ret    
  release(&ftable.lock);
80100e60:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e63:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e65:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e6a:	e8 71 38 00 00       	call   801046e0 <release>
}
80100e6f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e71:	83 c4 10             	add    $0x10,%esp
}
80100e74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e77:	c9                   	leave  
80100e78:	c3                   	ret    
80100e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e80 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e80:	55                   	push   %ebp
80100e81:	89 e5                	mov    %esp,%ebp
80100e83:	53                   	push   %ebx
80100e84:	83 ec 10             	sub    $0x10,%esp
80100e87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e8a:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e8f:	e8 2c 37 00 00       	call   801045c0 <acquire>
  if(f->ref < 1)
80100e94:	8b 43 04             	mov    0x4(%ebx),%eax
80100e97:	83 c4 10             	add    $0x10,%esp
80100e9a:	85 c0                	test   %eax,%eax
80100e9c:	7e 1a                	jle    80100eb8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e9e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ea1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ea4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ea7:	68 c0 ff 10 80       	push   $0x8010ffc0
80100eac:	e8 2f 38 00 00       	call   801046e0 <release>
  return f;
}
80100eb1:	89 d8                	mov    %ebx,%eax
80100eb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eb6:	c9                   	leave  
80100eb7:	c3                   	ret    
    panic("filedup");
80100eb8:	83 ec 0c             	sub    $0xc,%esp
80100ebb:	68 54 72 10 80       	push   $0x80107254
80100ec0:	e8 cb f4 ff ff       	call   80100390 <panic>
80100ec5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100ed0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ed0:	55                   	push   %ebp
80100ed1:	89 e5                	mov    %esp,%ebp
80100ed3:	57                   	push   %edi
80100ed4:	56                   	push   %esi
80100ed5:	53                   	push   %ebx
80100ed6:	83 ec 28             	sub    $0x28,%esp
80100ed9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100edc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ee1:	e8 da 36 00 00       	call   801045c0 <acquire>
  if(f->ref < 1)
80100ee6:	8b 43 04             	mov    0x4(%ebx),%eax
80100ee9:	83 c4 10             	add    $0x10,%esp
80100eec:	85 c0                	test   %eax,%eax
80100eee:	0f 8e a3 00 00 00    	jle    80100f97 <fileclose+0xc7>
    panic("fileclose");
  if(--f->ref > 0){
80100ef4:	83 e8 01             	sub    $0x1,%eax
80100ef7:	89 43 04             	mov    %eax,0x4(%ebx)
80100efa:	75 44                	jne    80100f40 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100efc:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f00:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f03:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f05:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f0b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f0e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f11:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f14:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100f19:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f1c:	e8 bf 37 00 00       	call   801046e0 <release>

  if(ff.type == FD_PIPE)
80100f21:	83 c4 10             	add    $0x10,%esp
80100f24:	83 ff 01             	cmp    $0x1,%edi
80100f27:	74 2f                	je     80100f58 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f29:	83 ff 02             	cmp    $0x2,%edi
80100f2c:	74 4a                	je     80100f78 <fileclose+0xa8>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f31:	5b                   	pop    %ebx
80100f32:	5e                   	pop    %esi
80100f33:	5f                   	pop    %edi
80100f34:	5d                   	pop    %ebp
80100f35:	c3                   	ret    
80100f36:	8d 76 00             	lea    0x0(%esi),%esi
80100f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    release(&ftable.lock);
80100f40:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
}
80100f47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f4a:	5b                   	pop    %ebx
80100f4b:	5e                   	pop    %esi
80100f4c:	5f                   	pop    %edi
80100f4d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f4e:	e9 8d 37 00 00       	jmp    801046e0 <release>
80100f53:	90                   	nop
80100f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pipeclose(ff.pipe, ff.writable);
80100f58:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f5c:	83 ec 08             	sub    $0x8,%esp
80100f5f:	53                   	push   %ebx
80100f60:	56                   	push   %esi
80100f61:	e8 fa 24 00 00       	call   80103460 <pipeclose>
80100f66:	83 c4 10             	add    $0x10,%esp
}
80100f69:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6c:	5b                   	pop    %ebx
80100f6d:	5e                   	pop    %esi
80100f6e:	5f                   	pop    %edi
80100f6f:	5d                   	pop    %ebp
80100f70:	c3                   	ret    
80100f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f78:	e8 33 1d 00 00       	call   80102cb0 <begin_op>
    iput(ff.ip);
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	pushl  -0x20(%ebp)
80100f83:	e8 d8 08 00 00       	call   80101860 <iput>
    end_op();
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
    end_op();
80100f92:	e9 89 1d 00 00       	jmp    80102d20 <end_op>
    panic("fileclose");
80100f97:	83 ec 0c             	sub    $0xc,%esp
80100f9a:	68 5c 72 10 80       	push   $0x8010725c
80100f9f:	e8 ec f3 ff ff       	call   80100390 <panic>
80100fa4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100faa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100fb0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fb0:	55                   	push   %ebp
80100fb1:	89 e5                	mov    %esp,%ebp
80100fb3:	53                   	push   %ebx
80100fb4:	83 ec 04             	sub    $0x4,%esp
80100fb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fba:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fbd:	75 31                	jne    80100ff0 <filestat+0x40>
    ilock(f->ip);
80100fbf:	83 ec 0c             	sub    $0xc,%esp
80100fc2:	ff 73 10             	pushl  0x10(%ebx)
80100fc5:	e8 66 07 00 00       	call   80101730 <ilock>
    stati(f->ip, st);
80100fca:	58                   	pop    %eax
80100fcb:	5a                   	pop    %edx
80100fcc:	ff 75 0c             	pushl  0xc(%ebp)
80100fcf:	ff 73 10             	pushl  0x10(%ebx)
80100fd2:	e8 09 0a 00 00       	call   801019e0 <stati>
    iunlock(f->ip);
80100fd7:	59                   	pop    %ecx
80100fd8:	ff 73 10             	pushl  0x10(%ebx)
80100fdb:	e8 30 08 00 00       	call   80101810 <iunlock>
    return 0;
80100fe0:	83 c4 10             	add    $0x10,%esp
80100fe3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100fe5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fe8:	c9                   	leave  
80100fe9:	c3                   	ret    
80100fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100ff0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100ff5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ff8:	c9                   	leave  
80100ff9:	c3                   	ret    
80100ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101000 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101000:	55                   	push   %ebp
80101001:	89 e5                	mov    %esp,%ebp
80101003:	57                   	push   %edi
80101004:	56                   	push   %esi
80101005:	53                   	push   %ebx
80101006:	83 ec 0c             	sub    $0xc,%esp
80101009:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010100c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010100f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101012:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101016:	74 60                	je     80101078 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101018:	8b 03                	mov    (%ebx),%eax
8010101a:	83 f8 01             	cmp    $0x1,%eax
8010101d:	74 41                	je     80101060 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101f:	83 f8 02             	cmp    $0x2,%eax
80101022:	75 5b                	jne    8010107f <fileread+0x7f>
    ilock(f->ip);
80101024:	83 ec 0c             	sub    $0xc,%esp
80101027:	ff 73 10             	pushl  0x10(%ebx)
8010102a:	e8 01 07 00 00       	call   80101730 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010102f:	57                   	push   %edi
80101030:	ff 73 14             	pushl  0x14(%ebx)
80101033:	56                   	push   %esi
80101034:	ff 73 10             	pushl  0x10(%ebx)
80101037:	e8 d4 09 00 00       	call   80101a10 <readi>
8010103c:	83 c4 20             	add    $0x20,%esp
8010103f:	89 c6                	mov    %eax,%esi
80101041:	85 c0                	test   %eax,%eax
80101043:	7e 03                	jle    80101048 <fileread+0x48>
      f->off += r;
80101045:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101048:	83 ec 0c             	sub    $0xc,%esp
8010104b:	ff 73 10             	pushl  0x10(%ebx)
8010104e:	e8 bd 07 00 00       	call   80101810 <iunlock>
    return r;
80101053:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101056:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101059:	89 f0                	mov    %esi,%eax
8010105b:	5b                   	pop    %ebx
8010105c:	5e                   	pop    %esi
8010105d:	5f                   	pop    %edi
8010105e:	5d                   	pop    %ebp
8010105f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101060:	8b 43 0c             	mov    0xc(%ebx),%eax
80101063:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101066:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101069:	5b                   	pop    %ebx
8010106a:	5e                   	pop    %esi
8010106b:	5f                   	pop    %edi
8010106c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010106d:	e9 9e 25 00 00       	jmp    80103610 <piperead>
80101072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101078:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010107d:	eb d7                	jmp    80101056 <fileread+0x56>
  panic("fileread");
8010107f:	83 ec 0c             	sub    $0xc,%esp
80101082:	68 66 72 10 80       	push   $0x80107266
80101087:	e8 04 f3 ff ff       	call   80100390 <panic>
8010108c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101090 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101090:	55                   	push   %ebp
80101091:	89 e5                	mov    %esp,%ebp
80101093:	57                   	push   %edi
80101094:	56                   	push   %esi
80101095:	53                   	push   %ebx
80101096:	83 ec 1c             	sub    $0x1c,%esp
80101099:	8b 45 0c             	mov    0xc(%ebp),%eax
8010109c:	8b 75 08             	mov    0x8(%ebp),%esi
8010109f:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010a2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010a5:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010ac:	0f 84 bb 00 00 00    	je     8010116d <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
801010b2:	8b 06                	mov    (%esi),%eax
801010b4:	83 f8 01             	cmp    $0x1,%eax
801010b7:	0f 84 bf 00 00 00    	je     8010117c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010bd:	83 f8 02             	cmp    $0x2,%eax
801010c0:	0f 85 c8 00 00 00    	jne    8010118e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010c9:	31 ff                	xor    %edi,%edi
    while(i < n){
801010cb:	85 c0                	test   %eax,%eax
801010cd:	7f 30                	jg     801010ff <filewrite+0x6f>
801010cf:	e9 94 00 00 00       	jmp    80101168 <filewrite+0xd8>
801010d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010d8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010db:	83 ec 0c             	sub    $0xc,%esp
801010de:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010e4:	e8 27 07 00 00       	call   80101810 <iunlock>
      end_op();
801010e9:	e8 32 1c 00 00       	call   80102d20 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801010ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010f1:	83 c4 10             	add    $0x10,%esp
801010f4:	39 c3                	cmp    %eax,%ebx
801010f6:	75 60                	jne    80101158 <filewrite+0xc8>
        panic("short filewrite");
      i += r;
801010f8:	01 df                	add    %ebx,%edi
    while(i < n){
801010fa:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010fd:	7e 69                	jle    80101168 <filewrite+0xd8>
      int n1 = n - i;
801010ff:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101102:	b8 00 06 00 00       	mov    $0x600,%eax
80101107:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101109:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
8010110f:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101112:	e8 99 1b 00 00       	call   80102cb0 <begin_op>
      ilock(f->ip);
80101117:	83 ec 0c             	sub    $0xc,%esp
8010111a:	ff 76 10             	pushl  0x10(%esi)
8010111d:	e8 0e 06 00 00       	call   80101730 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101122:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101125:	53                   	push   %ebx
80101126:	ff 76 14             	pushl  0x14(%esi)
80101129:	01 f8                	add    %edi,%eax
8010112b:	50                   	push   %eax
8010112c:	ff 76 10             	pushl  0x10(%esi)
8010112f:	e8 dc 09 00 00       	call   80101b10 <writei>
80101134:	83 c4 20             	add    $0x20,%esp
80101137:	85 c0                	test   %eax,%eax
80101139:	7f 9d                	jg     801010d8 <filewrite+0x48>
      iunlock(f->ip);
8010113b:	83 ec 0c             	sub    $0xc,%esp
8010113e:	ff 76 10             	pushl  0x10(%esi)
80101141:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101144:	e8 c7 06 00 00       	call   80101810 <iunlock>
      end_op();
80101149:	e8 d2 1b 00 00       	call   80102d20 <end_op>
      if(r < 0)
8010114e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101151:	83 c4 10             	add    $0x10,%esp
80101154:	85 c0                	test   %eax,%eax
80101156:	75 15                	jne    8010116d <filewrite+0xdd>
        panic("short filewrite");
80101158:	83 ec 0c             	sub    $0xc,%esp
8010115b:	68 6f 72 10 80       	push   $0x8010726f
80101160:	e8 2b f2 ff ff       	call   80100390 <panic>
80101165:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101168:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
8010116b:	74 05                	je     80101172 <filewrite+0xe2>
    return -1;
8010116d:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  }
  panic("filewrite");
}
80101172:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101175:	89 f8                	mov    %edi,%eax
80101177:	5b                   	pop    %ebx
80101178:	5e                   	pop    %esi
80101179:	5f                   	pop    %edi
8010117a:	5d                   	pop    %ebp
8010117b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010117c:	8b 46 0c             	mov    0xc(%esi),%eax
8010117f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101182:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101185:	5b                   	pop    %ebx
80101186:	5e                   	pop    %esi
80101187:	5f                   	pop    %edi
80101188:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101189:	e9 72 23 00 00       	jmp    80103500 <pipewrite>
  panic("filewrite");
8010118e:	83 ec 0c             	sub    $0xc,%esp
80101191:	68 75 72 10 80       	push   $0x80107275
80101196:	e8 f5 f1 ff ff       	call   80100390 <panic>
8010119b:	66 90                	xchg   %ax,%ax
8010119d:	66 90                	xchg   %ax,%ax
8010119f:	90                   	nop

801011a0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801011a0:	55                   	push   %ebp
801011a1:	89 e5                	mov    %esp,%ebp
801011a3:	57                   	push   %edi
801011a4:	56                   	push   %esi
801011a5:	53                   	push   %ebx
801011a6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011a9:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
801011af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011b2:	85 c9                	test   %ecx,%ecx
801011b4:	0f 84 87 00 00 00    	je     80101241 <balloc+0xa1>
801011ba:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011c1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011c4:	83 ec 08             	sub    $0x8,%esp
801011c7:	89 f0                	mov    %esi,%eax
801011c9:	c1 f8 0c             	sar    $0xc,%eax
801011cc:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011d2:	50                   	push   %eax
801011d3:	ff 75 d8             	pushl  -0x28(%ebp)
801011d6:	e8 f5 ee ff ff       	call   801000d0 <bread>
801011db:	83 c4 10             	add    $0x10,%esp
801011de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011e1:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011e9:	31 c0                	xor    %eax,%eax
801011eb:	eb 2f                	jmp    8010121c <balloc+0x7c>
801011ed:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011f0:	89 c1                	mov    %eax,%ecx
801011f2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801011fa:	83 e1 07             	and    $0x7,%ecx
801011fd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011ff:	89 c1                	mov    %eax,%ecx
80101201:	c1 f9 03             	sar    $0x3,%ecx
80101204:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101209:	89 fa                	mov    %edi,%edx
8010120b:	85 df                	test   %ebx,%edi
8010120d:	74 41                	je     80101250 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010120f:	83 c0 01             	add    $0x1,%eax
80101212:	83 c6 01             	add    $0x1,%esi
80101215:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010121a:	74 05                	je     80101221 <balloc+0x81>
8010121c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010121f:	77 cf                	ja     801011f0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101221:	83 ec 0c             	sub    $0xc,%esp
80101224:	ff 75 e4             	pushl  -0x1c(%ebp)
80101227:	e8 c4 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010122c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101233:	83 c4 10             	add    $0x10,%esp
80101236:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101239:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010123f:	77 80                	ja     801011c1 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101241:	83 ec 0c             	sub    $0xc,%esp
80101244:	68 7f 72 10 80       	push   $0x8010727f
80101249:	e8 42 f1 ff ff       	call   80100390 <panic>
8010124e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101250:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101253:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101256:	09 da                	or     %ebx,%edx
80101258:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010125c:	57                   	push   %edi
8010125d:	e8 2e 1c 00 00       	call   80102e90 <log_write>
        brelse(bp);
80101262:	89 3c 24             	mov    %edi,(%esp)
80101265:	e8 86 ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010126a:	58                   	pop    %eax
8010126b:	5a                   	pop    %edx
8010126c:	56                   	push   %esi
8010126d:	ff 75 d8             	pushl  -0x28(%ebp)
80101270:	e8 5b ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101275:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101278:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010127a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010127d:	68 00 02 00 00       	push   $0x200
80101282:	6a 00                	push   $0x0
80101284:	50                   	push   %eax
80101285:	e8 a6 34 00 00       	call   80104730 <memset>
  log_write(bp);
8010128a:	89 1c 24             	mov    %ebx,(%esp)
8010128d:	e8 fe 1b 00 00       	call   80102e90 <log_write>
  brelse(bp);
80101292:	89 1c 24             	mov    %ebx,(%esp)
80101295:	e8 56 ef ff ff       	call   801001f0 <brelse>
}
8010129a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010129d:	89 f0                	mov    %esi,%eax
8010129f:	5b                   	pop    %ebx
801012a0:	5e                   	pop    %esi
801012a1:	5f                   	pop    %edi
801012a2:	5d                   	pop    %ebp
801012a3:	c3                   	ret    
801012a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801012aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801012b0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012b0:	55                   	push   %ebp
801012b1:	89 e5                	mov    %esp,%ebp
801012b3:	57                   	push   %edi
801012b4:	89 c7                	mov    %eax,%edi
801012b6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012b7:	31 f6                	xor    %esi,%esi
{
801012b9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012ba:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
801012bf:	83 ec 28             	sub    $0x28,%esp
801012c2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012c5:	68 e0 09 11 80       	push   $0x801109e0
801012ca:	e8 f1 32 00 00       	call   801045c0 <acquire>
801012cf:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012d5:	eb 1b                	jmp    801012f2 <iget+0x42>
801012d7:	89 f6                	mov    %esi,%esi
801012d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012e0:	39 3b                	cmp    %edi,(%ebx)
801012e2:	74 6c                	je     80101350 <iget+0xa0>
801012e4:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012ea:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012f0:	73 26                	jae    80101318 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012f2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012f5:	85 c9                	test   %ecx,%ecx
801012f7:	7f e7                	jg     801012e0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012f9:	85 f6                	test   %esi,%esi
801012fb:	75 e7                	jne    801012e4 <iget+0x34>
801012fd:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
80101303:	85 c9                	test   %ecx,%ecx
80101305:	75 70                	jne    80101377 <iget+0xc7>
80101307:	89 de                	mov    %ebx,%esi
80101309:	89 c3                	mov    %eax,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010130b:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101311:	72 df                	jb     801012f2 <iget+0x42>
80101313:	90                   	nop
80101314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101318:	85 f6                	test   %esi,%esi
8010131a:	74 74                	je     80101390 <iget+0xe0>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010131c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010131f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101321:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101324:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010132b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101332:	68 e0 09 11 80       	push   $0x801109e0
80101337:	e8 a4 33 00 00       	call   801046e0 <release>

  return ip;
8010133c:	83 c4 10             	add    $0x10,%esp
}
8010133f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101342:	89 f0                	mov    %esi,%eax
80101344:	5b                   	pop    %ebx
80101345:	5e                   	pop    %esi
80101346:	5f                   	pop    %edi
80101347:	5d                   	pop    %ebp
80101348:	c3                   	ret    
80101349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101350:	39 53 04             	cmp    %edx,0x4(%ebx)
80101353:	75 8f                	jne    801012e4 <iget+0x34>
      release(&icache.lock);
80101355:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101358:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010135b:	89 de                	mov    %ebx,%esi
      ip->ref++;
8010135d:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101360:	68 e0 09 11 80       	push   $0x801109e0
80101365:	e8 76 33 00 00       	call   801046e0 <release>
      return ip;
8010136a:	83 c4 10             	add    $0x10,%esp
}
8010136d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101370:	89 f0                	mov    %esi,%eax
80101372:	5b                   	pop    %ebx
80101373:	5e                   	pop    %esi
80101374:	5f                   	pop    %edi
80101375:	5d                   	pop    %ebp
80101376:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101377:	3d 34 26 11 80       	cmp    $0x80112634,%eax
8010137c:	73 12                	jae    80101390 <iget+0xe0>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010137e:	8b 48 08             	mov    0x8(%eax),%ecx
80101381:	89 c3                	mov    %eax,%ebx
80101383:	85 c9                	test   %ecx,%ecx
80101385:	0f 8f 55 ff ff ff    	jg     801012e0 <iget+0x30>
8010138b:	e9 6d ff ff ff       	jmp    801012fd <iget+0x4d>
    panic("iget: no inodes");
80101390:	83 ec 0c             	sub    $0xc,%esp
80101393:	68 95 72 10 80       	push   $0x80107295
80101398:	e8 f3 ef ff ff       	call   80100390 <panic>
8010139d:	8d 76 00             	lea    0x0(%esi),%esi

801013a0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801013a0:	55                   	push   %ebp
801013a1:	89 e5                	mov    %esp,%ebp
801013a3:	57                   	push   %edi
801013a4:	56                   	push   %esi
801013a5:	89 c6                	mov    %eax,%esi
801013a7:	53                   	push   %ebx
801013a8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801013ab:	83 fa 0b             	cmp    $0xb,%edx
801013ae:	0f 86 84 00 00 00    	jbe    80101438 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801013b4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801013b7:	83 fb 7f             	cmp    $0x7f,%ebx
801013ba:	0f 87 98 00 00 00    	ja     80101458 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801013c0:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
801013c6:	8b 00                	mov    (%eax),%eax
801013c8:	85 d2                	test   %edx,%edx
801013ca:	74 54                	je     80101420 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013cc:	83 ec 08             	sub    $0x8,%esp
801013cf:	52                   	push   %edx
801013d0:	50                   	push   %eax
801013d1:	e8 fa ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801013d6:	83 c4 10             	add    $0x10,%esp
801013d9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
801013dd:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013df:	8b 1a                	mov    (%edx),%ebx
801013e1:	85 db                	test   %ebx,%ebx
801013e3:	74 1b                	je     80101400 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801013e5:	83 ec 0c             	sub    $0xc,%esp
801013e8:	57                   	push   %edi
801013e9:	e8 02 ee ff ff       	call   801001f0 <brelse>
    return addr;
801013ee:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
801013f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013f4:	89 d8                	mov    %ebx,%eax
801013f6:	5b                   	pop    %ebx
801013f7:	5e                   	pop    %esi
801013f8:	5f                   	pop    %edi
801013f9:	5d                   	pop    %ebp
801013fa:	c3                   	ret    
801013fb:	90                   	nop
801013fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      a[bn] = addr = balloc(ip->dev);
80101400:	8b 06                	mov    (%esi),%eax
80101402:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101405:	e8 96 fd ff ff       	call   801011a0 <balloc>
8010140a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010140d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101410:	89 c3                	mov    %eax,%ebx
80101412:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101414:	57                   	push   %edi
80101415:	e8 76 1a 00 00       	call   80102e90 <log_write>
8010141a:	83 c4 10             	add    $0x10,%esp
8010141d:	eb c6                	jmp    801013e5 <bmap+0x45>
8010141f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101420:	e8 7b fd ff ff       	call   801011a0 <balloc>
80101425:	89 c2                	mov    %eax,%edx
80101427:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010142d:	8b 06                	mov    (%esi),%eax
8010142f:	eb 9b                	jmp    801013cc <bmap+0x2c>
80101431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101438:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010143b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010143e:	85 db                	test   %ebx,%ebx
80101440:	75 af                	jne    801013f1 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101442:	8b 00                	mov    (%eax),%eax
80101444:	e8 57 fd ff ff       	call   801011a0 <balloc>
80101449:	89 47 5c             	mov    %eax,0x5c(%edi)
8010144c:	89 c3                	mov    %eax,%ebx
}
8010144e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101451:	89 d8                	mov    %ebx,%eax
80101453:	5b                   	pop    %ebx
80101454:	5e                   	pop    %esi
80101455:	5f                   	pop    %edi
80101456:	5d                   	pop    %ebp
80101457:	c3                   	ret    
  panic("bmap: out of range");
80101458:	83 ec 0c             	sub    $0xc,%esp
8010145b:	68 a5 72 10 80       	push   $0x801072a5
80101460:	e8 2b ef ff ff       	call   80100390 <panic>
80101465:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101470 <readsb>:
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	56                   	push   %esi
80101474:	53                   	push   %ebx
80101475:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101478:	83 ec 08             	sub    $0x8,%esp
8010147b:	6a 01                	push   $0x1
8010147d:	ff 75 08             	pushl  0x8(%ebp)
80101480:	e8 4b ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101485:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101488:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010148a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010148d:	6a 1c                	push   $0x1c
8010148f:	50                   	push   %eax
80101490:	56                   	push   %esi
80101491:	e8 3a 33 00 00       	call   801047d0 <memmove>
  brelse(bp);
80101496:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101499:	83 c4 10             	add    $0x10,%esp
}
8010149c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010149f:	5b                   	pop    %ebx
801014a0:	5e                   	pop    %esi
801014a1:	5d                   	pop    %ebp
  brelse(bp);
801014a2:	e9 49 ed ff ff       	jmp    801001f0 <brelse>
801014a7:	89 f6                	mov    %esi,%esi
801014a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014b0 <bfree>:
{
801014b0:	55                   	push   %ebp
801014b1:	89 e5                	mov    %esp,%ebp
801014b3:	56                   	push   %esi
801014b4:	89 c6                	mov    %eax,%esi
801014b6:	53                   	push   %ebx
801014b7:	89 d3                	mov    %edx,%ebx
  readsb(dev, &sb);
801014b9:	83 ec 08             	sub    $0x8,%esp
801014bc:	68 c0 09 11 80       	push   $0x801109c0
801014c1:	50                   	push   %eax
801014c2:	e8 a9 ff ff ff       	call   80101470 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801014c7:	58                   	pop    %eax
801014c8:	5a                   	pop    %edx
801014c9:	89 da                	mov    %ebx,%edx
801014cb:	c1 ea 0c             	shr    $0xc,%edx
801014ce:	03 15 d8 09 11 80    	add    0x801109d8,%edx
801014d4:	52                   	push   %edx
801014d5:	56                   	push   %esi
801014d6:	e8 f5 eb ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801014db:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014dd:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801014e0:	ba 01 00 00 00       	mov    $0x1,%edx
801014e5:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801014e8:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801014ee:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801014f1:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801014f3:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801014f8:	85 d1                	test   %edx,%ecx
801014fa:	74 25                	je     80101521 <bfree+0x71>
  bp->data[bi/8] &= ~m;
801014fc:	f7 d2                	not    %edx
801014fe:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101500:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101503:	21 ca                	and    %ecx,%edx
80101505:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101509:	56                   	push   %esi
8010150a:	e8 81 19 00 00       	call   80102e90 <log_write>
  brelse(bp);
8010150f:	89 34 24             	mov    %esi,(%esp)
80101512:	e8 d9 ec ff ff       	call   801001f0 <brelse>
}
80101517:	83 c4 10             	add    $0x10,%esp
8010151a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010151d:	5b                   	pop    %ebx
8010151e:	5e                   	pop    %esi
8010151f:	5d                   	pop    %ebp
80101520:	c3                   	ret    
    panic("freeing free block");
80101521:	83 ec 0c             	sub    $0xc,%esp
80101524:	68 b8 72 10 80       	push   $0x801072b8
80101529:	e8 62 ee ff ff       	call   80100390 <panic>
8010152e:	66 90                	xchg   %ax,%ax

80101530 <iinit>:
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	53                   	push   %ebx
80101534:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101539:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010153c:	68 cb 72 10 80       	push   $0x801072cb
80101541:	68 e0 09 11 80       	push   $0x801109e0
80101546:	e8 75 2f 00 00       	call   801044c0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010154b:	83 c4 10             	add    $0x10,%esp
8010154e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101550:	83 ec 08             	sub    $0x8,%esp
80101553:	68 d2 72 10 80       	push   $0x801072d2
80101558:	53                   	push   %ebx
80101559:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010155f:	e8 4c 2e 00 00       	call   801043b0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101564:	83 c4 10             	add    $0x10,%esp
80101567:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
8010156d:	75 e1                	jne    80101550 <iinit+0x20>
  readsb(dev, &sb);
8010156f:	83 ec 08             	sub    $0x8,%esp
80101572:	68 c0 09 11 80       	push   $0x801109c0
80101577:	ff 75 08             	pushl  0x8(%ebp)
8010157a:	e8 f1 fe ff ff       	call   80101470 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010157f:	ff 35 d8 09 11 80    	pushl  0x801109d8
80101585:	ff 35 d4 09 11 80    	pushl  0x801109d4
8010158b:	ff 35 d0 09 11 80    	pushl  0x801109d0
80101591:	ff 35 cc 09 11 80    	pushl  0x801109cc
80101597:	ff 35 c8 09 11 80    	pushl  0x801109c8
8010159d:	ff 35 c4 09 11 80    	pushl  0x801109c4
801015a3:	ff 35 c0 09 11 80    	pushl  0x801109c0
801015a9:	68 38 73 10 80       	push   $0x80107338
801015ae:	e8 fd f0 ff ff       	call   801006b0 <cprintf>
}
801015b3:	83 c4 30             	add    $0x30,%esp
801015b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015b9:	c9                   	leave  
801015ba:	c3                   	ret    
801015bb:	90                   	nop
801015bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801015c0 <ialloc>:
{
801015c0:	55                   	push   %ebp
801015c1:	89 e5                	mov    %esp,%ebp
801015c3:	57                   	push   %edi
801015c4:	56                   	push   %esi
801015c5:	53                   	push   %ebx
801015c6:	83 ec 1c             	sub    $0x1c,%esp
801015c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801015cc:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
801015d3:	8b 75 08             	mov    0x8(%ebp),%esi
801015d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015d9:	0f 86 91 00 00 00    	jbe    80101670 <ialloc+0xb0>
801015df:	bb 01 00 00 00       	mov    $0x1,%ebx
801015e4:	eb 21                	jmp    80101607 <ialloc+0x47>
801015e6:	8d 76 00             	lea    0x0(%esi),%esi
801015e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
801015f0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801015f3:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
801015f6:	57                   	push   %edi
801015f7:	e8 f4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801015fc:	83 c4 10             	add    $0x10,%esp
801015ff:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
80101605:	73 69                	jae    80101670 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101607:	89 d8                	mov    %ebx,%eax
80101609:	83 ec 08             	sub    $0x8,%esp
8010160c:	c1 e8 03             	shr    $0x3,%eax
8010160f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101615:	50                   	push   %eax
80101616:	56                   	push   %esi
80101617:	e8 b4 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010161c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010161f:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
80101621:	89 d8                	mov    %ebx,%eax
80101623:	83 e0 07             	and    $0x7,%eax
80101626:	c1 e0 06             	shl    $0x6,%eax
80101629:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010162d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101631:	75 bd                	jne    801015f0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101633:	83 ec 04             	sub    $0x4,%esp
80101636:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101639:	6a 40                	push   $0x40
8010163b:	6a 00                	push   $0x0
8010163d:	51                   	push   %ecx
8010163e:	e8 ed 30 00 00       	call   80104730 <memset>
      dip->type = type;
80101643:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101647:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010164a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010164d:	89 3c 24             	mov    %edi,(%esp)
80101650:	e8 3b 18 00 00       	call   80102e90 <log_write>
      brelse(bp);
80101655:	89 3c 24             	mov    %edi,(%esp)
80101658:	e8 93 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010165d:	83 c4 10             	add    $0x10,%esp
}
80101660:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101663:	89 da                	mov    %ebx,%edx
80101665:	89 f0                	mov    %esi,%eax
}
80101667:	5b                   	pop    %ebx
80101668:	5e                   	pop    %esi
80101669:	5f                   	pop    %edi
8010166a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010166b:	e9 40 fc ff ff       	jmp    801012b0 <iget>
  panic("ialloc: no inodes");
80101670:	83 ec 0c             	sub    $0xc,%esp
80101673:	68 d8 72 10 80       	push   $0x801072d8
80101678:	e8 13 ed ff ff       	call   80100390 <panic>
8010167d:	8d 76 00             	lea    0x0(%esi),%esi

80101680 <iupdate>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	56                   	push   %esi
80101684:	53                   	push   %ebx
80101685:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101688:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010168b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010168e:	83 ec 08             	sub    $0x8,%esp
80101691:	c1 e8 03             	shr    $0x3,%eax
80101694:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010169a:	50                   	push   %eax
8010169b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010169e:	e8 2d ea ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016a3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016a7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016aa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016ac:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016af:	83 e0 07             	and    $0x7,%eax
801016b2:	c1 e0 06             	shl    $0x6,%eax
801016b5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016b9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016bc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016c0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016c3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016c7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016cb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016cf:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016d3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016d7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016da:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016dd:	6a 34                	push   $0x34
801016df:	53                   	push   %ebx
801016e0:	50                   	push   %eax
801016e1:	e8 ea 30 00 00       	call   801047d0 <memmove>
  log_write(bp);
801016e6:	89 34 24             	mov    %esi,(%esp)
801016e9:	e8 a2 17 00 00       	call   80102e90 <log_write>
  brelse(bp);
801016ee:	89 75 08             	mov    %esi,0x8(%ebp)
801016f1:	83 c4 10             	add    $0x10,%esp
}
801016f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016f7:	5b                   	pop    %ebx
801016f8:	5e                   	pop    %esi
801016f9:	5d                   	pop    %ebp
  brelse(bp);
801016fa:	e9 f1 ea ff ff       	jmp    801001f0 <brelse>
801016ff:	90                   	nop

80101700 <idup>:
{
80101700:	55                   	push   %ebp
80101701:	89 e5                	mov    %esp,%ebp
80101703:	53                   	push   %ebx
80101704:	83 ec 10             	sub    $0x10,%esp
80101707:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010170a:	68 e0 09 11 80       	push   $0x801109e0
8010170f:	e8 ac 2e 00 00       	call   801045c0 <acquire>
  ip->ref++;
80101714:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101718:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010171f:	e8 bc 2f 00 00       	call   801046e0 <release>
}
80101724:	89 d8                	mov    %ebx,%eax
80101726:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101729:	c9                   	leave  
8010172a:	c3                   	ret    
8010172b:	90                   	nop
8010172c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101730 <ilock>:
{
80101730:	55                   	push   %ebp
80101731:	89 e5                	mov    %esp,%ebp
80101733:	56                   	push   %esi
80101734:	53                   	push   %ebx
80101735:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101738:	85 db                	test   %ebx,%ebx
8010173a:	0f 84 b7 00 00 00    	je     801017f7 <ilock+0xc7>
80101740:	8b 53 08             	mov    0x8(%ebx),%edx
80101743:	85 d2                	test   %edx,%edx
80101745:	0f 8e ac 00 00 00    	jle    801017f7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010174b:	83 ec 0c             	sub    $0xc,%esp
8010174e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101751:	50                   	push   %eax
80101752:	e8 99 2c 00 00       	call   801043f0 <acquiresleep>
  if(ip->valid == 0){
80101757:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010175a:	83 c4 10             	add    $0x10,%esp
8010175d:	85 c0                	test   %eax,%eax
8010175f:	74 0f                	je     80101770 <ilock+0x40>
}
80101761:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101764:	5b                   	pop    %ebx
80101765:	5e                   	pop    %esi
80101766:	5d                   	pop    %ebp
80101767:	c3                   	ret    
80101768:	90                   	nop
80101769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101770:	8b 43 04             	mov    0x4(%ebx),%eax
80101773:	83 ec 08             	sub    $0x8,%esp
80101776:	c1 e8 03             	shr    $0x3,%eax
80101779:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010177f:	50                   	push   %eax
80101780:	ff 33                	pushl  (%ebx)
80101782:	e8 49 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101787:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010178a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010178c:	8b 43 04             	mov    0x4(%ebx),%eax
8010178f:	83 e0 07             	and    $0x7,%eax
80101792:	c1 e0 06             	shl    $0x6,%eax
80101795:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101799:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010179c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010179f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017a3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017a7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017ab:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017af:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017b3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017b7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017bb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017be:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017c1:	6a 34                	push   $0x34
801017c3:	50                   	push   %eax
801017c4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017c7:	50                   	push   %eax
801017c8:	e8 03 30 00 00       	call   801047d0 <memmove>
    brelse(bp);
801017cd:	89 34 24             	mov    %esi,(%esp)
801017d0:	e8 1b ea ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
801017d5:	83 c4 10             	add    $0x10,%esp
801017d8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801017dd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801017e4:	0f 85 77 ff ff ff    	jne    80101761 <ilock+0x31>
      panic("ilock: no type");
801017ea:	83 ec 0c             	sub    $0xc,%esp
801017ed:	68 f0 72 10 80       	push   $0x801072f0
801017f2:	e8 99 eb ff ff       	call   80100390 <panic>
    panic("ilock");
801017f7:	83 ec 0c             	sub    $0xc,%esp
801017fa:	68 ea 72 10 80       	push   $0x801072ea
801017ff:	e8 8c eb ff ff       	call   80100390 <panic>
80101804:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010180a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101810 <iunlock>:
{
80101810:	55                   	push   %ebp
80101811:	89 e5                	mov    %esp,%ebp
80101813:	56                   	push   %esi
80101814:	53                   	push   %ebx
80101815:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101818:	85 db                	test   %ebx,%ebx
8010181a:	74 28                	je     80101844 <iunlock+0x34>
8010181c:	83 ec 0c             	sub    $0xc,%esp
8010181f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101822:	56                   	push   %esi
80101823:	e8 68 2c 00 00       	call   80104490 <holdingsleep>
80101828:	83 c4 10             	add    $0x10,%esp
8010182b:	85 c0                	test   %eax,%eax
8010182d:	74 15                	je     80101844 <iunlock+0x34>
8010182f:	8b 43 08             	mov    0x8(%ebx),%eax
80101832:	85 c0                	test   %eax,%eax
80101834:	7e 0e                	jle    80101844 <iunlock+0x34>
  releasesleep(&ip->lock);
80101836:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101839:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010183c:	5b                   	pop    %ebx
8010183d:	5e                   	pop    %esi
8010183e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010183f:	e9 0c 2c 00 00       	jmp    80104450 <releasesleep>
    panic("iunlock");
80101844:	83 ec 0c             	sub    $0xc,%esp
80101847:	68 ff 72 10 80       	push   $0x801072ff
8010184c:	e8 3f eb ff ff       	call   80100390 <panic>
80101851:	eb 0d                	jmp    80101860 <iput>
80101853:	90                   	nop
80101854:	90                   	nop
80101855:	90                   	nop
80101856:	90                   	nop
80101857:	90                   	nop
80101858:	90                   	nop
80101859:	90                   	nop
8010185a:	90                   	nop
8010185b:	90                   	nop
8010185c:	90                   	nop
8010185d:	90                   	nop
8010185e:	90                   	nop
8010185f:	90                   	nop

80101860 <iput>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	57                   	push   %edi
80101864:	56                   	push   %esi
80101865:	53                   	push   %ebx
80101866:	83 ec 28             	sub    $0x28,%esp
80101869:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010186c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010186f:	57                   	push   %edi
80101870:	e8 7b 2b 00 00       	call   801043f0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101875:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	85 d2                	test   %edx,%edx
8010187d:	74 07                	je     80101886 <iput+0x26>
8010187f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101884:	74 32                	je     801018b8 <iput+0x58>
  releasesleep(&ip->lock);
80101886:	83 ec 0c             	sub    $0xc,%esp
80101889:	57                   	push   %edi
8010188a:	e8 c1 2b 00 00       	call   80104450 <releasesleep>
  acquire(&icache.lock);
8010188f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101896:	e8 25 2d 00 00       	call   801045c0 <acquire>
  ip->ref--;
8010189b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010189f:	83 c4 10             	add    $0x10,%esp
801018a2:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801018a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018ac:	5b                   	pop    %ebx
801018ad:	5e                   	pop    %esi
801018ae:	5f                   	pop    %edi
801018af:	5d                   	pop    %ebp
  release(&icache.lock);
801018b0:	e9 2b 2e 00 00       	jmp    801046e0 <release>
801018b5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801018b8:	83 ec 0c             	sub    $0xc,%esp
801018bb:	68 e0 09 11 80       	push   $0x801109e0
801018c0:	e8 fb 2c 00 00       	call   801045c0 <acquire>
    int r = ip->ref;
801018c5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801018c8:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801018cf:	e8 0c 2e 00 00       	call   801046e0 <release>
    if(r == 1){
801018d4:	83 c4 10             	add    $0x10,%esp
801018d7:	83 fe 01             	cmp    $0x1,%esi
801018da:	75 aa                	jne    80101886 <iput+0x26>
801018dc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801018e2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801018e5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801018e8:	89 cf                	mov    %ecx,%edi
801018ea:	eb 0b                	jmp    801018f7 <iput+0x97>
801018ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018f0:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801018f3:	39 fe                	cmp    %edi,%esi
801018f5:	74 19                	je     80101910 <iput+0xb0>
    if(ip->addrs[i]){
801018f7:	8b 16                	mov    (%esi),%edx
801018f9:	85 d2                	test   %edx,%edx
801018fb:	74 f3                	je     801018f0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801018fd:	8b 03                	mov    (%ebx),%eax
801018ff:	e8 ac fb ff ff       	call   801014b0 <bfree>
      ip->addrs[i] = 0;
80101904:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010190a:	eb e4                	jmp    801018f0 <iput+0x90>
8010190c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101910:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101916:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101919:	85 c0                	test   %eax,%eax
8010191b:	75 33                	jne    80101950 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010191d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101920:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101927:	53                   	push   %ebx
80101928:	e8 53 fd ff ff       	call   80101680 <iupdate>
      ip->type = 0;
8010192d:	31 c0                	xor    %eax,%eax
8010192f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101933:	89 1c 24             	mov    %ebx,(%esp)
80101936:	e8 45 fd ff ff       	call   80101680 <iupdate>
      ip->valid = 0;
8010193b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101942:	83 c4 10             	add    $0x10,%esp
80101945:	e9 3c ff ff ff       	jmp    80101886 <iput+0x26>
8010194a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101950:	83 ec 08             	sub    $0x8,%esp
80101953:	50                   	push   %eax
80101954:	ff 33                	pushl  (%ebx)
80101956:	e8 75 e7 ff ff       	call   801000d0 <bread>
8010195b:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010195e:	83 c4 10             	add    $0x10,%esp
80101961:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101967:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
8010196a:	8d 70 5c             	lea    0x5c(%eax),%esi
8010196d:	89 cf                	mov    %ecx,%edi
8010196f:	eb 0e                	jmp    8010197f <iput+0x11f>
80101971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101978:	83 c6 04             	add    $0x4,%esi
8010197b:	39 f7                	cmp    %esi,%edi
8010197d:	74 11                	je     80101990 <iput+0x130>
      if(a[j])
8010197f:	8b 16                	mov    (%esi),%edx
80101981:	85 d2                	test   %edx,%edx
80101983:	74 f3                	je     80101978 <iput+0x118>
        bfree(ip->dev, a[j]);
80101985:	8b 03                	mov    (%ebx),%eax
80101987:	e8 24 fb ff ff       	call   801014b0 <bfree>
8010198c:	eb ea                	jmp    80101978 <iput+0x118>
8010198e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101990:	83 ec 0c             	sub    $0xc,%esp
80101993:	ff 75 e4             	pushl  -0x1c(%ebp)
80101996:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101999:	e8 52 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010199e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019a4:	8b 03                	mov    (%ebx),%eax
801019a6:	e8 05 fb ff ff       	call   801014b0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019ab:	83 c4 10             	add    $0x10,%esp
801019ae:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019b5:	00 00 00 
801019b8:	e9 60 ff ff ff       	jmp    8010191d <iput+0xbd>
801019bd:	8d 76 00             	lea    0x0(%esi),%esi

801019c0 <iunlockput>:
{
801019c0:	55                   	push   %ebp
801019c1:	89 e5                	mov    %esp,%ebp
801019c3:	53                   	push   %ebx
801019c4:	83 ec 10             	sub    $0x10,%esp
801019c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801019ca:	53                   	push   %ebx
801019cb:	e8 40 fe ff ff       	call   80101810 <iunlock>
  iput(ip);
801019d0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801019d3:	83 c4 10             	add    $0x10,%esp
}
801019d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801019d9:	c9                   	leave  
  iput(ip);
801019da:	e9 81 fe ff ff       	jmp    80101860 <iput>
801019df:	90                   	nop

801019e0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801019e0:	55                   	push   %ebp
801019e1:	89 e5                	mov    %esp,%ebp
801019e3:	8b 55 08             	mov    0x8(%ebp),%edx
801019e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801019e9:	8b 0a                	mov    (%edx),%ecx
801019eb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801019ee:	8b 4a 04             	mov    0x4(%edx),%ecx
801019f1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801019f4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801019f8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801019fb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801019ff:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a03:	8b 52 58             	mov    0x58(%edx),%edx
80101a06:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a09:	5d                   	pop    %ebp
80101a0a:	c3                   	ret    
80101a0b:	90                   	nop
80101a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a10 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	57                   	push   %edi
80101a14:	56                   	push   %esi
80101a15:	53                   	push   %ebx
80101a16:	83 ec 1c             	sub    $0x1c,%esp
80101a19:	8b 45 08             	mov    0x8(%ebp),%eax
80101a1c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a1f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a22:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a27:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101a2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a2d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a30:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a33:	0f 84 a7 00 00 00    	je     80101ae0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a3c:	8b 40 58             	mov    0x58(%eax),%eax
80101a3f:	39 c6                	cmp    %eax,%esi
80101a41:	0f 87 ba 00 00 00    	ja     80101b01 <readi+0xf1>
80101a47:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a4a:	89 f9                	mov    %edi,%ecx
80101a4c:	01 f1                	add    %esi,%ecx
80101a4e:	0f 82 ad 00 00 00    	jb     80101b01 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a54:	89 c2                	mov    %eax,%edx
80101a56:	29 f2                	sub    %esi,%edx
80101a58:	39 c8                	cmp    %ecx,%eax
80101a5a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a5d:	31 ff                	xor    %edi,%edi
    n = ip->size - off;
80101a5f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a62:	85 d2                	test   %edx,%edx
80101a64:	74 6c                	je     80101ad2 <readi+0xc2>
80101a66:	8d 76 00             	lea    0x0(%esi),%esi
80101a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a70:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a73:	89 f2                	mov    %esi,%edx
80101a75:	c1 ea 09             	shr    $0x9,%edx
80101a78:	89 d8                	mov    %ebx,%eax
80101a7a:	e8 21 f9 ff ff       	call   801013a0 <bmap>
80101a7f:	83 ec 08             	sub    $0x8,%esp
80101a82:	50                   	push   %eax
80101a83:	ff 33                	pushl  (%ebx)
80101a85:	e8 46 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a8a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a8d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a92:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a95:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a97:	89 f0                	mov    %esi,%eax
80101a99:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a9e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101aa0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101aa3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101aa5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101aa9:	39 d9                	cmp    %ebx,%ecx
80101aab:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101aae:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aaf:	01 df                	add    %ebx,%edi
80101ab1:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101ab3:	50                   	push   %eax
80101ab4:	ff 75 e0             	pushl  -0x20(%ebp)
80101ab7:	e8 14 2d 00 00       	call   801047d0 <memmove>
    brelse(bp);
80101abc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101abf:	89 14 24             	mov    %edx,(%esp)
80101ac2:	e8 29 e7 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ac7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101aca:	83 c4 10             	add    $0x10,%esp
80101acd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ad0:	77 9e                	ja     80101a70 <readi+0x60>
  }
  return n;
80101ad2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ad5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ad8:	5b                   	pop    %ebx
80101ad9:	5e                   	pop    %esi
80101ada:	5f                   	pop    %edi
80101adb:	5d                   	pop    %ebp
80101adc:	c3                   	ret    
80101add:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ae0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ae4:	66 83 f8 09          	cmp    $0x9,%ax
80101ae8:	77 17                	ja     80101b01 <readi+0xf1>
80101aea:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101af1:	85 c0                	test   %eax,%eax
80101af3:	74 0c                	je     80101b01 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101af5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101af8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101afb:	5b                   	pop    %ebx
80101afc:	5e                   	pop    %esi
80101afd:	5f                   	pop    %edi
80101afe:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101aff:	ff e0                	jmp    *%eax
      return -1;
80101b01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b06:	eb cd                	jmp    80101ad5 <readi+0xc5>
80101b08:	90                   	nop
80101b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101b10 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b10:	55                   	push   %ebp
80101b11:	89 e5                	mov    %esp,%ebp
80101b13:	57                   	push   %edi
80101b14:	56                   	push   %esi
80101b15:	53                   	push   %ebx
80101b16:	83 ec 1c             	sub    $0x1c,%esp
80101b19:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b1f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b22:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b27:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b2d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b30:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b33:	0f 84 b7 00 00 00    	je     80101bf0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b3c:	39 70 58             	cmp    %esi,0x58(%eax)
80101b3f:	0f 82 e7 00 00 00    	jb     80101c2c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b45:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b48:	89 f8                	mov    %edi,%eax
80101b4a:	01 f0                	add    %esi,%eax
80101b4c:	0f 82 da 00 00 00    	jb     80101c2c <writei+0x11c>
80101b52:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101b57:	0f 87 cf 00 00 00    	ja     80101c2c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b5d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b64:	85 ff                	test   %edi,%edi
80101b66:	74 79                	je     80101be1 <writei+0xd1>
80101b68:	90                   	nop
80101b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b70:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b73:	89 f2                	mov    %esi,%edx
80101b75:	c1 ea 09             	shr    $0x9,%edx
80101b78:	89 f8                	mov    %edi,%eax
80101b7a:	e8 21 f8 ff ff       	call   801013a0 <bmap>
80101b7f:	83 ec 08             	sub    $0x8,%esp
80101b82:	50                   	push   %eax
80101b83:	ff 37                	pushl  (%edi)
80101b85:	e8 46 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b8a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b8f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b92:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b95:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b97:	89 f0                	mov    %esi,%eax
80101b99:	83 c4 0c             	add    $0xc,%esp
80101b9c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ba1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ba3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101ba7:	39 d9                	cmp    %ebx,%ecx
80101ba9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bac:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bad:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101baf:	ff 75 dc             	pushl  -0x24(%ebp)
80101bb2:	50                   	push   %eax
80101bb3:	e8 18 2c 00 00       	call   801047d0 <memmove>
    log_write(bp);
80101bb8:	89 3c 24             	mov    %edi,(%esp)
80101bbb:	e8 d0 12 00 00       	call   80102e90 <log_write>
    brelse(bp);
80101bc0:	89 3c 24             	mov    %edi,(%esp)
80101bc3:	e8 28 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bc8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101bcb:	83 c4 10             	add    $0x10,%esp
80101bce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101bd1:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101bd4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101bd7:	77 97                	ja     80101b70 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101bd9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bdc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bdf:	77 37                	ja     80101c18 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101be1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101be4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101be7:	5b                   	pop    %ebx
80101be8:	5e                   	pop    %esi
80101be9:	5f                   	pop    %edi
80101bea:	5d                   	pop    %ebp
80101beb:	c3                   	ret    
80101bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101bf0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101bf4:	66 83 f8 09          	cmp    $0x9,%ax
80101bf8:	77 32                	ja     80101c2c <writei+0x11c>
80101bfa:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101c01:	85 c0                	test   %eax,%eax
80101c03:	74 27                	je     80101c2c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c05:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c0b:	5b                   	pop    %ebx
80101c0c:	5e                   	pop    %esi
80101c0d:	5f                   	pop    %edi
80101c0e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c0f:	ff e0                	jmp    *%eax
80101c11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c18:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c1b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c1e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c21:	50                   	push   %eax
80101c22:	e8 59 fa ff ff       	call   80101680 <iupdate>
80101c27:	83 c4 10             	add    $0x10,%esp
80101c2a:	eb b5                	jmp    80101be1 <writei+0xd1>
      return -1;
80101c2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c31:	eb b1                	jmp    80101be4 <writei+0xd4>
80101c33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c40 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c40:	55                   	push   %ebp
80101c41:	89 e5                	mov    %esp,%ebp
80101c43:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c46:	6a 0e                	push   $0xe
80101c48:	ff 75 0c             	pushl  0xc(%ebp)
80101c4b:	ff 75 08             	pushl  0x8(%ebp)
80101c4e:	e8 ed 2b 00 00       	call   80104840 <strncmp>
}
80101c53:	c9                   	leave  
80101c54:	c3                   	ret    
80101c55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c60 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	57                   	push   %edi
80101c64:	56                   	push   %esi
80101c65:	53                   	push   %ebx
80101c66:	83 ec 1c             	sub    $0x1c,%esp
80101c69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c6c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c71:	0f 85 85 00 00 00    	jne    80101cfc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c77:	8b 53 58             	mov    0x58(%ebx),%edx
80101c7a:	31 ff                	xor    %edi,%edi
80101c7c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c7f:	85 d2                	test   %edx,%edx
80101c81:	74 3e                	je     80101cc1 <dirlookup+0x61>
80101c83:	90                   	nop
80101c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c88:	6a 10                	push   $0x10
80101c8a:	57                   	push   %edi
80101c8b:	56                   	push   %esi
80101c8c:	53                   	push   %ebx
80101c8d:	e8 7e fd ff ff       	call   80101a10 <readi>
80101c92:	83 c4 10             	add    $0x10,%esp
80101c95:	83 f8 10             	cmp    $0x10,%eax
80101c98:	75 55                	jne    80101cef <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101c9a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c9f:	74 18                	je     80101cb9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101ca1:	83 ec 04             	sub    $0x4,%esp
80101ca4:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ca7:	6a 0e                	push   $0xe
80101ca9:	50                   	push   %eax
80101caa:	ff 75 0c             	pushl  0xc(%ebp)
80101cad:	e8 8e 2b 00 00       	call   80104840 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101cb2:	83 c4 10             	add    $0x10,%esp
80101cb5:	85 c0                	test   %eax,%eax
80101cb7:	74 17                	je     80101cd0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101cb9:	83 c7 10             	add    $0x10,%edi
80101cbc:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101cbf:	72 c7                	jb     80101c88 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101cc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101cc4:	31 c0                	xor    %eax,%eax
}
80101cc6:	5b                   	pop    %ebx
80101cc7:	5e                   	pop    %esi
80101cc8:	5f                   	pop    %edi
80101cc9:	5d                   	pop    %ebp
80101cca:	c3                   	ret    
80101ccb:	90                   	nop
80101ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101cd0:	8b 45 10             	mov    0x10(%ebp),%eax
80101cd3:	85 c0                	test   %eax,%eax
80101cd5:	74 05                	je     80101cdc <dirlookup+0x7c>
        *poff = off;
80101cd7:	8b 45 10             	mov    0x10(%ebp),%eax
80101cda:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101cdc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101ce0:	8b 03                	mov    (%ebx),%eax
80101ce2:	e8 c9 f5 ff ff       	call   801012b0 <iget>
}
80101ce7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cea:	5b                   	pop    %ebx
80101ceb:	5e                   	pop    %esi
80101cec:	5f                   	pop    %edi
80101ced:	5d                   	pop    %ebp
80101cee:	c3                   	ret    
      panic("dirlookup read");
80101cef:	83 ec 0c             	sub    $0xc,%esp
80101cf2:	68 19 73 10 80       	push   $0x80107319
80101cf7:	e8 94 e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101cfc:	83 ec 0c             	sub    $0xc,%esp
80101cff:	68 07 73 10 80       	push   $0x80107307
80101d04:	e8 87 e6 ff ff       	call   80100390 <panic>
80101d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d10 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d10:	55                   	push   %ebp
80101d11:	89 e5                	mov    %esp,%ebp
80101d13:	57                   	push   %edi
80101d14:	56                   	push   %esi
80101d15:	53                   	push   %ebx
80101d16:	89 c3                	mov    %eax,%ebx
80101d18:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d1b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d1e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d21:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d24:	0f 84 86 01 00 00    	je     80101eb0 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d2a:	e8 d1 1b 00 00       	call   80103900 <myproc>
  acquire(&icache.lock);
80101d2f:	83 ec 0c             	sub    $0xc,%esp
80101d32:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d34:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d37:	68 e0 09 11 80       	push   $0x801109e0
80101d3c:	e8 7f 28 00 00       	call   801045c0 <acquire>
  ip->ref++;
80101d41:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d45:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101d4c:	e8 8f 29 00 00       	call   801046e0 <release>
80101d51:	83 c4 10             	add    $0x10,%esp
80101d54:	eb 0d                	jmp    80101d63 <namex+0x53>
80101d56:	8d 76 00             	lea    0x0(%esi),%esi
80101d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d60:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101d63:	0f b6 07             	movzbl (%edi),%eax
80101d66:	3c 2f                	cmp    $0x2f,%al
80101d68:	74 f6                	je     80101d60 <namex+0x50>
  if(*path == 0)
80101d6a:	84 c0                	test   %al,%al
80101d6c:	0f 84 ee 00 00 00    	je     80101e60 <namex+0x150>
  while(*path != '/' && *path != 0)
80101d72:	0f b6 07             	movzbl (%edi),%eax
80101d75:	3c 2f                	cmp    $0x2f,%al
80101d77:	0f 84 fb 00 00 00    	je     80101e78 <namex+0x168>
80101d7d:	89 fb                	mov    %edi,%ebx
80101d7f:	84 c0                	test   %al,%al
80101d81:	0f 84 f1 00 00 00    	je     80101e78 <namex+0x168>
80101d87:	89 f6                	mov    %esi,%esi
80101d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d90:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101d93:	0f b6 03             	movzbl (%ebx),%eax
80101d96:	3c 2f                	cmp    $0x2f,%al
80101d98:	74 04                	je     80101d9e <namex+0x8e>
80101d9a:	84 c0                	test   %al,%al
80101d9c:	75 f2                	jne    80101d90 <namex+0x80>
  len = path - s;
80101d9e:	89 d8                	mov    %ebx,%eax
80101da0:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101da2:	83 f8 0d             	cmp    $0xd,%eax
80101da5:	0f 8e 85 00 00 00    	jle    80101e30 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101dab:	83 ec 04             	sub    $0x4,%esp
80101dae:	6a 0e                	push   $0xe
80101db0:	57                   	push   %edi
    path++;
80101db1:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101db3:	ff 75 e4             	pushl  -0x1c(%ebp)
80101db6:	e8 15 2a 00 00       	call   801047d0 <memmove>
80101dbb:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101dbe:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101dc1:	75 0d                	jne    80101dd0 <namex+0xc0>
80101dc3:	90                   	nop
80101dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101dc8:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dcb:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101dce:	74 f8                	je     80101dc8 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101dd0:	83 ec 0c             	sub    $0xc,%esp
80101dd3:	56                   	push   %esi
80101dd4:	e8 57 f9 ff ff       	call   80101730 <ilock>
    if(ip->type != T_DIR){
80101dd9:	83 c4 10             	add    $0x10,%esp
80101ddc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101de1:	0f 85 a1 00 00 00    	jne    80101e88 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101de7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101dea:	85 d2                	test   %edx,%edx
80101dec:	74 09                	je     80101df7 <namex+0xe7>
80101dee:	80 3f 00             	cmpb   $0x0,(%edi)
80101df1:	0f 84 d9 00 00 00    	je     80101ed0 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101df7:	83 ec 04             	sub    $0x4,%esp
80101dfa:	6a 00                	push   $0x0
80101dfc:	ff 75 e4             	pushl  -0x1c(%ebp)
80101dff:	56                   	push   %esi
80101e00:	e8 5b fe ff ff       	call   80101c60 <dirlookup>
80101e05:	83 c4 10             	add    $0x10,%esp
80101e08:	89 c3                	mov    %eax,%ebx
80101e0a:	85 c0                	test   %eax,%eax
80101e0c:	74 7a                	je     80101e88 <namex+0x178>
  iunlock(ip);
80101e0e:	83 ec 0c             	sub    $0xc,%esp
80101e11:	56                   	push   %esi
80101e12:	e8 f9 f9 ff ff       	call   80101810 <iunlock>
  iput(ip);
80101e17:	89 34 24             	mov    %esi,(%esp)
80101e1a:	89 de                	mov    %ebx,%esi
80101e1c:	e8 3f fa ff ff       	call   80101860 <iput>
  while(*path == '/')
80101e21:	83 c4 10             	add    $0x10,%esp
80101e24:	e9 3a ff ff ff       	jmp    80101d63 <namex+0x53>
80101e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101e33:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101e36:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101e39:	83 ec 04             	sub    $0x4,%esp
80101e3c:	50                   	push   %eax
80101e3d:	57                   	push   %edi
    name[len] = 0;
80101e3e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101e40:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e43:	e8 88 29 00 00       	call   801047d0 <memmove>
    name[len] = 0;
80101e48:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e4b:	83 c4 10             	add    $0x10,%esp
80101e4e:	c6 00 00             	movb   $0x0,(%eax)
80101e51:	e9 68 ff ff ff       	jmp    80101dbe <namex+0xae>
80101e56:	8d 76 00             	lea    0x0(%esi),%esi
80101e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e60:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e63:	85 c0                	test   %eax,%eax
80101e65:	0f 85 85 00 00 00    	jne    80101ef0 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101e6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e6e:	89 f0                	mov    %esi,%eax
80101e70:	5b                   	pop    %ebx
80101e71:	5e                   	pop    %esi
80101e72:	5f                   	pop    %edi
80101e73:	5d                   	pop    %ebp
80101e74:	c3                   	ret    
80101e75:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101e78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e7b:	89 fb                	mov    %edi,%ebx
80101e7d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101e80:	31 c0                	xor    %eax,%eax
80101e82:	eb b5                	jmp    80101e39 <namex+0x129>
80101e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101e88:	83 ec 0c             	sub    $0xc,%esp
80101e8b:	56                   	push   %esi
80101e8c:	e8 7f f9 ff ff       	call   80101810 <iunlock>
  iput(ip);
80101e91:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101e94:	31 f6                	xor    %esi,%esi
  iput(ip);
80101e96:	e8 c5 f9 ff ff       	call   80101860 <iput>
      return 0;
80101e9b:	83 c4 10             	add    $0x10,%esp
}
80101e9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ea1:	89 f0                	mov    %esi,%eax
80101ea3:	5b                   	pop    %ebx
80101ea4:	5e                   	pop    %esi
80101ea5:	5f                   	pop    %edi
80101ea6:	5d                   	pop    %ebp
80101ea7:	c3                   	ret    
80101ea8:	90                   	nop
80101ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip = iget(ROOTDEV, ROOTINO);
80101eb0:	ba 01 00 00 00       	mov    $0x1,%edx
80101eb5:	b8 01 00 00 00       	mov    $0x1,%eax
80101eba:	89 df                	mov    %ebx,%edi
80101ebc:	e8 ef f3 ff ff       	call   801012b0 <iget>
80101ec1:	89 c6                	mov    %eax,%esi
80101ec3:	e9 9b fe ff ff       	jmp    80101d63 <namex+0x53>
80101ec8:	90                   	nop
80101ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      iunlock(ip);
80101ed0:	83 ec 0c             	sub    $0xc,%esp
80101ed3:	56                   	push   %esi
80101ed4:	e8 37 f9 ff ff       	call   80101810 <iunlock>
      return ip;
80101ed9:	83 c4 10             	add    $0x10,%esp
}
80101edc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101edf:	89 f0                	mov    %esi,%eax
80101ee1:	5b                   	pop    %ebx
80101ee2:	5e                   	pop    %esi
80101ee3:	5f                   	pop    %edi
80101ee4:	5d                   	pop    %ebp
80101ee5:	c3                   	ret    
80101ee6:	8d 76 00             	lea    0x0(%esi),%esi
80101ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iput(ip);
80101ef0:	83 ec 0c             	sub    $0xc,%esp
80101ef3:	56                   	push   %esi
    return 0;
80101ef4:	31 f6                	xor    %esi,%esi
    iput(ip);
80101ef6:	e8 65 f9 ff ff       	call   80101860 <iput>
    return 0;
80101efb:	83 c4 10             	add    $0x10,%esp
80101efe:	e9 68 ff ff ff       	jmp    80101e6b <namex+0x15b>
80101f03:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f10 <dirlink>:
{
80101f10:	55                   	push   %ebp
80101f11:	89 e5                	mov    %esp,%ebp
80101f13:	57                   	push   %edi
80101f14:	56                   	push   %esi
80101f15:	53                   	push   %ebx
80101f16:	83 ec 20             	sub    $0x20,%esp
80101f19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f1c:	6a 00                	push   $0x0
80101f1e:	ff 75 0c             	pushl  0xc(%ebp)
80101f21:	53                   	push   %ebx
80101f22:	e8 39 fd ff ff       	call   80101c60 <dirlookup>
80101f27:	83 c4 10             	add    $0x10,%esp
80101f2a:	85 c0                	test   %eax,%eax
80101f2c:	75 67                	jne    80101f95 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f2e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f31:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f34:	85 ff                	test   %edi,%edi
80101f36:	74 29                	je     80101f61 <dirlink+0x51>
80101f38:	31 ff                	xor    %edi,%edi
80101f3a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f3d:	eb 09                	jmp    80101f48 <dirlink+0x38>
80101f3f:	90                   	nop
80101f40:	83 c7 10             	add    $0x10,%edi
80101f43:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101f46:	73 19                	jae    80101f61 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f48:	6a 10                	push   $0x10
80101f4a:	57                   	push   %edi
80101f4b:	56                   	push   %esi
80101f4c:	53                   	push   %ebx
80101f4d:	e8 be fa ff ff       	call   80101a10 <readi>
80101f52:	83 c4 10             	add    $0x10,%esp
80101f55:	83 f8 10             	cmp    $0x10,%eax
80101f58:	75 4e                	jne    80101fa8 <dirlink+0x98>
    if(de.inum == 0)
80101f5a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f5f:	75 df                	jne    80101f40 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101f61:	83 ec 04             	sub    $0x4,%esp
80101f64:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f67:	6a 0e                	push   $0xe
80101f69:	ff 75 0c             	pushl  0xc(%ebp)
80101f6c:	50                   	push   %eax
80101f6d:	e8 1e 29 00 00       	call   80104890 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f72:	6a 10                	push   $0x10
  de.inum = inum;
80101f74:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f77:	57                   	push   %edi
80101f78:	56                   	push   %esi
80101f79:	53                   	push   %ebx
  de.inum = inum;
80101f7a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f7e:	e8 8d fb ff ff       	call   80101b10 <writei>
80101f83:	83 c4 20             	add    $0x20,%esp
80101f86:	83 f8 10             	cmp    $0x10,%eax
80101f89:	75 2a                	jne    80101fb5 <dirlink+0xa5>
  return 0;
80101f8b:	31 c0                	xor    %eax,%eax
}
80101f8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f90:	5b                   	pop    %ebx
80101f91:	5e                   	pop    %esi
80101f92:	5f                   	pop    %edi
80101f93:	5d                   	pop    %ebp
80101f94:	c3                   	ret    
    iput(ip);
80101f95:	83 ec 0c             	sub    $0xc,%esp
80101f98:	50                   	push   %eax
80101f99:	e8 c2 f8 ff ff       	call   80101860 <iput>
    return -1;
80101f9e:	83 c4 10             	add    $0x10,%esp
80101fa1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fa6:	eb e5                	jmp    80101f8d <dirlink+0x7d>
      panic("dirlink read");
80101fa8:	83 ec 0c             	sub    $0xc,%esp
80101fab:	68 28 73 10 80       	push   $0x80107328
80101fb0:	e8 db e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101fb5:	83 ec 0c             	sub    $0xc,%esp
80101fb8:	68 ee 79 10 80       	push   $0x801079ee
80101fbd:	e8 ce e3 ff ff       	call   80100390 <panic>
80101fc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fd0 <namei>:

struct inode*
namei(char *path)
{
80101fd0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101fd1:	31 d2                	xor    %edx,%edx
{
80101fd3:	89 e5                	mov    %esp,%ebp
80101fd5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101fd8:	8b 45 08             	mov    0x8(%ebp),%eax
80101fdb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101fde:	e8 2d fd ff ff       	call   80101d10 <namex>
}
80101fe3:	c9                   	leave  
80101fe4:	c3                   	ret    
80101fe5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ff0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101ff0:	55                   	push   %ebp
  return namex(path, 1, name);
80101ff1:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101ff6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101ff8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101ffb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101ffe:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101fff:	e9 0c fd ff ff       	jmp    80101d10 <namex>
80102004:	66 90                	xchg   %ax,%ax
80102006:	66 90                	xchg   %ax,%ax
80102008:	66 90                	xchg   %ax,%ax
8010200a:	66 90                	xchg   %ax,%ax
8010200c:	66 90                	xchg   %ax,%ax
8010200e:	66 90                	xchg   %ax,%ax

80102010 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	57                   	push   %edi
80102014:	56                   	push   %esi
80102015:	53                   	push   %ebx
80102016:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102019:	85 c0                	test   %eax,%eax
8010201b:	0f 84 b4 00 00 00    	je     801020d5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102021:	8b 70 08             	mov    0x8(%eax),%esi
80102024:	89 c3                	mov    %eax,%ebx
80102026:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010202c:	0f 87 96 00 00 00    	ja     801020c8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102032:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102037:	89 f6                	mov    %esi,%esi
80102039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102040:	89 ca                	mov    %ecx,%edx
80102042:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102043:	83 e0 c0             	and    $0xffffffc0,%eax
80102046:	3c 40                	cmp    $0x40,%al
80102048:	75 f6                	jne    80102040 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010204a:	31 ff                	xor    %edi,%edi
8010204c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102051:	89 f8                	mov    %edi,%eax
80102053:	ee                   	out    %al,(%dx)
80102054:	b8 01 00 00 00       	mov    $0x1,%eax
80102059:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010205e:	ee                   	out    %al,(%dx)
8010205f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102064:	89 f0                	mov    %esi,%eax
80102066:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102067:	89 f0                	mov    %esi,%eax
80102069:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010206e:	c1 f8 08             	sar    $0x8,%eax
80102071:	ee                   	out    %al,(%dx)
80102072:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102077:	89 f8                	mov    %edi,%eax
80102079:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010207a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010207e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102083:	c1 e0 04             	shl    $0x4,%eax
80102086:	83 e0 10             	and    $0x10,%eax
80102089:	83 c8 e0             	or     $0xffffffe0,%eax
8010208c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010208d:	f6 03 04             	testb  $0x4,(%ebx)
80102090:	75 16                	jne    801020a8 <idestart+0x98>
80102092:	b8 20 00 00 00       	mov    $0x20,%eax
80102097:	89 ca                	mov    %ecx,%edx
80102099:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010209a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010209d:	5b                   	pop    %ebx
8010209e:	5e                   	pop    %esi
8010209f:	5f                   	pop    %edi
801020a0:	5d                   	pop    %ebp
801020a1:	c3                   	ret    
801020a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801020a8:	b8 30 00 00 00       	mov    $0x30,%eax
801020ad:	89 ca                	mov    %ecx,%edx
801020af:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801020b0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801020b5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801020b8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020bd:	fc                   	cld    
801020be:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801020c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020c3:	5b                   	pop    %ebx
801020c4:	5e                   	pop    %esi
801020c5:	5f                   	pop    %edi
801020c6:	5d                   	pop    %ebp
801020c7:	c3                   	ret    
    panic("incorrect blockno");
801020c8:	83 ec 0c             	sub    $0xc,%esp
801020cb:	68 94 73 10 80       	push   $0x80107394
801020d0:	e8 bb e2 ff ff       	call   80100390 <panic>
    panic("idestart");
801020d5:	83 ec 0c             	sub    $0xc,%esp
801020d8:	68 8b 73 10 80       	push   $0x8010738b
801020dd:	e8 ae e2 ff ff       	call   80100390 <panic>
801020e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801020f0 <ideinit>:
{
801020f0:	55                   	push   %ebp
801020f1:	89 e5                	mov    %esp,%ebp
801020f3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801020f6:	68 a6 73 10 80       	push   $0x801073a6
801020fb:	68 80 a5 10 80       	push   $0x8010a580
80102100:	e8 bb 23 00 00       	call   801044c0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102105:	58                   	pop    %eax
80102106:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010210b:	5a                   	pop    %edx
8010210c:	83 e8 01             	sub    $0x1,%eax
8010210f:	50                   	push   %eax
80102110:	6a 0e                	push   $0xe
80102112:	e8 a9 02 00 00       	call   801023c0 <ioapicenable>
80102117:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010211a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010211f:	90                   	nop
80102120:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102121:	83 e0 c0             	and    $0xffffffc0,%eax
80102124:	3c 40                	cmp    $0x40,%al
80102126:	75 f8                	jne    80102120 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102128:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010212d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102132:	ee                   	out    %al,(%dx)
80102133:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102138:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010213d:	eb 06                	jmp    80102145 <ideinit+0x55>
8010213f:	90                   	nop
  for(i=0; i<1000; i++){
80102140:	83 e9 01             	sub    $0x1,%ecx
80102143:	74 0f                	je     80102154 <ideinit+0x64>
80102145:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102146:	84 c0                	test   %al,%al
80102148:	74 f6                	je     80102140 <ideinit+0x50>
      havedisk1 = 1;
8010214a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102151:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102154:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102159:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010215e:	ee                   	out    %al,(%dx)
}
8010215f:	c9                   	leave  
80102160:	c3                   	ret    
80102161:	eb 0d                	jmp    80102170 <ideintr>
80102163:	90                   	nop
80102164:	90                   	nop
80102165:	90                   	nop
80102166:	90                   	nop
80102167:	90                   	nop
80102168:	90                   	nop
80102169:	90                   	nop
8010216a:	90                   	nop
8010216b:	90                   	nop
8010216c:	90                   	nop
8010216d:	90                   	nop
8010216e:	90                   	nop
8010216f:	90                   	nop

80102170 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102170:	55                   	push   %ebp
80102171:	89 e5                	mov    %esp,%ebp
80102173:	57                   	push   %edi
80102174:	56                   	push   %esi
80102175:	53                   	push   %ebx
80102176:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102179:	68 80 a5 10 80       	push   $0x8010a580
8010217e:	e8 3d 24 00 00       	call   801045c0 <acquire>

  if((b = idequeue) == 0){
80102183:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102189:	83 c4 10             	add    $0x10,%esp
8010218c:	85 db                	test   %ebx,%ebx
8010218e:	74 63                	je     801021f3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102190:	8b 43 58             	mov    0x58(%ebx),%eax
80102193:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102198:	8b 33                	mov    (%ebx),%esi
8010219a:	f7 c6 04 00 00 00    	test   $0x4,%esi
801021a0:	75 2f                	jne    801021d1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021a2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021a7:	89 f6                	mov    %esi,%esi
801021a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801021b0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021b1:	89 c1                	mov    %eax,%ecx
801021b3:	83 e1 c0             	and    $0xffffffc0,%ecx
801021b6:	80 f9 40             	cmp    $0x40,%cl
801021b9:	75 f5                	jne    801021b0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801021bb:	a8 21                	test   $0x21,%al
801021bd:	75 12                	jne    801021d1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801021bf:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801021c2:	b9 80 00 00 00       	mov    $0x80,%ecx
801021c7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021cc:	fc                   	cld    
801021cd:	f3 6d                	rep insl (%dx),%es:(%edi)
801021cf:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801021d1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801021d4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801021d7:	83 ce 02             	or     $0x2,%esi
801021da:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801021dc:	53                   	push   %ebx
801021dd:	e8 8e 1e 00 00       	call   80104070 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801021e2:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801021e7:	83 c4 10             	add    $0x10,%esp
801021ea:	85 c0                	test   %eax,%eax
801021ec:	74 05                	je     801021f3 <ideintr+0x83>
    idestart(idequeue);
801021ee:	e8 1d fe ff ff       	call   80102010 <idestart>
    release(&idelock);
801021f3:	83 ec 0c             	sub    $0xc,%esp
801021f6:	68 80 a5 10 80       	push   $0x8010a580
801021fb:	e8 e0 24 00 00       	call   801046e0 <release>

  release(&idelock);
}
80102200:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102203:	5b                   	pop    %ebx
80102204:	5e                   	pop    %esi
80102205:	5f                   	pop    %edi
80102206:	5d                   	pop    %ebp
80102207:	c3                   	ret    
80102208:	90                   	nop
80102209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102210 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102210:	55                   	push   %ebp
80102211:	89 e5                	mov    %esp,%ebp
80102213:	53                   	push   %ebx
80102214:	83 ec 10             	sub    $0x10,%esp
80102217:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010221a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010221d:	50                   	push   %eax
8010221e:	e8 6d 22 00 00       	call   80104490 <holdingsleep>
80102223:	83 c4 10             	add    $0x10,%esp
80102226:	85 c0                	test   %eax,%eax
80102228:	0f 84 d3 00 00 00    	je     80102301 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010222e:	8b 03                	mov    (%ebx),%eax
80102230:	83 e0 06             	and    $0x6,%eax
80102233:	83 f8 02             	cmp    $0x2,%eax
80102236:	0f 84 b8 00 00 00    	je     801022f4 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010223c:	8b 53 04             	mov    0x4(%ebx),%edx
8010223f:	85 d2                	test   %edx,%edx
80102241:	74 0d                	je     80102250 <iderw+0x40>
80102243:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102248:	85 c0                	test   %eax,%eax
8010224a:	0f 84 97 00 00 00    	je     801022e7 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102250:	83 ec 0c             	sub    $0xc,%esp
80102253:	68 80 a5 10 80       	push   $0x8010a580
80102258:	e8 63 23 00 00       	call   801045c0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010225d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
  b->qnext = 0;
80102263:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010226a:	83 c4 10             	add    $0x10,%esp
8010226d:	85 d2                	test   %edx,%edx
8010226f:	75 09                	jne    8010227a <iderw+0x6a>
80102271:	eb 6d                	jmp    801022e0 <iderw+0xd0>
80102273:	90                   	nop
80102274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102278:	89 c2                	mov    %eax,%edx
8010227a:	8b 42 58             	mov    0x58(%edx),%eax
8010227d:	85 c0                	test   %eax,%eax
8010227f:	75 f7                	jne    80102278 <iderw+0x68>
80102281:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102284:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102286:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
8010228c:	74 42                	je     801022d0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010228e:	8b 03                	mov    (%ebx),%eax
80102290:	83 e0 06             	and    $0x6,%eax
80102293:	83 f8 02             	cmp    $0x2,%eax
80102296:	74 23                	je     801022bb <iderw+0xab>
80102298:	90                   	nop
80102299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801022a0:	83 ec 08             	sub    $0x8,%esp
801022a3:	68 80 a5 10 80       	push   $0x8010a580
801022a8:	53                   	push   %ebx
801022a9:	e8 12 1c 00 00       	call   80103ec0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801022ae:	8b 03                	mov    (%ebx),%eax
801022b0:	83 c4 10             	add    $0x10,%esp
801022b3:	83 e0 06             	and    $0x6,%eax
801022b6:	83 f8 02             	cmp    $0x2,%eax
801022b9:	75 e5                	jne    801022a0 <iderw+0x90>
  }


  release(&idelock);
801022bb:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801022c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801022c5:	c9                   	leave  
  release(&idelock);
801022c6:	e9 15 24 00 00       	jmp    801046e0 <release>
801022cb:	90                   	nop
801022cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801022d0:	89 d8                	mov    %ebx,%eax
801022d2:	e8 39 fd ff ff       	call   80102010 <idestart>
801022d7:	eb b5                	jmp    8010228e <iderw+0x7e>
801022d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022e0:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
801022e5:	eb 9d                	jmp    80102284 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
801022e7:	83 ec 0c             	sub    $0xc,%esp
801022ea:	68 d5 73 10 80       	push   $0x801073d5
801022ef:	e8 9c e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
801022f4:	83 ec 0c             	sub    $0xc,%esp
801022f7:	68 c0 73 10 80       	push   $0x801073c0
801022fc:	e8 8f e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102301:	83 ec 0c             	sub    $0xc,%esp
80102304:	68 aa 73 10 80       	push   $0x801073aa
80102309:	e8 82 e0 ff ff       	call   80100390 <panic>
8010230e:	66 90                	xchg   %ax,%ax

80102310 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102310:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102311:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80102318:	00 c0 fe 
{
8010231b:	89 e5                	mov    %esp,%ebp
8010231d:	56                   	push   %esi
8010231e:	53                   	push   %ebx
  ioapic->reg = reg;
8010231f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102326:	00 00 00 
  return ioapic->data;
80102329:	8b 15 34 26 11 80    	mov    0x80112634,%edx
8010232f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102332:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102338:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010233e:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102345:	c1 ee 10             	shr    $0x10,%esi
80102348:	89 f0                	mov    %esi,%eax
8010234a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010234d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102350:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102353:	39 c2                	cmp    %eax,%edx
80102355:	74 16                	je     8010236d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102357:	83 ec 0c             	sub    $0xc,%esp
8010235a:	68 f4 73 10 80       	push   $0x801073f4
8010235f:	e8 4c e3 ff ff       	call   801006b0 <cprintf>
80102364:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010236a:	83 c4 10             	add    $0x10,%esp
8010236d:	83 c6 21             	add    $0x21,%esi
{
80102370:	ba 10 00 00 00       	mov    $0x10,%edx
80102375:	b8 20 00 00 00       	mov    $0x20,%eax
8010237a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102380:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102382:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102384:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010238a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010238d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102393:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102396:	8d 5a 01             	lea    0x1(%edx),%ebx
80102399:	83 c2 02             	add    $0x2,%edx
8010239c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010239e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801023a4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801023ab:	39 f0                	cmp    %esi,%eax
801023ad:	75 d1                	jne    80102380 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801023af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023b2:	5b                   	pop    %ebx
801023b3:	5e                   	pop    %esi
801023b4:	5d                   	pop    %ebp
801023b5:	c3                   	ret    
801023b6:	8d 76 00             	lea    0x0(%esi),%esi
801023b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023c0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801023c0:	55                   	push   %ebp
  ioapic->reg = reg;
801023c1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
801023c7:	89 e5                	mov    %esp,%ebp
801023c9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801023cc:	8d 50 20             	lea    0x20(%eax),%edx
801023cf:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801023d3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801023d5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023db:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801023de:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801023e4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801023e6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023eb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801023ee:	89 50 10             	mov    %edx,0x10(%eax)
}
801023f1:	5d                   	pop    %ebp
801023f2:	c3                   	ret    
801023f3:	66 90                	xchg   %ax,%ax
801023f5:	66 90                	xchg   %ax,%ax
801023f7:	66 90                	xchg   %ax,%ax
801023f9:	66 90                	xchg   %ax,%ax
801023fb:	66 90                	xchg   %ax,%ax
801023fd:	66 90                	xchg   %ax,%ax
801023ff:	90                   	nop

80102400 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102400:	55                   	push   %ebp
80102401:	89 e5                	mov    %esp,%ebp
80102403:	53                   	push   %ebx
80102404:	83 ec 04             	sub    $0x4,%esp
80102407:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010240a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102410:	75 76                	jne    80102488 <kfree+0x88>
80102412:	81 fb a8 55 11 80    	cmp    $0x801155a8,%ebx
80102418:	72 6e                	jb     80102488 <kfree+0x88>
8010241a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102420:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102425:	77 61                	ja     80102488 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102427:	83 ec 04             	sub    $0x4,%esp
8010242a:	68 00 10 00 00       	push   $0x1000
8010242f:	6a 01                	push   $0x1
80102431:	53                   	push   %ebx
80102432:	e8 f9 22 00 00       	call   80104730 <memset>

  if(kmem.use_lock)
80102437:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010243d:	83 c4 10             	add    $0x10,%esp
80102440:	85 d2                	test   %edx,%edx
80102442:	75 1c                	jne    80102460 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102444:	a1 78 26 11 80       	mov    0x80112678,%eax
80102449:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010244b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102450:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102456:	85 c0                	test   %eax,%eax
80102458:	75 1e                	jne    80102478 <kfree+0x78>
    release(&kmem.lock);
}
8010245a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010245d:	c9                   	leave  
8010245e:	c3                   	ret    
8010245f:	90                   	nop
    acquire(&kmem.lock);
80102460:	83 ec 0c             	sub    $0xc,%esp
80102463:	68 40 26 11 80       	push   $0x80112640
80102468:	e8 53 21 00 00       	call   801045c0 <acquire>
8010246d:	83 c4 10             	add    $0x10,%esp
80102470:	eb d2                	jmp    80102444 <kfree+0x44>
80102472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102478:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010247f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102482:	c9                   	leave  
    release(&kmem.lock);
80102483:	e9 58 22 00 00       	jmp    801046e0 <release>
    panic("kfree");
80102488:	83 ec 0c             	sub    $0xc,%esp
8010248b:	68 26 74 10 80       	push   $0x80107426
80102490:	e8 fb de ff ff       	call   80100390 <panic>
80102495:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024a0 <freerange>:
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801024a4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801024a7:	8b 75 0c             	mov    0xc(%ebp),%esi
801024aa:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801024ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024bd:	39 de                	cmp    %ebx,%esi
801024bf:	72 23                	jb     801024e4 <freerange+0x44>
801024c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801024c8:	83 ec 0c             	sub    $0xc,%esp
801024cb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024d7:	50                   	push   %eax
801024d8:	e8 23 ff ff ff       	call   80102400 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024dd:	83 c4 10             	add    $0x10,%esp
801024e0:	39 f3                	cmp    %esi,%ebx
801024e2:	76 e4                	jbe    801024c8 <freerange+0x28>
}
801024e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024e7:	5b                   	pop    %ebx
801024e8:	5e                   	pop    %esi
801024e9:	5d                   	pop    %ebp
801024ea:	c3                   	ret    
801024eb:	90                   	nop
801024ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801024f0 <kinit1>:
{
801024f0:	55                   	push   %ebp
801024f1:	89 e5                	mov    %esp,%ebp
801024f3:	56                   	push   %esi
801024f4:	53                   	push   %ebx
801024f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801024f8:	83 ec 08             	sub    $0x8,%esp
801024fb:	68 2c 74 10 80       	push   $0x8010742c
80102500:	68 40 26 11 80       	push   $0x80112640
80102505:	e8 b6 1f 00 00       	call   801044c0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010250a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010250d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102510:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102517:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010251a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102520:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102526:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010252c:	39 de                	cmp    %ebx,%esi
8010252e:	72 1c                	jb     8010254c <kinit1+0x5c>
    kfree(p);
80102530:	83 ec 0c             	sub    $0xc,%esp
80102533:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102539:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010253f:	50                   	push   %eax
80102540:	e8 bb fe ff ff       	call   80102400 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102545:	83 c4 10             	add    $0x10,%esp
80102548:	39 de                	cmp    %ebx,%esi
8010254a:	73 e4                	jae    80102530 <kinit1+0x40>
}
8010254c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010254f:	5b                   	pop    %ebx
80102550:	5e                   	pop    %esi
80102551:	5d                   	pop    %ebp
80102552:	c3                   	ret    
80102553:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102560 <kinit2>:
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102564:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102567:	8b 75 0c             	mov    0xc(%ebp),%esi
8010256a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010256b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102571:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102577:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010257d:	39 de                	cmp    %ebx,%esi
8010257f:	72 23                	jb     801025a4 <kinit2+0x44>
80102581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102588:	83 ec 0c             	sub    $0xc,%esp
8010258b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102591:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102597:	50                   	push   %eax
80102598:	e8 63 fe ff ff       	call   80102400 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010259d:	83 c4 10             	add    $0x10,%esp
801025a0:	39 de                	cmp    %ebx,%esi
801025a2:	73 e4                	jae    80102588 <kinit2+0x28>
  kmem.use_lock = 1;
801025a4:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801025ab:	00 00 00 
}
801025ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025b1:	5b                   	pop    %ebx
801025b2:	5e                   	pop    %esi
801025b3:	5d                   	pop    %ebp
801025b4:	c3                   	ret    
801025b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025c0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	53                   	push   %ebx
801025c4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801025c7:	a1 74 26 11 80       	mov    0x80112674,%eax
801025cc:	85 c0                	test   %eax,%eax
801025ce:	75 20                	jne    801025f0 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
801025d0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801025d6:	85 db                	test   %ebx,%ebx
801025d8:	74 07                	je     801025e1 <kalloc+0x21>
    kmem.freelist = r->next;
801025da:	8b 03                	mov    (%ebx),%eax
801025dc:	a3 78 26 11 80       	mov    %eax,0x80112678
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801025e1:	89 d8                	mov    %ebx,%eax
801025e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025e6:	c9                   	leave  
801025e7:	c3                   	ret    
801025e8:	90                   	nop
801025e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
801025f0:	83 ec 0c             	sub    $0xc,%esp
801025f3:	68 40 26 11 80       	push   $0x80112640
801025f8:	e8 c3 1f 00 00       	call   801045c0 <acquire>
  r = kmem.freelist;
801025fd:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102603:	83 c4 10             	add    $0x10,%esp
80102606:	a1 74 26 11 80       	mov    0x80112674,%eax
8010260b:	85 db                	test   %ebx,%ebx
8010260d:	74 08                	je     80102617 <kalloc+0x57>
    kmem.freelist = r->next;
8010260f:	8b 13                	mov    (%ebx),%edx
80102611:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
80102617:	85 c0                	test   %eax,%eax
80102619:	74 c6                	je     801025e1 <kalloc+0x21>
    release(&kmem.lock);
8010261b:	83 ec 0c             	sub    $0xc,%esp
8010261e:	68 40 26 11 80       	push   $0x80112640
80102623:	e8 b8 20 00 00       	call   801046e0 <release>
}
80102628:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
8010262a:	83 c4 10             	add    $0x10,%esp
}
8010262d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102630:	c9                   	leave  
80102631:	c3                   	ret    
80102632:	66 90                	xchg   %ax,%ax
80102634:	66 90                	xchg   %ax,%ax
80102636:	66 90                	xchg   %ax,%ax
80102638:	66 90                	xchg   %ax,%ax
8010263a:	66 90                	xchg   %ax,%ax
8010263c:	66 90                	xchg   %ax,%ax
8010263e:	66 90                	xchg   %ax,%ax

80102640 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102640:	ba 64 00 00 00       	mov    $0x64,%edx
80102645:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102646:	a8 01                	test   $0x1,%al
80102648:	0f 84 c2 00 00 00    	je     80102710 <kbdgetc+0xd0>
{
8010264e:	55                   	push   %ebp
8010264f:	ba 60 00 00 00       	mov    $0x60,%edx
80102654:	89 e5                	mov    %esp,%ebp
80102656:	53                   	push   %ebx
80102657:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102658:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010265b:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
80102661:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102667:	74 57                	je     801026c0 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102669:	89 d9                	mov    %ebx,%ecx
8010266b:	83 e1 40             	and    $0x40,%ecx
8010266e:	84 c0                	test   %al,%al
80102670:	78 5e                	js     801026d0 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102672:	85 c9                	test   %ecx,%ecx
80102674:	74 09                	je     8010267f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102676:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102679:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
8010267c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
8010267f:	0f b6 8a 60 75 10 80 	movzbl -0x7fef8aa0(%edx),%ecx
  shift ^= togglecode[data];
80102686:	0f b6 82 60 74 10 80 	movzbl -0x7fef8ba0(%edx),%eax
  shift |= shiftcode[data];
8010268d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
8010268f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102691:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102693:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102699:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010269c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010269f:	8b 04 85 40 74 10 80 	mov    -0x7fef8bc0(,%eax,4),%eax
801026a6:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801026aa:	74 0b                	je     801026b7 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
801026ac:	8d 50 9f             	lea    -0x61(%eax),%edx
801026af:	83 fa 19             	cmp    $0x19,%edx
801026b2:	77 44                	ja     801026f8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801026b4:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801026b7:	5b                   	pop    %ebx
801026b8:	5d                   	pop    %ebp
801026b9:	c3                   	ret    
801026ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
801026c0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801026c3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801026c5:	89 1d b4 a5 10 80    	mov    %ebx,0x8010a5b4
}
801026cb:	5b                   	pop    %ebx
801026cc:	5d                   	pop    %ebp
801026cd:	c3                   	ret    
801026ce:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801026d0:	83 e0 7f             	and    $0x7f,%eax
801026d3:	85 c9                	test   %ecx,%ecx
801026d5:	0f 44 d0             	cmove  %eax,%edx
    return 0;
801026d8:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801026da:	0f b6 8a 60 75 10 80 	movzbl -0x7fef8aa0(%edx),%ecx
801026e1:	83 c9 40             	or     $0x40,%ecx
801026e4:	0f b6 c9             	movzbl %cl,%ecx
801026e7:	f7 d1                	not    %ecx
801026e9:	21 d9                	and    %ebx,%ecx
}
801026eb:	5b                   	pop    %ebx
801026ec:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
801026ed:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
801026f3:	c3                   	ret    
801026f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801026f8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801026fb:	8d 50 20             	lea    0x20(%eax),%edx
}
801026fe:	5b                   	pop    %ebx
801026ff:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102700:	83 f9 1a             	cmp    $0x1a,%ecx
80102703:	0f 42 c2             	cmovb  %edx,%eax
}
80102706:	c3                   	ret    
80102707:	89 f6                	mov    %esi,%esi
80102709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102710:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102715:	c3                   	ret    
80102716:	8d 76 00             	lea    0x0(%esi),%esi
80102719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102720 <kbdintr>:

void
kbdintr(void)
{
80102720:	55                   	push   %ebp
80102721:	89 e5                	mov    %esp,%ebp
80102723:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102726:	68 40 26 10 80       	push   $0x80102640
8010272b:	e8 30 e1 ff ff       	call   80100860 <consoleintr>
}
80102730:	83 c4 10             	add    $0x10,%esp
80102733:	c9                   	leave  
80102734:	c3                   	ret    
80102735:	66 90                	xchg   %ax,%ax
80102737:	66 90                	xchg   %ax,%ax
80102739:	66 90                	xchg   %ax,%ax
8010273b:	66 90                	xchg   %ax,%ax
8010273d:	66 90                	xchg   %ax,%ax
8010273f:	90                   	nop

80102740 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102740:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102745:	85 c0                	test   %eax,%eax
80102747:	0f 84 cb 00 00 00    	je     80102818 <lapicinit+0xd8>
  lapic[index] = value;
8010274d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102754:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102757:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010275a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102761:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102764:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102767:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010276e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102771:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102774:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010277b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010277e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102781:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102788:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010278b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010278e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102795:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102798:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010279b:	8b 50 30             	mov    0x30(%eax),%edx
8010279e:	c1 ea 10             	shr    $0x10,%edx
801027a1:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801027a7:	75 77                	jne    80102820 <lapicinit+0xe0>
  lapic[index] = value;
801027a9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801027b0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027b3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027b6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801027bd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027c0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027c3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801027ca:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027cd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027d0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027d7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027da:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027dd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801027e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027e7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027ea:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801027f1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801027f4:	8b 50 20             	mov    0x20(%eax),%edx
801027f7:	89 f6                	mov    %esi,%esi
801027f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102800:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102806:	80 e6 10             	and    $0x10,%dh
80102809:	75 f5                	jne    80102800 <lapicinit+0xc0>
  lapic[index] = value;
8010280b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102812:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102815:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102818:	c3                   	ret    
80102819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102820:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102827:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010282a:	8b 50 20             	mov    0x20(%eax),%edx
8010282d:	e9 77 ff ff ff       	jmp    801027a9 <lapicinit+0x69>
80102832:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102840 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102840:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102845:	85 c0                	test   %eax,%eax
80102847:	74 07                	je     80102850 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102849:	8b 40 20             	mov    0x20(%eax),%eax
8010284c:	c1 e8 18             	shr    $0x18,%eax
8010284f:	c3                   	ret    
    return 0;
80102850:	31 c0                	xor    %eax,%eax
}
80102852:	c3                   	ret    
80102853:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102860 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102860:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102865:	85 c0                	test   %eax,%eax
80102867:	74 0d                	je     80102876 <lapiceoi+0x16>
  lapic[index] = value;
80102869:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102870:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102873:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102876:	c3                   	ret    
80102877:	89 f6                	mov    %esi,%esi
80102879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102880 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102880:	c3                   	ret    
80102881:	eb 0d                	jmp    80102890 <lapicstartap>
80102883:	90                   	nop
80102884:	90                   	nop
80102885:	90                   	nop
80102886:	90                   	nop
80102887:	90                   	nop
80102888:	90                   	nop
80102889:	90                   	nop
8010288a:	90                   	nop
8010288b:	90                   	nop
8010288c:	90                   	nop
8010288d:	90                   	nop
8010288e:	90                   	nop
8010288f:	90                   	nop

80102890 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102890:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102891:	b8 0f 00 00 00       	mov    $0xf,%eax
80102896:	ba 70 00 00 00       	mov    $0x70,%edx
8010289b:	89 e5                	mov    %esp,%ebp
8010289d:	53                   	push   %ebx
8010289e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801028a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801028a4:	ee                   	out    %al,(%dx)
801028a5:	b8 0a 00 00 00       	mov    $0xa,%eax
801028aa:	ba 71 00 00 00       	mov    $0x71,%edx
801028af:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801028b0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801028b2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801028b5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801028bb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801028bd:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
801028c0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801028c2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801028c5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801028c8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801028ce:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801028d3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028d9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028dc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801028e3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028e9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801028f0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028f3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028f6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028fc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028ff:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102905:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102908:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010290e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102911:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
80102917:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
80102918:	8b 40 20             	mov    0x20(%eax),%eax
}
8010291b:	5d                   	pop    %ebp
8010291c:	c3                   	ret    
8010291d:	8d 76 00             	lea    0x0(%esi),%esi

80102920 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102920:	55                   	push   %ebp
80102921:	b8 0b 00 00 00       	mov    $0xb,%eax
80102926:	ba 70 00 00 00       	mov    $0x70,%edx
8010292b:	89 e5                	mov    %esp,%ebp
8010292d:	57                   	push   %edi
8010292e:	56                   	push   %esi
8010292f:	53                   	push   %ebx
80102930:	83 ec 4c             	sub    $0x4c,%esp
80102933:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102934:	ba 71 00 00 00       	mov    $0x71,%edx
80102939:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010293a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010293d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102942:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102945:	8d 76 00             	lea    0x0(%esi),%esi
80102948:	31 c0                	xor    %eax,%eax
8010294a:	89 da                	mov    %ebx,%edx
8010294c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010294d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102952:	89 ca                	mov    %ecx,%edx
80102954:	ec                   	in     (%dx),%al
80102955:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102958:	89 da                	mov    %ebx,%edx
8010295a:	b8 02 00 00 00       	mov    $0x2,%eax
8010295f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102960:	89 ca                	mov    %ecx,%edx
80102962:	ec                   	in     (%dx),%al
80102963:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102966:	89 da                	mov    %ebx,%edx
80102968:	b8 04 00 00 00       	mov    $0x4,%eax
8010296d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010296e:	89 ca                	mov    %ecx,%edx
80102970:	ec                   	in     (%dx),%al
80102971:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102974:	89 da                	mov    %ebx,%edx
80102976:	b8 07 00 00 00       	mov    $0x7,%eax
8010297b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010297c:	89 ca                	mov    %ecx,%edx
8010297e:	ec                   	in     (%dx),%al
8010297f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102982:	89 da                	mov    %ebx,%edx
80102984:	b8 08 00 00 00       	mov    $0x8,%eax
80102989:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010298a:	89 ca                	mov    %ecx,%edx
8010298c:	ec                   	in     (%dx),%al
8010298d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010298f:	89 da                	mov    %ebx,%edx
80102991:	b8 09 00 00 00       	mov    $0x9,%eax
80102996:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102997:	89 ca                	mov    %ecx,%edx
80102999:	ec                   	in     (%dx),%al
8010299a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010299c:	89 da                	mov    %ebx,%edx
8010299e:	b8 0a 00 00 00       	mov    $0xa,%eax
801029a3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029a4:	89 ca                	mov    %ecx,%edx
801029a6:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801029a7:	84 c0                	test   %al,%al
801029a9:	78 9d                	js     80102948 <cmostime+0x28>
  return inb(CMOS_RETURN);
801029ab:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801029af:	89 fa                	mov    %edi,%edx
801029b1:	0f b6 fa             	movzbl %dl,%edi
801029b4:	89 f2                	mov    %esi,%edx
801029b6:	89 45 b8             	mov    %eax,-0x48(%ebp)
801029b9:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801029bd:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029c0:	89 da                	mov    %ebx,%edx
801029c2:	89 7d c8             	mov    %edi,-0x38(%ebp)
801029c5:	89 45 bc             	mov    %eax,-0x44(%ebp)
801029c8:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801029cc:	89 75 cc             	mov    %esi,-0x34(%ebp)
801029cf:	89 45 c0             	mov    %eax,-0x40(%ebp)
801029d2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801029d6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801029d9:	31 c0                	xor    %eax,%eax
801029db:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029dc:	89 ca                	mov    %ecx,%edx
801029de:	ec                   	in     (%dx),%al
801029df:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e2:	89 da                	mov    %ebx,%edx
801029e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801029e7:	b8 02 00 00 00       	mov    $0x2,%eax
801029ec:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029ed:	89 ca                	mov    %ecx,%edx
801029ef:	ec                   	in     (%dx),%al
801029f0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f3:	89 da                	mov    %ebx,%edx
801029f5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801029f8:	b8 04 00 00 00       	mov    $0x4,%eax
801029fd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fe:	89 ca                	mov    %ecx,%edx
80102a00:	ec                   	in     (%dx),%al
80102a01:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a04:	89 da                	mov    %ebx,%edx
80102a06:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a09:	b8 07 00 00 00       	mov    $0x7,%eax
80102a0e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0f:	89 ca                	mov    %ecx,%edx
80102a11:	ec                   	in     (%dx),%al
80102a12:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a15:	89 da                	mov    %ebx,%edx
80102a17:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102a1a:	b8 08 00 00 00       	mov    $0x8,%eax
80102a1f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a20:	89 ca                	mov    %ecx,%edx
80102a22:	ec                   	in     (%dx),%al
80102a23:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a26:	89 da                	mov    %ebx,%edx
80102a28:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102a2b:	b8 09 00 00 00       	mov    $0x9,%eax
80102a30:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a31:	89 ca                	mov    %ecx,%edx
80102a33:	ec                   	in     (%dx),%al
80102a34:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102a37:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102a3a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102a3d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102a40:	6a 18                	push   $0x18
80102a42:	50                   	push   %eax
80102a43:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102a46:	50                   	push   %eax
80102a47:	e8 34 1d 00 00       	call   80104780 <memcmp>
80102a4c:	83 c4 10             	add    $0x10,%esp
80102a4f:	85 c0                	test   %eax,%eax
80102a51:	0f 85 f1 fe ff ff    	jne    80102948 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102a57:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102a5b:	75 78                	jne    80102ad5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102a5d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a60:	89 c2                	mov    %eax,%edx
80102a62:	83 e0 0f             	and    $0xf,%eax
80102a65:	c1 ea 04             	shr    $0x4,%edx
80102a68:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a6b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a6e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102a71:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a74:	89 c2                	mov    %eax,%edx
80102a76:	83 e0 0f             	and    $0xf,%eax
80102a79:	c1 ea 04             	shr    $0x4,%edx
80102a7c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a7f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a82:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102a85:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a88:	89 c2                	mov    %eax,%edx
80102a8a:	83 e0 0f             	and    $0xf,%eax
80102a8d:	c1 ea 04             	shr    $0x4,%edx
80102a90:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a93:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a96:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102a99:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a9c:	89 c2                	mov    %eax,%edx
80102a9e:	83 e0 0f             	and    $0xf,%eax
80102aa1:	c1 ea 04             	shr    $0x4,%edx
80102aa4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102aa7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102aaa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102aad:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ab0:	89 c2                	mov    %eax,%edx
80102ab2:	83 e0 0f             	and    $0xf,%eax
80102ab5:	c1 ea 04             	shr    $0x4,%edx
80102ab8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102abb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102abe:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102ac1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ac4:	89 c2                	mov    %eax,%edx
80102ac6:	83 e0 0f             	and    $0xf,%eax
80102ac9:	c1 ea 04             	shr    $0x4,%edx
80102acc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102acf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ad2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102ad5:	8b 75 08             	mov    0x8(%ebp),%esi
80102ad8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102adb:	89 06                	mov    %eax,(%esi)
80102add:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ae0:	89 46 04             	mov    %eax,0x4(%esi)
80102ae3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ae6:	89 46 08             	mov    %eax,0x8(%esi)
80102ae9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102aec:	89 46 0c             	mov    %eax,0xc(%esi)
80102aef:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102af2:	89 46 10             	mov    %eax,0x10(%esi)
80102af5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102af8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102afb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b05:	5b                   	pop    %ebx
80102b06:	5e                   	pop    %esi
80102b07:	5f                   	pop    %edi
80102b08:	5d                   	pop    %ebp
80102b09:	c3                   	ret    
80102b0a:	66 90                	xchg   %ax,%ax
80102b0c:	66 90                	xchg   %ax,%ax
80102b0e:	66 90                	xchg   %ax,%ax

80102b10 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b10:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102b16:	85 c9                	test   %ecx,%ecx
80102b18:	0f 8e 8a 00 00 00    	jle    80102ba8 <install_trans+0x98>
{
80102b1e:	55                   	push   %ebp
80102b1f:	89 e5                	mov    %esp,%ebp
80102b21:	57                   	push   %edi
80102b22:	56                   	push   %esi
80102b23:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102b24:	31 db                	xor    %ebx,%ebx
{
80102b26:	83 ec 0c             	sub    $0xc,%esp
80102b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102b30:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102b35:	83 ec 08             	sub    $0x8,%esp
80102b38:	01 d8                	add    %ebx,%eax
80102b3a:	83 c0 01             	add    $0x1,%eax
80102b3d:	50                   	push   %eax
80102b3e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102b44:	e8 87 d5 ff ff       	call   801000d0 <bread>
80102b49:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b4b:	58                   	pop    %eax
80102b4c:	5a                   	pop    %edx
80102b4d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102b54:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102b5a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b5d:	e8 6e d5 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102b62:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b65:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102b67:	8d 47 5c             	lea    0x5c(%edi),%eax
80102b6a:	68 00 02 00 00       	push   $0x200
80102b6f:	50                   	push   %eax
80102b70:	8d 46 5c             	lea    0x5c(%esi),%eax
80102b73:	50                   	push   %eax
80102b74:	e8 57 1c 00 00       	call   801047d0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102b79:	89 34 24             	mov    %esi,(%esp)
80102b7c:	e8 2f d6 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102b81:	89 3c 24             	mov    %edi,(%esp)
80102b84:	e8 67 d6 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102b89:	89 34 24             	mov    %esi,(%esp)
80102b8c:	e8 5f d6 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102b91:	83 c4 10             	add    $0x10,%esp
80102b94:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102b9a:	7f 94                	jg     80102b30 <install_trans+0x20>
  }
}
80102b9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b9f:	5b                   	pop    %ebx
80102ba0:	5e                   	pop    %esi
80102ba1:	5f                   	pop    %edi
80102ba2:	5d                   	pop    %ebp
80102ba3:	c3                   	ret    
80102ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ba8:	c3                   	ret    
80102ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102bb0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102bb0:	55                   	push   %ebp
80102bb1:	89 e5                	mov    %esp,%ebp
80102bb3:	53                   	push   %ebx
80102bb4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102bb7:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102bbd:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102bc3:	e8 08 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102bc8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102bcb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102bcd:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102bd2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102bd5:	85 c0                	test   %eax,%eax
80102bd7:	7e 19                	jle    80102bf2 <write_head+0x42>
80102bd9:	31 d2                	xor    %edx,%edx
80102bdb:	90                   	nop
80102bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102be0:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102be7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102beb:	83 c2 01             	add    $0x1,%edx
80102bee:	39 d0                	cmp    %edx,%eax
80102bf0:	75 ee                	jne    80102be0 <write_head+0x30>
  }
  bwrite(buf);
80102bf2:	83 ec 0c             	sub    $0xc,%esp
80102bf5:	53                   	push   %ebx
80102bf6:	e8 b5 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102bfb:	89 1c 24             	mov    %ebx,(%esp)
80102bfe:	e8 ed d5 ff ff       	call   801001f0 <brelse>
}
80102c03:	83 c4 10             	add    $0x10,%esp
80102c06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c09:	c9                   	leave  
80102c0a:	c3                   	ret    
80102c0b:	90                   	nop
80102c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102c10 <initlog>:
{
80102c10:	55                   	push   %ebp
80102c11:	89 e5                	mov    %esp,%ebp
80102c13:	53                   	push   %ebx
80102c14:	83 ec 2c             	sub    $0x2c,%esp
80102c17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102c1a:	68 60 76 10 80       	push   $0x80107660
80102c1f:	68 80 26 11 80       	push   $0x80112680
80102c24:	e8 97 18 00 00       	call   801044c0 <initlock>
  readsb(dev, &sb);
80102c29:	58                   	pop    %eax
80102c2a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102c2d:	5a                   	pop    %edx
80102c2e:	50                   	push   %eax
80102c2f:	53                   	push   %ebx
80102c30:	e8 3b e8 ff ff       	call   80101470 <readsb>
  log.start = sb.logstart;
80102c35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102c38:	59                   	pop    %ecx
  log.dev = dev;
80102c39:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102c3f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102c42:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
80102c47:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  struct buf *buf = bread(log.dev, log.start);
80102c4d:	5a                   	pop    %edx
80102c4e:	50                   	push   %eax
80102c4f:	53                   	push   %ebx
80102c50:	e8 7b d4 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102c55:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102c58:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102c5b:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102c61:	85 c9                	test   %ecx,%ecx
80102c63:	7e 1d                	jle    80102c82 <initlog+0x72>
80102c65:	31 d2                	xor    %edx,%edx
80102c67:	89 f6                	mov    %esi,%esi
80102c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.lh.block[i] = lh->block[i];
80102c70:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102c74:	89 1c 95 cc 26 11 80 	mov    %ebx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c7b:	83 c2 01             	add    $0x1,%edx
80102c7e:	39 d1                	cmp    %edx,%ecx
80102c80:	75 ee                	jne    80102c70 <initlog+0x60>
  brelse(buf);
80102c82:	83 ec 0c             	sub    $0xc,%esp
80102c85:	50                   	push   %eax
80102c86:	e8 65 d5 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102c8b:	e8 80 fe ff ff       	call   80102b10 <install_trans>
  log.lh.n = 0;
80102c90:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c97:	00 00 00 
  write_head(); // clear the log
80102c9a:	e8 11 ff ff ff       	call   80102bb0 <write_head>
}
80102c9f:	83 c4 10             	add    $0x10,%esp
80102ca2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ca5:	c9                   	leave  
80102ca6:	c3                   	ret    
80102ca7:	89 f6                	mov    %esi,%esi
80102ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102cb0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102cb0:	55                   	push   %ebp
80102cb1:	89 e5                	mov    %esp,%ebp
80102cb3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102cb6:	68 80 26 11 80       	push   $0x80112680
80102cbb:	e8 00 19 00 00       	call   801045c0 <acquire>
80102cc0:	83 c4 10             	add    $0x10,%esp
80102cc3:	eb 18                	jmp    80102cdd <begin_op+0x2d>
80102cc5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102cc8:	83 ec 08             	sub    $0x8,%esp
80102ccb:	68 80 26 11 80       	push   $0x80112680
80102cd0:	68 80 26 11 80       	push   $0x80112680
80102cd5:	e8 e6 11 00 00       	call   80103ec0 <sleep>
80102cda:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102cdd:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102ce2:	85 c0                	test   %eax,%eax
80102ce4:	75 e2                	jne    80102cc8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102ce6:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102ceb:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102cf1:	83 c0 01             	add    $0x1,%eax
80102cf4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102cf7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102cfa:	83 fa 1e             	cmp    $0x1e,%edx
80102cfd:	7f c9                	jg     80102cc8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102cff:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d02:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102d07:	68 80 26 11 80       	push   $0x80112680
80102d0c:	e8 cf 19 00 00       	call   801046e0 <release>
      break;
    }
  }
}
80102d11:	83 c4 10             	add    $0x10,%esp
80102d14:	c9                   	leave  
80102d15:	c3                   	ret    
80102d16:	8d 76 00             	lea    0x0(%esi),%esi
80102d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d20 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102d20:	55                   	push   %ebp
80102d21:	89 e5                	mov    %esp,%ebp
80102d23:	57                   	push   %edi
80102d24:	56                   	push   %esi
80102d25:	53                   	push   %ebx
80102d26:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102d29:	68 80 26 11 80       	push   $0x80112680
80102d2e:	e8 8d 18 00 00       	call   801045c0 <acquire>
  log.outstanding -= 1;
80102d33:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102d38:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102d3e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102d41:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102d44:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102d4a:	85 f6                	test   %esi,%esi
80102d4c:	0f 85 22 01 00 00    	jne    80102e74 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102d52:	85 db                	test   %ebx,%ebx
80102d54:	0f 85 f6 00 00 00    	jne    80102e50 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102d5a:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102d61:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102d64:	83 ec 0c             	sub    $0xc,%esp
80102d67:	68 80 26 11 80       	push   $0x80112680
80102d6c:	e8 6f 19 00 00       	call   801046e0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102d71:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102d77:	83 c4 10             	add    $0x10,%esp
80102d7a:	85 c9                	test   %ecx,%ecx
80102d7c:	7f 42                	jg     80102dc0 <end_op+0xa0>
    acquire(&log.lock);
80102d7e:	83 ec 0c             	sub    $0xc,%esp
80102d81:	68 80 26 11 80       	push   $0x80112680
80102d86:	e8 35 18 00 00       	call   801045c0 <acquire>
    wakeup(&log);
80102d8b:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102d92:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102d99:	00 00 00 
    wakeup(&log);
80102d9c:	e8 cf 12 00 00       	call   80104070 <wakeup>
    release(&log.lock);
80102da1:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102da8:	e8 33 19 00 00       	call   801046e0 <release>
80102dad:	83 c4 10             	add    $0x10,%esp
}
80102db0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102db3:	5b                   	pop    %ebx
80102db4:	5e                   	pop    %esi
80102db5:	5f                   	pop    %edi
80102db6:	5d                   	pop    %ebp
80102db7:	c3                   	ret    
80102db8:	90                   	nop
80102db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102dc0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102dc5:	83 ec 08             	sub    $0x8,%esp
80102dc8:	01 d8                	add    %ebx,%eax
80102dca:	83 c0 01             	add    $0x1,%eax
80102dcd:	50                   	push   %eax
80102dce:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102dd4:	e8 f7 d2 ff ff       	call   801000d0 <bread>
80102dd9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ddb:	58                   	pop    %eax
80102ddc:	5a                   	pop    %edx
80102ddd:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102de4:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102dea:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ded:	e8 de d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102df2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102df5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102df7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102dfa:	68 00 02 00 00       	push   $0x200
80102dff:	50                   	push   %eax
80102e00:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e03:	50                   	push   %eax
80102e04:	e8 c7 19 00 00       	call   801047d0 <memmove>
    bwrite(to);  // write the log
80102e09:	89 34 24             	mov    %esi,(%esp)
80102e0c:	e8 9f d3 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102e11:	89 3c 24             	mov    %edi,(%esp)
80102e14:	e8 d7 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102e19:	89 34 24             	mov    %esi,(%esp)
80102e1c:	e8 cf d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e21:	83 c4 10             	add    $0x10,%esp
80102e24:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102e2a:	7c 94                	jl     80102dc0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102e2c:	e8 7f fd ff ff       	call   80102bb0 <write_head>
    install_trans(); // Now install writes to home locations
80102e31:	e8 da fc ff ff       	call   80102b10 <install_trans>
    log.lh.n = 0;
80102e36:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102e3d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102e40:	e8 6b fd ff ff       	call   80102bb0 <write_head>
80102e45:	e9 34 ff ff ff       	jmp    80102d7e <end_op+0x5e>
80102e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102e50:	83 ec 0c             	sub    $0xc,%esp
80102e53:	68 80 26 11 80       	push   $0x80112680
80102e58:	e8 13 12 00 00       	call   80104070 <wakeup>
  release(&log.lock);
80102e5d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102e64:	e8 77 18 00 00       	call   801046e0 <release>
80102e69:	83 c4 10             	add    $0x10,%esp
}
80102e6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e6f:	5b                   	pop    %ebx
80102e70:	5e                   	pop    %esi
80102e71:	5f                   	pop    %edi
80102e72:	5d                   	pop    %ebp
80102e73:	c3                   	ret    
    panic("log.committing");
80102e74:	83 ec 0c             	sub    $0xc,%esp
80102e77:	68 64 76 10 80       	push   $0x80107664
80102e7c:	e8 0f d5 ff ff       	call   80100390 <panic>
80102e81:	eb 0d                	jmp    80102e90 <log_write>
80102e83:	90                   	nop
80102e84:	90                   	nop
80102e85:	90                   	nop
80102e86:	90                   	nop
80102e87:	90                   	nop
80102e88:	90                   	nop
80102e89:	90                   	nop
80102e8a:	90                   	nop
80102e8b:	90                   	nop
80102e8c:	90                   	nop
80102e8d:	90                   	nop
80102e8e:	90                   	nop
80102e8f:	90                   	nop

80102e90 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102e90:	55                   	push   %ebp
80102e91:	89 e5                	mov    %esp,%ebp
80102e93:	53                   	push   %ebx
80102e94:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102e97:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102e9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ea0:	83 fa 1d             	cmp    $0x1d,%edx
80102ea3:	0f 8f 94 00 00 00    	jg     80102f3d <log_write+0xad>
80102ea9:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102eae:	83 e8 01             	sub    $0x1,%eax
80102eb1:	39 c2                	cmp    %eax,%edx
80102eb3:	0f 8d 84 00 00 00    	jge    80102f3d <log_write+0xad>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102eb9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102ebe:	85 c0                	test   %eax,%eax
80102ec0:	0f 8e 84 00 00 00    	jle    80102f4a <log_write+0xba>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102ec6:	83 ec 0c             	sub    $0xc,%esp
80102ec9:	68 80 26 11 80       	push   $0x80112680
80102ece:	e8 ed 16 00 00       	call   801045c0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102ed3:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102ed9:	83 c4 10             	add    $0x10,%esp
80102edc:	85 d2                	test   %edx,%edx
80102ede:	7e 51                	jle    80102f31 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ee0:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102ee3:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ee5:	3b 0d cc 26 11 80    	cmp    0x801126cc,%ecx
80102eeb:	75 0c                	jne    80102ef9 <log_write+0x69>
80102eed:	eb 39                	jmp    80102f28 <log_write+0x98>
80102eef:	90                   	nop
80102ef0:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102ef7:	74 2f                	je     80102f28 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102ef9:	83 c0 01             	add    $0x1,%eax
80102efc:	39 c2                	cmp    %eax,%edx
80102efe:	75 f0                	jne    80102ef0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f00:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102f07:	83 c2 01             	add    $0x1,%edx
80102f0a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102f10:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102f13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102f16:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102f1d:	c9                   	leave  
  release(&log.lock);
80102f1e:	e9 bd 17 00 00       	jmp    801046e0 <release>
80102f23:	90                   	nop
80102f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  log.lh.block[i] = b->blockno;
80102f28:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
80102f2f:	eb df                	jmp    80102f10 <log_write+0x80>
  log.lh.block[i] = b->blockno;
80102f31:	8b 43 08             	mov    0x8(%ebx),%eax
80102f34:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102f39:	75 d5                	jne    80102f10 <log_write+0x80>
80102f3b:	eb ca                	jmp    80102f07 <log_write+0x77>
    panic("too big a transaction");
80102f3d:	83 ec 0c             	sub    $0xc,%esp
80102f40:	68 73 76 10 80       	push   $0x80107673
80102f45:	e8 46 d4 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102f4a:	83 ec 0c             	sub    $0xc,%esp
80102f4d:	68 89 76 10 80       	push   $0x80107689
80102f52:	e8 39 d4 ff ff       	call   80100390 <panic>
80102f57:	66 90                	xchg   %ax,%ax
80102f59:	66 90                	xchg   %ax,%ax
80102f5b:	66 90                	xchg   %ax,%ax
80102f5d:	66 90                	xchg   %ax,%ax
80102f5f:	90                   	nop

80102f60 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102f60:	55                   	push   %ebp
80102f61:	89 e5                	mov    %esp,%ebp
80102f63:	53                   	push   %ebx
80102f64:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102f67:	e8 74 09 00 00       	call   801038e0 <cpuid>
80102f6c:	89 c3                	mov    %eax,%ebx
80102f6e:	e8 6d 09 00 00       	call   801038e0 <cpuid>
80102f73:	83 ec 04             	sub    $0x4,%esp
80102f76:	53                   	push   %ebx
80102f77:	50                   	push   %eax
80102f78:	68 a4 76 10 80       	push   $0x801076a4
80102f7d:	e8 2e d7 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80102f82:	e8 79 2a 00 00       	call   80105a00 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102f87:	e8 d4 08 00 00       	call   80103860 <mycpu>
80102f8c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102f8e:	b8 01 00 00 00       	mov    $0x1,%eax
80102f93:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102f9a:	e8 21 0c 00 00       	call   80103bc0 <scheduler>
80102f9f:	90                   	nop

80102fa0 <mpenter>:
{
80102fa0:	55                   	push   %ebp
80102fa1:	89 e5                	mov    %esp,%ebp
80102fa3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102fa6:	e8 55 3b 00 00       	call   80106b00 <switchkvm>
  seginit();
80102fab:	e8 c0 3a 00 00       	call   80106a70 <seginit>
  lapicinit();
80102fb0:	e8 8b f7 ff ff       	call   80102740 <lapicinit>
  mpmain();
80102fb5:	e8 a6 ff ff ff       	call   80102f60 <mpmain>
80102fba:	66 90                	xchg   %ax,%ax
80102fbc:	66 90                	xchg   %ax,%ax
80102fbe:	66 90                	xchg   %ax,%ax

80102fc0 <main>:
{
80102fc0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102fc4:	83 e4 f0             	and    $0xfffffff0,%esp
80102fc7:	ff 71 fc             	pushl  -0x4(%ecx)
80102fca:	55                   	push   %ebp
80102fcb:	89 e5                	mov    %esp,%ebp
80102fcd:	53                   	push   %ebx
80102fce:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102fcf:	83 ec 08             	sub    $0x8,%esp
80102fd2:	68 00 00 40 80       	push   $0x80400000
80102fd7:	68 a8 55 11 80       	push   $0x801155a8
80102fdc:	e8 0f f5 ff ff       	call   801024f0 <kinit1>
  kvmalloc();      // kernel page table
80102fe1:	e8 da 3f 00 00       	call   80106fc0 <kvmalloc>
  mpinit();        // detect other processors
80102fe6:	e8 85 01 00 00       	call   80103170 <mpinit>
  lapicinit();     // interrupt controller
80102feb:	e8 50 f7 ff ff       	call   80102740 <lapicinit>
  seginit();       // segment descriptors
80102ff0:	e8 7b 3a 00 00       	call   80106a70 <seginit>
  picinit();       // disable pic
80102ff5:	e8 46 03 00 00       	call   80103340 <picinit>
  ioapicinit();    // another interrupt controller
80102ffa:	e8 11 f3 ff ff       	call   80102310 <ioapicinit>
  consoleinit();   // console hardware
80102fff:	e8 2c da ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103004:	e8 27 2d 00 00       	call   80105d30 <uartinit>
  pinit();         // process table
80103009:	e8 32 08 00 00       	call   80103840 <pinit>
  tvinit();        // trap vectors
8010300e:	e8 6d 29 00 00       	call   80105980 <tvinit>
  binit();         // buffer cache
80103013:	e8 28 d0 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103018:	e8 d3 dd ff ff       	call   80100df0 <fileinit>
  ideinit();       // disk 
8010301d:	e8 ce f0 ff ff       	call   801020f0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103022:	83 c4 0c             	add    $0xc,%esp
80103025:	68 8a 00 00 00       	push   $0x8a
8010302a:	68 8c a4 10 80       	push   $0x8010a48c
8010302f:	68 00 70 00 80       	push   $0x80007000
80103034:	e8 97 17 00 00       	call   801047d0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103039:	83 c4 10             	add    $0x10,%esp
8010303c:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103043:	00 00 00 
80103046:	05 80 27 11 80       	add    $0x80112780,%eax
8010304b:	3d 80 27 11 80       	cmp    $0x80112780,%eax
80103050:	76 7e                	jbe    801030d0 <main+0x110>
80103052:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80103057:	eb 20                	jmp    80103079 <main+0xb9>
80103059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103060:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103067:	00 00 00 
8010306a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103070:	05 80 27 11 80       	add    $0x80112780,%eax
80103075:	39 c3                	cmp    %eax,%ebx
80103077:	73 57                	jae    801030d0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103079:	e8 e2 07 00 00       	call   80103860 <mycpu>
8010307e:	39 d8                	cmp    %ebx,%eax
80103080:	74 de                	je     80103060 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103082:	e8 39 f5 ff ff       	call   801025c0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103087:	83 ec 08             	sub    $0x8,%esp
    *(void**)(code-8) = mpenter;
8010308a:	c7 05 f8 6f 00 80 a0 	movl   $0x80102fa0,0x80006ff8
80103091:	2f 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103094:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010309b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010309e:	05 00 10 00 00       	add    $0x1000,%eax
801030a3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801030a8:	0f b6 03             	movzbl (%ebx),%eax
801030ab:	68 00 70 00 00       	push   $0x7000
801030b0:	50                   	push   %eax
801030b1:	e8 da f7 ff ff       	call   80102890 <lapicstartap>
801030b6:	83 c4 10             	add    $0x10,%esp
801030b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801030c0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801030c6:	85 c0                	test   %eax,%eax
801030c8:	74 f6                	je     801030c0 <main+0x100>
801030ca:	eb 94                	jmp    80103060 <main+0xa0>
801030cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801030d0:	83 ec 08             	sub    $0x8,%esp
801030d3:	68 00 00 00 8e       	push   $0x8e000000
801030d8:	68 00 00 40 80       	push   $0x80400000
801030dd:	e8 7e f4 ff ff       	call   80102560 <kinit2>
  userinit();      // first user process
801030e2:	e8 49 08 00 00       	call   80103930 <userinit>
  mpmain();        // finish this processor's setup
801030e7:	e8 74 fe ff ff       	call   80102f60 <mpmain>
801030ec:	66 90                	xchg   %ax,%ax
801030ee:	66 90                	xchg   %ax,%ax

801030f0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801030f0:	55                   	push   %ebp
801030f1:	89 e5                	mov    %esp,%ebp
801030f3:	57                   	push   %edi
801030f4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801030f5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801030fb:	53                   	push   %ebx
  e = addr+len;
801030fc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801030ff:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103102:	39 de                	cmp    %ebx,%esi
80103104:	72 10                	jb     80103116 <mpsearch1+0x26>
80103106:	eb 50                	jmp    80103158 <mpsearch1+0x68>
80103108:	90                   	nop
80103109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103110:	89 fe                	mov    %edi,%esi
80103112:	39 fb                	cmp    %edi,%ebx
80103114:	76 42                	jbe    80103158 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103116:	83 ec 04             	sub    $0x4,%esp
80103119:	8d 7e 10             	lea    0x10(%esi),%edi
8010311c:	6a 04                	push   $0x4
8010311e:	68 b8 76 10 80       	push   $0x801076b8
80103123:	56                   	push   %esi
80103124:	e8 57 16 00 00       	call   80104780 <memcmp>
80103129:	83 c4 10             	add    $0x10,%esp
8010312c:	85 c0                	test   %eax,%eax
8010312e:	75 e0                	jne    80103110 <mpsearch1+0x20>
80103130:	89 f1                	mov    %esi,%ecx
80103132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103138:	0f b6 11             	movzbl (%ecx),%edx
8010313b:	83 c1 01             	add    $0x1,%ecx
8010313e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103140:	39 f9                	cmp    %edi,%ecx
80103142:	75 f4                	jne    80103138 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103144:	84 c0                	test   %al,%al
80103146:	75 c8                	jne    80103110 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103148:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010314b:	89 f0                	mov    %esi,%eax
8010314d:	5b                   	pop    %ebx
8010314e:	5e                   	pop    %esi
8010314f:	5f                   	pop    %edi
80103150:	5d                   	pop    %ebp
80103151:	c3                   	ret    
80103152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103158:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010315b:	31 f6                	xor    %esi,%esi
}
8010315d:	5b                   	pop    %ebx
8010315e:	89 f0                	mov    %esi,%eax
80103160:	5e                   	pop    %esi
80103161:	5f                   	pop    %edi
80103162:	5d                   	pop    %ebp
80103163:	c3                   	ret    
80103164:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010316a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103170 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103170:	55                   	push   %ebp
80103171:	89 e5                	mov    %esp,%ebp
80103173:	57                   	push   %edi
80103174:	56                   	push   %esi
80103175:	53                   	push   %ebx
80103176:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103179:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103180:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103187:	c1 e0 08             	shl    $0x8,%eax
8010318a:	09 d0                	or     %edx,%eax
8010318c:	c1 e0 04             	shl    $0x4,%eax
8010318f:	75 1b                	jne    801031ac <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103191:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103198:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010319f:	c1 e0 08             	shl    $0x8,%eax
801031a2:	09 d0                	or     %edx,%eax
801031a4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801031a7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801031ac:	ba 00 04 00 00       	mov    $0x400,%edx
801031b1:	e8 3a ff ff ff       	call   801030f0 <mpsearch1>
801031b6:	89 c7                	mov    %eax,%edi
801031b8:	85 c0                	test   %eax,%eax
801031ba:	0f 84 c0 00 00 00    	je     80103280 <mpinit+0x110>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031c0:	8b 5f 04             	mov    0x4(%edi),%ebx
801031c3:	85 db                	test   %ebx,%ebx
801031c5:	0f 84 d5 00 00 00    	je     801032a0 <mpinit+0x130>
  if(memcmp(conf, "PCMP", 4) != 0)
801031cb:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801031ce:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801031d4:	6a 04                	push   $0x4
801031d6:	68 d5 76 10 80       	push   $0x801076d5
801031db:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801031dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801031df:	e8 9c 15 00 00       	call   80104780 <memcmp>
801031e4:	83 c4 10             	add    $0x10,%esp
801031e7:	85 c0                	test   %eax,%eax
801031e9:	0f 85 b1 00 00 00    	jne    801032a0 <mpinit+0x130>
  if(conf->version != 1 && conf->version != 4)
801031ef:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801031f6:	3c 01                	cmp    $0x1,%al
801031f8:	0f 95 c2             	setne  %dl
801031fb:	3c 04                	cmp    $0x4,%al
801031fd:	0f 95 c0             	setne  %al
80103200:	20 c2                	and    %al,%dl
80103202:	0f 85 98 00 00 00    	jne    801032a0 <mpinit+0x130>
  if(sum((uchar*)conf, conf->length) != 0)
80103208:	0f b7 8b 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%ecx
  for(i=0; i<len; i++)
8010320f:	66 85 c9             	test   %cx,%cx
80103212:	74 21                	je     80103235 <mpinit+0xc5>
80103214:	89 d8                	mov    %ebx,%eax
80103216:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
  sum = 0;
80103219:	31 d2                	xor    %edx,%edx
8010321b:	90                   	nop
8010321c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103220:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103227:	83 c0 01             	add    $0x1,%eax
8010322a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010322c:	39 c6                	cmp    %eax,%esi
8010322e:	75 f0                	jne    80103220 <mpinit+0xb0>
80103230:	84 d2                	test   %dl,%dl
80103232:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103235:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103238:	85 c9                	test   %ecx,%ecx
8010323a:	74 64                	je     801032a0 <mpinit+0x130>
8010323c:	84 d2                	test   %dl,%dl
8010323e:	75 60                	jne    801032a0 <mpinit+0x130>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103240:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103246:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010324b:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103252:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103258:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010325d:	01 d1                	add    %edx,%ecx
8010325f:	89 ce                	mov    %ecx,%esi
80103261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103268:	39 c6                	cmp    %eax,%esi
8010326a:	76 4b                	jbe    801032b7 <mpinit+0x147>
    switch(*p){
8010326c:	0f b6 10             	movzbl (%eax),%edx
8010326f:	80 fa 04             	cmp    $0x4,%dl
80103272:	0f 87 bf 00 00 00    	ja     80103337 <mpinit+0x1c7>
80103278:	ff 24 95 fc 76 10 80 	jmp    *-0x7fef8904(,%edx,4)
8010327f:	90                   	nop
  return mpsearch1(0xF0000, 0x10000);
80103280:	ba 00 00 01 00       	mov    $0x10000,%edx
80103285:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010328a:	e8 61 fe ff ff       	call   801030f0 <mpsearch1>
8010328f:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103291:	85 c0                	test   %eax,%eax
80103293:	0f 85 27 ff ff ff    	jne    801031c0 <mpinit+0x50>
80103299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801032a0:	83 ec 0c             	sub    $0xc,%esp
801032a3:	68 bd 76 10 80       	push   $0x801076bd
801032a8:	e8 e3 d0 ff ff       	call   80100390 <panic>
801032ad:	8d 76 00             	lea    0x0(%esi),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801032b0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032b3:	39 c6                	cmp    %eax,%esi
801032b5:	77 b5                	ja     8010326c <mpinit+0xfc>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801032b7:	85 db                	test   %ebx,%ebx
801032b9:	74 6f                	je     8010332a <mpinit+0x1ba>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801032bb:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801032bf:	74 15                	je     801032d6 <mpinit+0x166>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032c1:	b8 70 00 00 00       	mov    $0x70,%eax
801032c6:	ba 22 00 00 00       	mov    $0x22,%edx
801032cb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032cc:	ba 23 00 00 00       	mov    $0x23,%edx
801032d1:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801032d2:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032d5:	ee                   	out    %al,(%dx)
  }
}
801032d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032d9:	5b                   	pop    %ebx
801032da:	5e                   	pop    %esi
801032db:	5f                   	pop    %edi
801032dc:	5d                   	pop    %ebp
801032dd:	c3                   	ret    
801032de:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
801032e0:	8b 15 00 2d 11 80    	mov    0x80112d00,%edx
801032e6:	83 fa 07             	cmp    $0x7,%edx
801032e9:	7f 1f                	jg     8010330a <mpinit+0x19a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801032eb:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801032f1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801032f4:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801032f8:	88 91 80 27 11 80    	mov    %dl,-0x7feed880(%ecx)
        ncpu++;
801032fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103301:	83 c2 01             	add    $0x1,%edx
80103304:	89 15 00 2d 11 80    	mov    %edx,0x80112d00
      p += sizeof(struct mpproc);
8010330a:	83 c0 14             	add    $0x14,%eax
      continue;
8010330d:	e9 56 ff ff ff       	jmp    80103268 <mpinit+0xf8>
80103312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ioapicid = ioapic->apicno;
80103318:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010331c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010331f:	88 15 60 27 11 80    	mov    %dl,0x80112760
      continue;
80103325:	e9 3e ff ff ff       	jmp    80103268 <mpinit+0xf8>
    panic("Didn't find a suitable machine");
8010332a:	83 ec 0c             	sub    $0xc,%esp
8010332d:	68 dc 76 10 80       	push   $0x801076dc
80103332:	e8 59 d0 ff ff       	call   80100390 <panic>
      ismp = 0;
80103337:	31 db                	xor    %ebx,%ebx
80103339:	e9 31 ff ff ff       	jmp    8010326f <mpinit+0xff>
8010333e:	66 90                	xchg   %ax,%ax

80103340 <picinit>:
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103340:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103345:	ba 21 00 00 00       	mov    $0x21,%edx
8010334a:	ee                   	out    %al,(%dx)
8010334b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103350:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103351:	c3                   	ret    
80103352:	66 90                	xchg   %ax,%ax
80103354:	66 90                	xchg   %ax,%ax
80103356:	66 90                	xchg   %ax,%ax
80103358:	66 90                	xchg   %ax,%ax
8010335a:	66 90                	xchg   %ax,%ax
8010335c:	66 90                	xchg   %ax,%ax
8010335e:	66 90                	xchg   %ax,%ax

80103360 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103360:	55                   	push   %ebp
80103361:	89 e5                	mov    %esp,%ebp
80103363:	57                   	push   %edi
80103364:	56                   	push   %esi
80103365:	53                   	push   %ebx
80103366:	83 ec 0c             	sub    $0xc,%esp
80103369:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010336c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010336f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103375:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010337b:	e8 90 da ff ff       	call   80100e10 <filealloc>
80103380:	89 03                	mov    %eax,(%ebx)
80103382:	85 c0                	test   %eax,%eax
80103384:	0f 84 a8 00 00 00    	je     80103432 <pipealloc+0xd2>
8010338a:	e8 81 da ff ff       	call   80100e10 <filealloc>
8010338f:	89 06                	mov    %eax,(%esi)
80103391:	85 c0                	test   %eax,%eax
80103393:	0f 84 87 00 00 00    	je     80103420 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103399:	e8 22 f2 ff ff       	call   801025c0 <kalloc>
8010339e:	89 c7                	mov    %eax,%edi
801033a0:	85 c0                	test   %eax,%eax
801033a2:	0f 84 b0 00 00 00    	je     80103458 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
801033a8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801033af:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801033b2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801033b5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801033bc:	00 00 00 
  p->nwrite = 0;
801033bf:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801033c6:	00 00 00 
  p->nread = 0;
801033c9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801033d0:	00 00 00 
  initlock(&p->lock, "pipe");
801033d3:	68 10 77 10 80       	push   $0x80107710
801033d8:	50                   	push   %eax
801033d9:	e8 e2 10 00 00       	call   801044c0 <initlock>
  (*f0)->type = FD_PIPE;
801033de:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801033e0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801033e3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801033e9:	8b 03                	mov    (%ebx),%eax
801033eb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801033ef:	8b 03                	mov    (%ebx),%eax
801033f1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801033f5:	8b 03                	mov    (%ebx),%eax
801033f7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801033fa:	8b 06                	mov    (%esi),%eax
801033fc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103402:	8b 06                	mov    (%esi),%eax
80103404:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103408:	8b 06                	mov    (%esi),%eax
8010340a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010340e:	8b 06                	mov    (%esi),%eax
80103410:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103413:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103416:	31 c0                	xor    %eax,%eax
}
80103418:	5b                   	pop    %ebx
80103419:	5e                   	pop    %esi
8010341a:	5f                   	pop    %edi
8010341b:	5d                   	pop    %ebp
8010341c:	c3                   	ret    
8010341d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103420:	8b 03                	mov    (%ebx),%eax
80103422:	85 c0                	test   %eax,%eax
80103424:	74 1e                	je     80103444 <pipealloc+0xe4>
    fileclose(*f0);
80103426:	83 ec 0c             	sub    $0xc,%esp
80103429:	50                   	push   %eax
8010342a:	e8 a1 da ff ff       	call   80100ed0 <fileclose>
8010342f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103432:	8b 06                	mov    (%esi),%eax
80103434:	85 c0                	test   %eax,%eax
80103436:	74 0c                	je     80103444 <pipealloc+0xe4>
    fileclose(*f1);
80103438:	83 ec 0c             	sub    $0xc,%esp
8010343b:	50                   	push   %eax
8010343c:	e8 8f da ff ff       	call   80100ed0 <fileclose>
80103441:	83 c4 10             	add    $0x10,%esp
}
80103444:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103447:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010344c:	5b                   	pop    %ebx
8010344d:	5e                   	pop    %esi
8010344e:	5f                   	pop    %edi
8010344f:	5d                   	pop    %ebp
80103450:	c3                   	ret    
80103451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103458:	8b 03                	mov    (%ebx),%eax
8010345a:	85 c0                	test   %eax,%eax
8010345c:	75 c8                	jne    80103426 <pipealloc+0xc6>
8010345e:	eb d2                	jmp    80103432 <pipealloc+0xd2>

80103460 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103460:	55                   	push   %ebp
80103461:	89 e5                	mov    %esp,%ebp
80103463:	56                   	push   %esi
80103464:	53                   	push   %ebx
80103465:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103468:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010346b:	83 ec 0c             	sub    $0xc,%esp
8010346e:	53                   	push   %ebx
8010346f:	e8 4c 11 00 00       	call   801045c0 <acquire>
  if(writable){
80103474:	83 c4 10             	add    $0x10,%esp
80103477:	85 f6                	test   %esi,%esi
80103479:	74 65                	je     801034e0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010347b:	83 ec 0c             	sub    $0xc,%esp
8010347e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103484:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010348b:	00 00 00 
    wakeup(&p->nread);
8010348e:	50                   	push   %eax
8010348f:	e8 dc 0b 00 00       	call   80104070 <wakeup>
80103494:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103497:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010349d:	85 d2                	test   %edx,%edx
8010349f:	75 0a                	jne    801034ab <pipeclose+0x4b>
801034a1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801034a7:	85 c0                	test   %eax,%eax
801034a9:	74 15                	je     801034c0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801034ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801034ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034b1:	5b                   	pop    %ebx
801034b2:	5e                   	pop    %esi
801034b3:	5d                   	pop    %ebp
    release(&p->lock);
801034b4:	e9 27 12 00 00       	jmp    801046e0 <release>
801034b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801034c0:	83 ec 0c             	sub    $0xc,%esp
801034c3:	53                   	push   %ebx
801034c4:	e8 17 12 00 00       	call   801046e0 <release>
    kfree((char*)p);
801034c9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801034cc:	83 c4 10             	add    $0x10,%esp
}
801034cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034d2:	5b                   	pop    %ebx
801034d3:	5e                   	pop    %esi
801034d4:	5d                   	pop    %ebp
    kfree((char*)p);
801034d5:	e9 26 ef ff ff       	jmp    80102400 <kfree>
801034da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801034e0:	83 ec 0c             	sub    $0xc,%esp
801034e3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801034e9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801034f0:	00 00 00 
    wakeup(&p->nwrite);
801034f3:	50                   	push   %eax
801034f4:	e8 77 0b 00 00       	call   80104070 <wakeup>
801034f9:	83 c4 10             	add    $0x10,%esp
801034fc:	eb 99                	jmp    80103497 <pipeclose+0x37>
801034fe:	66 90                	xchg   %ax,%ax

80103500 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	57                   	push   %edi
80103504:	56                   	push   %esi
80103505:	53                   	push   %ebx
80103506:	83 ec 28             	sub    $0x28,%esp
80103509:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010350c:	53                   	push   %ebx
8010350d:	e8 ae 10 00 00       	call   801045c0 <acquire>
  for(i = 0; i < n; i++){
80103512:	8b 45 10             	mov    0x10(%ebp),%eax
80103515:	83 c4 10             	add    $0x10,%esp
80103518:	85 c0                	test   %eax,%eax
8010351a:	0f 8e c8 00 00 00    	jle    801035e8 <pipewrite+0xe8>
80103520:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103523:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103529:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010352f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103532:	03 4d 10             	add    0x10(%ebp),%ecx
80103535:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103538:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010353e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103544:	39 d0                	cmp    %edx,%eax
80103546:	75 71                	jne    801035b9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103548:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010354e:	85 c0                	test   %eax,%eax
80103550:	74 4e                	je     801035a0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103552:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103558:	eb 3a                	jmp    80103594 <pipewrite+0x94>
8010355a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103560:	83 ec 0c             	sub    $0xc,%esp
80103563:	57                   	push   %edi
80103564:	e8 07 0b 00 00       	call   80104070 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103569:	5a                   	pop    %edx
8010356a:	59                   	pop    %ecx
8010356b:	53                   	push   %ebx
8010356c:	56                   	push   %esi
8010356d:	e8 4e 09 00 00       	call   80103ec0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103572:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103578:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010357e:	83 c4 10             	add    $0x10,%esp
80103581:	05 00 02 00 00       	add    $0x200,%eax
80103586:	39 c2                	cmp    %eax,%edx
80103588:	75 36                	jne    801035c0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010358a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103590:	85 c0                	test   %eax,%eax
80103592:	74 0c                	je     801035a0 <pipewrite+0xa0>
80103594:	e8 67 03 00 00       	call   80103900 <myproc>
80103599:	8b 40 24             	mov    0x24(%eax),%eax
8010359c:	85 c0                	test   %eax,%eax
8010359e:	74 c0                	je     80103560 <pipewrite+0x60>
        release(&p->lock);
801035a0:	83 ec 0c             	sub    $0xc,%esp
801035a3:	53                   	push   %ebx
801035a4:	e8 37 11 00 00       	call   801046e0 <release>
        return -1;
801035a9:	83 c4 10             	add    $0x10,%esp
801035ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801035b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035b4:	5b                   	pop    %ebx
801035b5:	5e                   	pop    %esi
801035b6:	5f                   	pop    %edi
801035b7:	5d                   	pop    %ebp
801035b8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035b9:	89 c2                	mov    %eax,%edx
801035bb:	90                   	nop
801035bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801035c0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801035c3:	8d 42 01             	lea    0x1(%edx),%eax
801035c6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801035cc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801035d2:	0f b6 0e             	movzbl (%esi),%ecx
801035d5:	83 c6 01             	add    $0x1,%esi
801035d8:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801035db:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801035df:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801035e2:	0f 85 50 ff ff ff    	jne    80103538 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801035e8:	83 ec 0c             	sub    $0xc,%esp
801035eb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801035f1:	50                   	push   %eax
801035f2:	e8 79 0a 00 00       	call   80104070 <wakeup>
  release(&p->lock);
801035f7:	89 1c 24             	mov    %ebx,(%esp)
801035fa:	e8 e1 10 00 00       	call   801046e0 <release>
  return n;
801035ff:	83 c4 10             	add    $0x10,%esp
80103602:	8b 45 10             	mov    0x10(%ebp),%eax
80103605:	eb aa                	jmp    801035b1 <pipewrite+0xb1>
80103607:	89 f6                	mov    %esi,%esi
80103609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103610 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	57                   	push   %edi
80103614:	56                   	push   %esi
80103615:	53                   	push   %ebx
80103616:	83 ec 18             	sub    $0x18,%esp
80103619:	8b 75 08             	mov    0x8(%ebp),%esi
8010361c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010361f:	56                   	push   %esi
80103620:	e8 9b 0f 00 00       	call   801045c0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103625:	83 c4 10             	add    $0x10,%esp
80103628:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010362e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103634:	75 6a                	jne    801036a0 <piperead+0x90>
80103636:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010363c:	85 db                	test   %ebx,%ebx
8010363e:	0f 84 c4 00 00 00    	je     80103708 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103644:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010364a:	eb 2d                	jmp    80103679 <piperead+0x69>
8010364c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103650:	83 ec 08             	sub    $0x8,%esp
80103653:	56                   	push   %esi
80103654:	53                   	push   %ebx
80103655:	e8 66 08 00 00       	call   80103ec0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010365a:	83 c4 10             	add    $0x10,%esp
8010365d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103663:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103669:	75 35                	jne    801036a0 <piperead+0x90>
8010366b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103671:	85 d2                	test   %edx,%edx
80103673:	0f 84 8f 00 00 00    	je     80103708 <piperead+0xf8>
    if(myproc()->killed){
80103679:	e8 82 02 00 00       	call   80103900 <myproc>
8010367e:	8b 48 24             	mov    0x24(%eax),%ecx
80103681:	85 c9                	test   %ecx,%ecx
80103683:	74 cb                	je     80103650 <piperead+0x40>
      release(&p->lock);
80103685:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103688:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010368d:	56                   	push   %esi
8010368e:	e8 4d 10 00 00       	call   801046e0 <release>
      return -1;
80103693:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103696:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103699:	89 d8                	mov    %ebx,%eax
8010369b:	5b                   	pop    %ebx
8010369c:	5e                   	pop    %esi
8010369d:	5f                   	pop    %edi
8010369e:	5d                   	pop    %ebp
8010369f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801036a0:	8b 45 10             	mov    0x10(%ebp),%eax
801036a3:	85 c0                	test   %eax,%eax
801036a5:	7e 61                	jle    80103708 <piperead+0xf8>
    if(p->nread == p->nwrite)
801036a7:	31 db                	xor    %ebx,%ebx
801036a9:	eb 13                	jmp    801036be <piperead+0xae>
801036ab:	90                   	nop
801036ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036b0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801036b6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801036bc:	74 1f                	je     801036dd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801036be:	8d 41 01             	lea    0x1(%ecx),%eax
801036c1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801036c7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801036cd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801036d2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801036d5:	83 c3 01             	add    $0x1,%ebx
801036d8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801036db:	75 d3                	jne    801036b0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801036dd:	83 ec 0c             	sub    $0xc,%esp
801036e0:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801036e6:	50                   	push   %eax
801036e7:	e8 84 09 00 00       	call   80104070 <wakeup>
  release(&p->lock);
801036ec:	89 34 24             	mov    %esi,(%esp)
801036ef:	e8 ec 0f 00 00       	call   801046e0 <release>
  return i;
801036f4:	83 c4 10             	add    $0x10,%esp
}
801036f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036fa:	89 d8                	mov    %ebx,%eax
801036fc:	5b                   	pop    %ebx
801036fd:	5e                   	pop    %esi
801036fe:	5f                   	pop    %edi
801036ff:	5d                   	pop    %ebp
80103700:	c3                   	ret    
80103701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
80103708:	31 db                	xor    %ebx,%ebx
8010370a:	eb d1                	jmp    801036dd <piperead+0xcd>
8010370c:	66 90                	xchg   %ax,%ax
8010370e:	66 90                	xchg   %ax,%ax

80103710 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103710:	55                   	push   %ebp
80103711:	89 e5                	mov    %esp,%ebp
80103713:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103714:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103719:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010371c:	68 20 2d 11 80       	push   $0x80112d20
80103721:	e8 9a 0e 00 00       	call   801045c0 <acquire>
80103726:	83 c4 10             	add    $0x10,%esp
80103729:	eb 14                	jmp    8010373f <allocproc+0x2f>
8010372b:	90                   	nop
8010372c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103730:	83 eb 80             	sub    $0xffffff80,%ebx
80103733:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103739:	0f 84 81 00 00 00    	je     801037c0 <allocproc+0xb0>
    if(p->state == UNUSED)
8010373f:	8b 43 0c             	mov    0xc(%ebx),%eax
80103742:	85 c0                	test   %eax,%eax
80103744:	75 ea                	jne    80103730 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103746:	a1 04 a0 10 80       	mov    0x8010a004,%eax
  p->priority = 10;     //default priority

  release(&ptable.lock);
8010374b:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010374e:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->priority = 10;     //default priority
80103755:	c7 43 7c 0a 00 00 00 	movl   $0xa,0x7c(%ebx)
  p->pid = nextpid++;
8010375c:	89 43 10             	mov    %eax,0x10(%ebx)
8010375f:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103762:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
80103767:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
8010376d:	e8 6e 0f 00 00       	call   801046e0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103772:	e8 49 ee ff ff       	call   801025c0 <kalloc>
80103777:	83 c4 10             	add    $0x10,%esp
8010377a:	89 43 08             	mov    %eax,0x8(%ebx)
8010377d:	85 c0                	test   %eax,%eax
8010377f:	74 58                	je     801037d9 <allocproc+0xc9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103781:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103787:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010378a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010378f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103792:	c7 40 14 72 59 10 80 	movl   $0x80105972,0x14(%eax)
  p->context = (struct context*)sp;
80103799:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010379c:	6a 14                	push   $0x14
8010379e:	6a 00                	push   $0x0
801037a0:	50                   	push   %eax
801037a1:	e8 8a 0f 00 00       	call   80104730 <memset>
  p->context->eip = (uint)forkret;
801037a6:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801037a9:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801037ac:	c7 40 10 f0 37 10 80 	movl   $0x801037f0,0x10(%eax)
}
801037b3:	89 d8                	mov    %ebx,%eax
801037b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037b8:	c9                   	leave  
801037b9:	c3                   	ret    
801037ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801037c0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801037c3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801037c5:	68 20 2d 11 80       	push   $0x80112d20
801037ca:	e8 11 0f 00 00       	call   801046e0 <release>
}
801037cf:	89 d8                	mov    %ebx,%eax
  return 0;
801037d1:	83 c4 10             	add    $0x10,%esp
}
801037d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037d7:	c9                   	leave  
801037d8:	c3                   	ret    
    p->state = UNUSED;
801037d9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801037e0:	31 db                	xor    %ebx,%ebx
}
801037e2:	89 d8                	mov    %ebx,%eax
801037e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037e7:	c9                   	leave  
801037e8:	c3                   	ret    
801037e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801037f0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801037f6:	68 20 2d 11 80       	push   $0x80112d20
801037fb:	e8 e0 0e 00 00       	call   801046e0 <release>

  if (first) {
80103800:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103805:	83 c4 10             	add    $0x10,%esp
80103808:	85 c0                	test   %eax,%eax
8010380a:	75 04                	jne    80103810 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010380c:	c9                   	leave  
8010380d:	c3                   	ret    
8010380e:	66 90                	xchg   %ax,%ax
    first = 0;
80103810:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103817:	00 00 00 
    iinit(ROOTDEV);
8010381a:	83 ec 0c             	sub    $0xc,%esp
8010381d:	6a 01                	push   $0x1
8010381f:	e8 0c dd ff ff       	call   80101530 <iinit>
    initlog(ROOTDEV);
80103824:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010382b:	e8 e0 f3 ff ff       	call   80102c10 <initlog>
80103830:	83 c4 10             	add    $0x10,%esp
}
80103833:	c9                   	leave  
80103834:	c3                   	ret    
80103835:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103840 <pinit>:
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103846:	68 15 77 10 80       	push   $0x80107715
8010384b:	68 20 2d 11 80       	push   $0x80112d20
80103850:	e8 6b 0c 00 00       	call   801044c0 <initlock>
}
80103855:	83 c4 10             	add    $0x10,%esp
80103858:	c9                   	leave  
80103859:	c3                   	ret    
8010385a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103860 <mycpu>:
{
80103860:	55                   	push   %ebp
80103861:	89 e5                	mov    %esp,%ebp
80103863:	56                   	push   %esi
80103864:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103865:	9c                   	pushf  
80103866:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103867:	f6 c4 02             	test   $0x2,%ah
8010386a:	75 5d                	jne    801038c9 <mycpu+0x69>
  apicid = lapicid();
8010386c:	e8 cf ef ff ff       	call   80102840 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103871:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
80103877:	85 f6                	test   %esi,%esi
80103879:	7e 41                	jle    801038bc <mycpu+0x5c>
    if (cpus[i].apicid == apicid)
8010387b:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103882:	39 d0                	cmp    %edx,%eax
80103884:	74 2f                	je     801038b5 <mycpu+0x55>
  for (i = 0; i < ncpu; ++i) {
80103886:	31 d2                	xor    %edx,%edx
80103888:	90                   	nop
80103889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103890:	83 c2 01             	add    $0x1,%edx
80103893:	39 f2                	cmp    %esi,%edx
80103895:	74 25                	je     801038bc <mycpu+0x5c>
    if (cpus[i].apicid == apicid)
80103897:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010389d:	0f b6 99 80 27 11 80 	movzbl -0x7feed880(%ecx),%ebx
801038a4:	39 c3                	cmp    %eax,%ebx
801038a6:	75 e8                	jne    80103890 <mycpu+0x30>
801038a8:	8d 81 80 27 11 80    	lea    -0x7feed880(%ecx),%eax
}
801038ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038b1:	5b                   	pop    %ebx
801038b2:	5e                   	pop    %esi
801038b3:	5d                   	pop    %ebp
801038b4:	c3                   	ret    
    if (cpus[i].apicid == apicid)
801038b5:	b8 80 27 11 80       	mov    $0x80112780,%eax
      return &cpus[i];
801038ba:	eb f2                	jmp    801038ae <mycpu+0x4e>
  panic("unknown apicid\n");
801038bc:	83 ec 0c             	sub    $0xc,%esp
801038bf:	68 1c 77 10 80       	push   $0x8010771c
801038c4:	e8 c7 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801038c9:	83 ec 0c             	sub    $0xc,%esp
801038cc:	68 5c 78 10 80       	push   $0x8010785c
801038d1:	e8 ba ca ff ff       	call   80100390 <panic>
801038d6:	8d 76 00             	lea    0x0(%esi),%esi
801038d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038e0 <cpuid>:
cpuid() {
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801038e6:	e8 75 ff ff ff       	call   80103860 <mycpu>
}
801038eb:	c9                   	leave  
  return mycpu()-cpus;
801038ec:	2d 80 27 11 80       	sub    $0x80112780,%eax
801038f1:	c1 f8 04             	sar    $0x4,%eax
801038f4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801038fa:	c3                   	ret    
801038fb:	90                   	nop
801038fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103900 <myproc>:
myproc(void) {
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	53                   	push   %ebx
80103904:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103907:	e8 64 0c 00 00       	call   80104570 <pushcli>
  c = mycpu();
8010390c:	e8 4f ff ff ff       	call   80103860 <mycpu>
  p = c->proc;
80103911:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103917:	e8 64 0d 00 00       	call   80104680 <popcli>
}
8010391c:	83 c4 04             	add    $0x4,%esp
8010391f:	89 d8                	mov    %ebx,%eax
80103921:	5b                   	pop    %ebx
80103922:	5d                   	pop    %ebp
80103923:	c3                   	ret    
80103924:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010392a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103930 <userinit>:
{
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	53                   	push   %ebx
80103934:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103937:	e8 d4 fd ff ff       	call   80103710 <allocproc>
8010393c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010393e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103943:	e8 f8 35 00 00       	call   80106f40 <setupkvm>
80103948:	89 43 04             	mov    %eax,0x4(%ebx)
8010394b:	85 c0                	test   %eax,%eax
8010394d:	0f 84 bd 00 00 00    	je     80103a10 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103953:	83 ec 04             	sub    $0x4,%esp
80103956:	68 2c 00 00 00       	push   $0x2c
8010395b:	68 60 a4 10 80       	push   $0x8010a460
80103960:	50                   	push   %eax
80103961:	e8 ba 32 00 00       	call   80106c20 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103966:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103969:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010396f:	6a 4c                	push   $0x4c
80103971:	6a 00                	push   $0x0
80103973:	ff 73 18             	pushl  0x18(%ebx)
80103976:	e8 b5 0d 00 00       	call   80104730 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010397b:	8b 43 18             	mov    0x18(%ebx),%eax
8010397e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103983:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103986:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010398b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010398f:	8b 43 18             	mov    0x18(%ebx),%eax
80103992:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103996:	8b 43 18             	mov    0x18(%ebx),%eax
80103999:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010399d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801039a1:	8b 43 18             	mov    0x18(%ebx),%eax
801039a4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039a8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801039ac:	8b 43 18             	mov    0x18(%ebx),%eax
801039af:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801039b6:	8b 43 18             	mov    0x18(%ebx),%eax
801039b9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801039c0:	8b 43 18             	mov    0x18(%ebx),%eax
801039c3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039ca:	8d 43 6c             	lea    0x6c(%ebx),%eax
801039cd:	6a 10                	push   $0x10
801039cf:	68 45 77 10 80       	push   $0x80107745
801039d4:	50                   	push   %eax
801039d5:	e8 16 0f 00 00       	call   801048f0 <safestrcpy>
  p->cwd = namei("/");
801039da:	c7 04 24 4e 77 10 80 	movl   $0x8010774e,(%esp)
801039e1:	e8 ea e5 ff ff       	call   80101fd0 <namei>
801039e6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801039e9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039f0:	e8 cb 0b 00 00       	call   801045c0 <acquire>
  p->state = RUNNABLE;
801039f5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801039fc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a03:	e8 d8 0c 00 00       	call   801046e0 <release>
}
80103a08:	83 c4 10             	add    $0x10,%esp
80103a0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a0e:	c9                   	leave  
80103a0f:	c3                   	ret    
    panic("userinit: out of memory?");
80103a10:	83 ec 0c             	sub    $0xc,%esp
80103a13:	68 2c 77 10 80       	push   $0x8010772c
80103a18:	e8 73 c9 ff ff       	call   80100390 <panic>
80103a1d:	8d 76 00             	lea    0x0(%esi),%esi

80103a20 <growproc>:
{
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	56                   	push   %esi
80103a24:	53                   	push   %ebx
80103a25:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103a28:	e8 43 0b 00 00       	call   80104570 <pushcli>
  c = mycpu();
80103a2d:	e8 2e fe ff ff       	call   80103860 <mycpu>
  p = c->proc;
80103a32:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a38:	e8 43 0c 00 00       	call   80104680 <popcli>
  sz = curproc->sz;
80103a3d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103a3f:	85 f6                	test   %esi,%esi
80103a41:	7f 1d                	jg     80103a60 <growproc+0x40>
  } else if(n < 0){
80103a43:	75 3b                	jne    80103a80 <growproc+0x60>
  switchuvm(curproc);
80103a45:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103a48:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103a4a:	53                   	push   %ebx
80103a4b:	e8 c0 30 00 00       	call   80106b10 <switchuvm>
  return 0;
80103a50:	83 c4 10             	add    $0x10,%esp
80103a53:	31 c0                	xor    %eax,%eax
}
80103a55:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a58:	5b                   	pop    %ebx
80103a59:	5e                   	pop    %esi
80103a5a:	5d                   	pop    %ebp
80103a5b:	c3                   	ret    
80103a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a60:	83 ec 04             	sub    $0x4,%esp
80103a63:	01 c6                	add    %eax,%esi
80103a65:	56                   	push   %esi
80103a66:	50                   	push   %eax
80103a67:	ff 73 04             	pushl  0x4(%ebx)
80103a6a:	e8 f1 32 00 00       	call   80106d60 <allocuvm>
80103a6f:	83 c4 10             	add    $0x10,%esp
80103a72:	85 c0                	test   %eax,%eax
80103a74:	75 cf                	jne    80103a45 <growproc+0x25>
      return -1;
80103a76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a7b:	eb d8                	jmp    80103a55 <growproc+0x35>
80103a7d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a80:	83 ec 04             	sub    $0x4,%esp
80103a83:	01 c6                	add    %eax,%esi
80103a85:	56                   	push   %esi
80103a86:	50                   	push   %eax
80103a87:	ff 73 04             	pushl  0x4(%ebx)
80103a8a:	e8 01 34 00 00       	call   80106e90 <deallocuvm>
80103a8f:	83 c4 10             	add    $0x10,%esp
80103a92:	85 c0                	test   %eax,%eax
80103a94:	75 af                	jne    80103a45 <growproc+0x25>
80103a96:	eb de                	jmp    80103a76 <growproc+0x56>
80103a98:	90                   	nop
80103a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103aa0 <fork>:
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	57                   	push   %edi
80103aa4:	56                   	push   %esi
80103aa5:	53                   	push   %ebx
80103aa6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103aa9:	e8 c2 0a 00 00       	call   80104570 <pushcli>
  c = mycpu();
80103aae:	e8 ad fd ff ff       	call   80103860 <mycpu>
  p = c->proc;
80103ab3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ab9:	e8 c2 0b 00 00       	call   80104680 <popcli>
  if((np = allocproc()) == 0){
80103abe:	e8 4d fc ff ff       	call   80103710 <allocproc>
80103ac3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ac6:	85 c0                	test   %eax,%eax
80103ac8:	0f 84 b7 00 00 00    	je     80103b85 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103ace:	83 ec 08             	sub    $0x8,%esp
80103ad1:	ff 33                	pushl  (%ebx)
80103ad3:	89 c7                	mov    %eax,%edi
80103ad5:	ff 73 04             	pushl  0x4(%ebx)
80103ad8:	e8 33 35 00 00       	call   80107010 <copyuvm>
80103add:	83 c4 10             	add    $0x10,%esp
80103ae0:	89 47 04             	mov    %eax,0x4(%edi)
80103ae3:	85 c0                	test   %eax,%eax
80103ae5:	0f 84 a1 00 00 00    	je     80103b8c <fork+0xec>
  np->sz = curproc->sz;
80103aeb:	8b 03                	mov    (%ebx),%eax
80103aed:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103af0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103af2:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103af5:	89 c8                	mov    %ecx,%eax
80103af7:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103afa:	b9 13 00 00 00       	mov    $0x13,%ecx
80103aff:	8b 73 18             	mov    0x18(%ebx),%esi
80103b02:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b04:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b06:	8b 40 18             	mov    0x18(%eax),%eax
80103b09:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103b10:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b14:	85 c0                	test   %eax,%eax
80103b16:	74 13                	je     80103b2b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103b18:	83 ec 0c             	sub    $0xc,%esp
80103b1b:	50                   	push   %eax
80103b1c:	e8 5f d3 ff ff       	call   80100e80 <filedup>
80103b21:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b24:	83 c4 10             	add    $0x10,%esp
80103b27:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103b2b:	83 c6 01             	add    $0x1,%esi
80103b2e:	83 fe 10             	cmp    $0x10,%esi
80103b31:	75 dd                	jne    80103b10 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103b33:	83 ec 0c             	sub    $0xc,%esp
80103b36:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b39:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103b3c:	e8 bf db ff ff       	call   80101700 <idup>
80103b41:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b44:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103b47:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b4a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103b4d:	6a 10                	push   $0x10
80103b4f:	53                   	push   %ebx
80103b50:	50                   	push   %eax
80103b51:	e8 9a 0d 00 00       	call   801048f0 <safestrcpy>
  pid = np->pid;
80103b56:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103b59:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b60:	e8 5b 0a 00 00       	call   801045c0 <acquire>
  np->state = RUNNABLE;
80103b65:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103b6c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b73:	e8 68 0b 00 00       	call   801046e0 <release>
  return pid;
80103b78:	83 c4 10             	add    $0x10,%esp
}
80103b7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b7e:	89 d8                	mov    %ebx,%eax
80103b80:	5b                   	pop    %ebx
80103b81:	5e                   	pop    %esi
80103b82:	5f                   	pop    %edi
80103b83:	5d                   	pop    %ebp
80103b84:	c3                   	ret    
    return -1;
80103b85:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103b8a:	eb ef                	jmp    80103b7b <fork+0xdb>
    kfree(np->kstack);
80103b8c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103b8f:	83 ec 0c             	sub    $0xc,%esp
80103b92:	ff 73 08             	pushl  0x8(%ebx)
80103b95:	e8 66 e8 ff ff       	call   80102400 <kfree>
    np->kstack = 0;
80103b9a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103ba1:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103ba4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103bab:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103bb0:	eb c9                	jmp    80103b7b <fork+0xdb>
80103bb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103bc0 <scheduler>:
{
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	57                   	push   %edi
80103bc4:	56                   	push   %esi
80103bc5:	53                   	push   %ebx
80103bc6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103bc9:	e8 92 fc ff ff       	call   80103860 <mycpu>
  c->proc = 0;
80103bce:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103bd5:	00 00 00 
  struct cpu *c = mycpu();
80103bd8:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
80103bda:	8d 70 04             	lea    0x4(%eax),%esi
80103bdd:	eb 1c                	jmp    80103bfb <scheduler+0x3b>
80103bdf:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103be0:	83 ef 80             	sub    $0xffffff80,%edi
80103be3:	81 ff 54 4d 11 80    	cmp    $0x80114d54,%edi
80103be9:	72 26                	jb     80103c11 <scheduler+0x51>
    release(&ptable.lock);
80103beb:	83 ec 0c             	sub    $0xc,%esp
80103bee:	68 20 2d 11 80       	push   $0x80112d20
80103bf3:	e8 e8 0a 00 00       	call   801046e0 <release>
  for(;;){
80103bf8:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
80103bfb:	fb                   	sti    
    acquire(&ptable.lock);
80103bfc:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bff:	bf 54 2d 11 80       	mov    $0x80112d54,%edi
    acquire(&ptable.lock);
80103c04:	68 20 2d 11 80       	push   $0x80112d20
80103c09:	e8 b2 09 00 00       	call   801045c0 <acquire>
80103c0e:	83 c4 10             	add    $0x10,%esp
      if(p->state != RUNNABLE)
80103c11:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
80103c15:	75 c9                	jne    80103be0 <scheduler+0x20>
      for(p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++){
80103c17:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if(p1->state != RUNNABLE)
80103c20:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103c24:	75 09                	jne    80103c2f <scheduler+0x6f>
        if ( highP->priority > p1->priority )   // larger value, lower priority 
80103c26:	8b 50 7c             	mov    0x7c(%eax),%edx
80103c29:	39 57 7c             	cmp    %edx,0x7c(%edi)
80103c2c:	0f 4f f8             	cmovg  %eax,%edi
      for(p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++){
80103c2f:	83 e8 80             	sub    $0xffffff80,%eax
80103c32:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103c37:	75 e7                	jne    80103c20 <scheduler+0x60>
      switchuvm(p);
80103c39:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103c3c:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
      switchuvm(p);
80103c42:	57                   	push   %edi
80103c43:	e8 c8 2e 00 00       	call   80106b10 <switchuvm>
      p->state = RUNNING;
80103c48:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
      swtch(&(c->scheduler), p->context);
80103c4f:	58                   	pop    %eax
80103c50:	5a                   	pop    %edx
80103c51:	ff 77 1c             	pushl  0x1c(%edi)
80103c54:	56                   	push   %esi
80103c55:	e8 f1 0c 00 00       	call   8010494b <swtch>
      switchkvm();
80103c5a:	e8 a1 2e 00 00       	call   80106b00 <switchkvm>
      c->proc = 0;
80103c5f:	83 c4 10             	add    $0x10,%esp
80103c62:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103c69:	00 00 00 
80103c6c:	e9 6f ff ff ff       	jmp    80103be0 <scheduler+0x20>
80103c71:	eb 0d                	jmp    80103c80 <sched>
80103c73:	90                   	nop
80103c74:	90                   	nop
80103c75:	90                   	nop
80103c76:	90                   	nop
80103c77:	90                   	nop
80103c78:	90                   	nop
80103c79:	90                   	nop
80103c7a:	90                   	nop
80103c7b:	90                   	nop
80103c7c:	90                   	nop
80103c7d:	90                   	nop
80103c7e:	90                   	nop
80103c7f:	90                   	nop

80103c80 <sched>:
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	56                   	push   %esi
80103c84:	53                   	push   %ebx
  pushcli();
80103c85:	e8 e6 08 00 00       	call   80104570 <pushcli>
  c = mycpu();
80103c8a:	e8 d1 fb ff ff       	call   80103860 <mycpu>
  p = c->proc;
80103c8f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c95:	e8 e6 09 00 00       	call   80104680 <popcli>
  if(!holding(&ptable.lock))
80103c9a:	83 ec 0c             	sub    $0xc,%esp
80103c9d:	68 20 2d 11 80       	push   $0x80112d20
80103ca2:	e8 89 08 00 00       	call   80104530 <holding>
80103ca7:	83 c4 10             	add    $0x10,%esp
80103caa:	85 c0                	test   %eax,%eax
80103cac:	74 4f                	je     80103cfd <sched+0x7d>
  if(mycpu()->ncli != 1)
80103cae:	e8 ad fb ff ff       	call   80103860 <mycpu>
80103cb3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103cba:	75 68                	jne    80103d24 <sched+0xa4>
  if(p->state == RUNNING)
80103cbc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103cc0:	74 55                	je     80103d17 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103cc2:	9c                   	pushf  
80103cc3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103cc4:	f6 c4 02             	test   $0x2,%ah
80103cc7:	75 41                	jne    80103d0a <sched+0x8a>
  intena = mycpu()->intena;
80103cc9:	e8 92 fb ff ff       	call   80103860 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103cce:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103cd1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103cd7:	e8 84 fb ff ff       	call   80103860 <mycpu>
80103cdc:	83 ec 08             	sub    $0x8,%esp
80103cdf:	ff 70 04             	pushl  0x4(%eax)
80103ce2:	53                   	push   %ebx
80103ce3:	e8 63 0c 00 00       	call   8010494b <swtch>
  mycpu()->intena = intena;
80103ce8:	e8 73 fb ff ff       	call   80103860 <mycpu>
}
80103ced:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103cf0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103cf6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cf9:	5b                   	pop    %ebx
80103cfa:	5e                   	pop    %esi
80103cfb:	5d                   	pop    %ebp
80103cfc:	c3                   	ret    
    panic("sched ptable.lock");
80103cfd:	83 ec 0c             	sub    $0xc,%esp
80103d00:	68 50 77 10 80       	push   $0x80107750
80103d05:	e8 86 c6 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103d0a:	83 ec 0c             	sub    $0xc,%esp
80103d0d:	68 7c 77 10 80       	push   $0x8010777c
80103d12:	e8 79 c6 ff ff       	call   80100390 <panic>
    panic("sched running");
80103d17:	83 ec 0c             	sub    $0xc,%esp
80103d1a:	68 6e 77 10 80       	push   $0x8010776e
80103d1f:	e8 6c c6 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103d24:	83 ec 0c             	sub    $0xc,%esp
80103d27:	68 62 77 10 80       	push   $0x80107762
80103d2c:	e8 5f c6 ff ff       	call   80100390 <panic>
80103d31:	eb 0d                	jmp    80103d40 <exit>
80103d33:	90                   	nop
80103d34:	90                   	nop
80103d35:	90                   	nop
80103d36:	90                   	nop
80103d37:	90                   	nop
80103d38:	90                   	nop
80103d39:	90                   	nop
80103d3a:	90                   	nop
80103d3b:	90                   	nop
80103d3c:	90                   	nop
80103d3d:	90                   	nop
80103d3e:	90                   	nop
80103d3f:	90                   	nop

80103d40 <exit>:
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	57                   	push   %edi
80103d44:	56                   	push   %esi
80103d45:	53                   	push   %ebx
80103d46:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103d49:	e8 22 08 00 00       	call   80104570 <pushcli>
  c = mycpu();
80103d4e:	e8 0d fb ff ff       	call   80103860 <mycpu>
  p = c->proc;
80103d53:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103d59:	e8 22 09 00 00       	call   80104680 <popcli>
  if(curproc == initproc)
80103d5e:	8d 5e 28             	lea    0x28(%esi),%ebx
80103d61:	8d 7e 68             	lea    0x68(%esi),%edi
80103d64:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103d6a:	0f 84 e7 00 00 00    	je     80103e57 <exit+0x117>
    if(curproc->ofile[fd]){
80103d70:	8b 03                	mov    (%ebx),%eax
80103d72:	85 c0                	test   %eax,%eax
80103d74:	74 12                	je     80103d88 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103d76:	83 ec 0c             	sub    $0xc,%esp
80103d79:	50                   	push   %eax
80103d7a:	e8 51 d1 ff ff       	call   80100ed0 <fileclose>
      curproc->ofile[fd] = 0;
80103d7f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103d85:	83 c4 10             	add    $0x10,%esp
80103d88:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103d8b:	39 fb                	cmp    %edi,%ebx
80103d8d:	75 e1                	jne    80103d70 <exit+0x30>
  begin_op();
80103d8f:	e8 1c ef ff ff       	call   80102cb0 <begin_op>
  iput(curproc->cwd);
80103d94:	83 ec 0c             	sub    $0xc,%esp
80103d97:	ff 76 68             	pushl  0x68(%esi)
80103d9a:	e8 c1 da ff ff       	call   80101860 <iput>
  end_op();
80103d9f:	e8 7c ef ff ff       	call   80102d20 <end_op>
  curproc->cwd = 0;
80103da4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103dab:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103db2:	e8 09 08 00 00       	call   801045c0 <acquire>
  wakeup1(curproc->parent);
80103db7:	8b 56 14             	mov    0x14(%esi),%edx
80103dba:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dbd:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103dc2:	eb 0e                	jmp    80103dd2 <exit+0x92>
80103dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103dc8:	83 e8 80             	sub    $0xffffff80,%eax
80103dcb:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103dd0:	74 1c                	je     80103dee <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103dd2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103dd6:	75 f0                	jne    80103dc8 <exit+0x88>
80103dd8:	3b 50 20             	cmp    0x20(%eax),%edx
80103ddb:	75 eb                	jne    80103dc8 <exit+0x88>
      p->state = RUNNABLE;
80103ddd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103de4:	83 e8 80             	sub    $0xffffff80,%eax
80103de7:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103dec:	75 e4                	jne    80103dd2 <exit+0x92>
      p->parent = initproc;
80103dee:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103df4:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103df9:	eb 10                	jmp    80103e0b <exit+0xcb>
80103dfb:	90                   	nop
80103dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e00:	83 ea 80             	sub    $0xffffff80,%edx
80103e03:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103e09:	74 33                	je     80103e3e <exit+0xfe>
    if(p->parent == curproc){
80103e0b:	39 72 14             	cmp    %esi,0x14(%edx)
80103e0e:	75 f0                	jne    80103e00 <exit+0xc0>
      if(p->state == ZOMBIE)
80103e10:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103e14:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103e17:	75 e7                	jne    80103e00 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e19:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e1e:	eb 0a                	jmp    80103e2a <exit+0xea>
80103e20:	83 e8 80             	sub    $0xffffff80,%eax
80103e23:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103e28:	74 d6                	je     80103e00 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103e2a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e2e:	75 f0                	jne    80103e20 <exit+0xe0>
80103e30:	3b 48 20             	cmp    0x20(%eax),%ecx
80103e33:	75 eb                	jne    80103e20 <exit+0xe0>
      p->state = RUNNABLE;
80103e35:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e3c:	eb e2                	jmp    80103e20 <exit+0xe0>
  curproc->state = ZOMBIE;
80103e3e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103e45:	e8 36 fe ff ff       	call   80103c80 <sched>
  panic("zombie exit");
80103e4a:	83 ec 0c             	sub    $0xc,%esp
80103e4d:	68 9d 77 10 80       	push   $0x8010779d
80103e52:	e8 39 c5 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103e57:	83 ec 0c             	sub    $0xc,%esp
80103e5a:	68 90 77 10 80       	push   $0x80107790
80103e5f:	e8 2c c5 ff ff       	call   80100390 <panic>
80103e64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103e6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103e70 <yield>:
{
80103e70:	55                   	push   %ebp
80103e71:	89 e5                	mov    %esp,%ebp
80103e73:	53                   	push   %ebx
80103e74:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103e77:	68 20 2d 11 80       	push   $0x80112d20
80103e7c:	e8 3f 07 00 00       	call   801045c0 <acquire>
  pushcli();
80103e81:	e8 ea 06 00 00       	call   80104570 <pushcli>
  c = mycpu();
80103e86:	e8 d5 f9 ff ff       	call   80103860 <mycpu>
  p = c->proc;
80103e8b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e91:	e8 ea 07 00 00       	call   80104680 <popcli>
  myproc()->state = RUNNABLE;
80103e96:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103e9d:	e8 de fd ff ff       	call   80103c80 <sched>
  release(&ptable.lock);
80103ea2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ea9:	e8 32 08 00 00       	call   801046e0 <release>
}
80103eae:	83 c4 10             	add    $0x10,%esp
80103eb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103eb4:	c9                   	leave  
80103eb5:	c3                   	ret    
80103eb6:	8d 76 00             	lea    0x0(%esi),%esi
80103eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ec0 <sleep>:
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	57                   	push   %edi
80103ec4:	56                   	push   %esi
80103ec5:	53                   	push   %ebx
80103ec6:	83 ec 0c             	sub    $0xc,%esp
80103ec9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103ecc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103ecf:	e8 9c 06 00 00       	call   80104570 <pushcli>
  c = mycpu();
80103ed4:	e8 87 f9 ff ff       	call   80103860 <mycpu>
  p = c->proc;
80103ed9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103edf:	e8 9c 07 00 00       	call   80104680 <popcli>
  if(p == 0)
80103ee4:	85 db                	test   %ebx,%ebx
80103ee6:	0f 84 87 00 00 00    	je     80103f73 <sleep+0xb3>
  if(lk == 0)
80103eec:	85 f6                	test   %esi,%esi
80103eee:	74 76                	je     80103f66 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103ef0:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103ef6:	74 50                	je     80103f48 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103ef8:	83 ec 0c             	sub    $0xc,%esp
80103efb:	68 20 2d 11 80       	push   $0x80112d20
80103f00:	e8 bb 06 00 00       	call   801045c0 <acquire>
    release(lk);
80103f05:	89 34 24             	mov    %esi,(%esp)
80103f08:	e8 d3 07 00 00       	call   801046e0 <release>
  p->chan = chan;
80103f0d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103f10:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f17:	e8 64 fd ff ff       	call   80103c80 <sched>
  p->chan = 0;
80103f1c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103f23:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f2a:	e8 b1 07 00 00       	call   801046e0 <release>
    acquire(lk);
80103f2f:	89 75 08             	mov    %esi,0x8(%ebp)
80103f32:	83 c4 10             	add    $0x10,%esp
}
80103f35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f38:	5b                   	pop    %ebx
80103f39:	5e                   	pop    %esi
80103f3a:	5f                   	pop    %edi
80103f3b:	5d                   	pop    %ebp
    acquire(lk);
80103f3c:	e9 7f 06 00 00       	jmp    801045c0 <acquire>
80103f41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103f48:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103f4b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f52:	e8 29 fd ff ff       	call   80103c80 <sched>
  p->chan = 0;
80103f57:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103f5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f61:	5b                   	pop    %ebx
80103f62:	5e                   	pop    %esi
80103f63:	5f                   	pop    %edi
80103f64:	5d                   	pop    %ebp
80103f65:	c3                   	ret    
    panic("sleep without lk");
80103f66:	83 ec 0c             	sub    $0xc,%esp
80103f69:	68 af 77 10 80       	push   $0x801077af
80103f6e:	e8 1d c4 ff ff       	call   80100390 <panic>
    panic("sleep");
80103f73:	83 ec 0c             	sub    $0xc,%esp
80103f76:	68 a9 77 10 80       	push   $0x801077a9
80103f7b:	e8 10 c4 ff ff       	call   80100390 <panic>

80103f80 <wait>:
{
80103f80:	55                   	push   %ebp
80103f81:	89 e5                	mov    %esp,%ebp
80103f83:	56                   	push   %esi
80103f84:	53                   	push   %ebx
  pushcli();
80103f85:	e8 e6 05 00 00       	call   80104570 <pushcli>
  c = mycpu();
80103f8a:	e8 d1 f8 ff ff       	call   80103860 <mycpu>
  p = c->proc;
80103f8f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f95:	e8 e6 06 00 00       	call   80104680 <popcli>
  acquire(&ptable.lock);
80103f9a:	83 ec 0c             	sub    $0xc,%esp
80103f9d:	68 20 2d 11 80       	push   $0x80112d20
80103fa2:	e8 19 06 00 00       	call   801045c0 <acquire>
80103fa7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103faa:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fac:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103fb1:	eb 10                	jmp    80103fc3 <wait+0x43>
80103fb3:	90                   	nop
80103fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fb8:	83 eb 80             	sub    $0xffffff80,%ebx
80103fbb:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103fc1:	74 1b                	je     80103fde <wait+0x5e>
      if(p->parent != curproc)
80103fc3:	39 73 14             	cmp    %esi,0x14(%ebx)
80103fc6:	75 f0                	jne    80103fb8 <wait+0x38>
      if(p->state == ZOMBIE){
80103fc8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103fcc:	74 32                	je     80104000 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fce:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80103fd1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fd6:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103fdc:	75 e5                	jne    80103fc3 <wait+0x43>
    if(!havekids || curproc->killed){
80103fde:	85 c0                	test   %eax,%eax
80103fe0:	74 74                	je     80104056 <wait+0xd6>
80103fe2:	8b 46 24             	mov    0x24(%esi),%eax
80103fe5:	85 c0                	test   %eax,%eax
80103fe7:	75 6d                	jne    80104056 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103fe9:	83 ec 08             	sub    $0x8,%esp
80103fec:	68 20 2d 11 80       	push   $0x80112d20
80103ff1:	56                   	push   %esi
80103ff2:	e8 c9 fe ff ff       	call   80103ec0 <sleep>
    havekids = 0;
80103ff7:	83 c4 10             	add    $0x10,%esp
80103ffa:	eb ae                	jmp    80103faa <wait+0x2a>
80103ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104000:	83 ec 0c             	sub    $0xc,%esp
80104003:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104006:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104009:	e8 f2 e3 ff ff       	call   80102400 <kfree>
        freevm(p->pgdir);
8010400e:	5a                   	pop    %edx
8010400f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104012:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104019:	e8 a2 2e 00 00       	call   80106ec0 <freevm>
        release(&ptable.lock);
8010401e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80104025:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010402c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104033:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104037:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010403e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104045:	e8 96 06 00 00       	call   801046e0 <release>
        return pid;
8010404a:	83 c4 10             	add    $0x10,%esp
}
8010404d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104050:	89 f0                	mov    %esi,%eax
80104052:	5b                   	pop    %ebx
80104053:	5e                   	pop    %esi
80104054:	5d                   	pop    %ebp
80104055:	c3                   	ret    
      release(&ptable.lock);
80104056:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104059:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010405e:	68 20 2d 11 80       	push   $0x80112d20
80104063:	e8 78 06 00 00       	call   801046e0 <release>
      return -1;
80104068:	83 c4 10             	add    $0x10,%esp
8010406b:	eb e0                	jmp    8010404d <wait+0xcd>
8010406d:	8d 76 00             	lea    0x0(%esi),%esi

80104070 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	53                   	push   %ebx
80104074:	83 ec 10             	sub    $0x10,%esp
80104077:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010407a:	68 20 2d 11 80       	push   $0x80112d20
8010407f:	e8 3c 05 00 00       	call   801045c0 <acquire>
80104084:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104087:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010408c:	eb 0c                	jmp    8010409a <wakeup+0x2a>
8010408e:	66 90                	xchg   %ax,%ax
80104090:	83 e8 80             	sub    $0xffffff80,%eax
80104093:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80104098:	74 1c                	je     801040b6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010409a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010409e:	75 f0                	jne    80104090 <wakeup+0x20>
801040a0:	3b 58 20             	cmp    0x20(%eax),%ebx
801040a3:	75 eb                	jne    80104090 <wakeup+0x20>
      p->state = RUNNABLE;
801040a5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040ac:	83 e8 80             	sub    $0xffffff80,%eax
801040af:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
801040b4:	75 e4                	jne    8010409a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801040b6:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
801040bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040c0:	c9                   	leave  
  release(&ptable.lock);
801040c1:	e9 1a 06 00 00       	jmp    801046e0 <release>
801040c6:	8d 76 00             	lea    0x0(%esi),%esi
801040c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801040d0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	53                   	push   %ebx
801040d4:	83 ec 10             	sub    $0x10,%esp
801040d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801040da:	68 20 2d 11 80       	push   $0x80112d20
801040df:	e8 dc 04 00 00       	call   801045c0 <acquire>
801040e4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040e7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801040ec:	eb 0c                	jmp    801040fa <kill+0x2a>
801040ee:	66 90                	xchg   %ax,%ax
801040f0:	83 e8 80             	sub    $0xffffff80,%eax
801040f3:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
801040f8:	74 36                	je     80104130 <kill+0x60>
    if(p->pid == pid){
801040fa:	39 58 10             	cmp    %ebx,0x10(%eax)
801040fd:	75 f1                	jne    801040f0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801040ff:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104103:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010410a:	75 07                	jne    80104113 <kill+0x43>
        p->state = RUNNABLE;
8010410c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104113:	83 ec 0c             	sub    $0xc,%esp
80104116:	68 20 2d 11 80       	push   $0x80112d20
8010411b:	e8 c0 05 00 00       	call   801046e0 <release>
      return 0;
80104120:	83 c4 10             	add    $0x10,%esp
80104123:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104125:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104128:	c9                   	leave  
80104129:	c3                   	ret    
8010412a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104130:	83 ec 0c             	sub    $0xc,%esp
80104133:	68 20 2d 11 80       	push   $0x80112d20
80104138:	e8 a3 05 00 00       	call   801046e0 <release>
  return -1;
8010413d:	83 c4 10             	add    $0x10,%esp
80104140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104145:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104148:	c9                   	leave  
80104149:	c3                   	ret    
8010414a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104150 <cps>:

//current process status
int
cps()
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	53                   	push   %ebx
80104154:	83 ec 10             	sub    $0x10,%esp
  asm volatile("sti");
80104157:	fb                   	sti    
  
  // Enable interrupts on this processor.
  sti();

  // Loop over process table looking for process with pid.
  acquire(&ptable.lock);
80104158:	68 20 2d 11 80       	push   $0x80112d20
  cprintf("name \t pid \t state \t priority \n");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010415d:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  acquire(&ptable.lock);
80104162:	e8 59 04 00 00       	call   801045c0 <acquire>
  cprintf("name \t pid \t state \t priority \n");
80104167:	c7 04 24 84 78 10 80 	movl   $0x80107884,(%esp)
8010416e:	e8 3d c5 ff ff       	call   801006b0 <cprintf>
80104173:	83 c4 10             	add    $0x10,%esp
80104176:	eb 1d                	jmp    80104195 <cps+0x45>
80104178:	90                   	nop
80104179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if ( p->state == SLEEPING )
        cprintf("%s \t %d  \t SLEEPING \t %d\n ", p->name, p->pid, p->priority );
      else if ( p->state == RUNNING )
80104180:	83 f8 04             	cmp    $0x4,%eax
80104183:	74 5b                	je     801041e0 <cps+0x90>
        cprintf("%s \t %d  \t RUNNING \t %d\n ", p->name, p->pid, p->priority );
      else if (p->state == RUNNABLE)
80104185:	83 f8 03             	cmp    $0x3,%eax
80104188:	74 76                	je     80104200 <cps+0xb0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010418a:	83 eb 80             	sub    $0xffffff80,%ebx
8010418d:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80104193:	74 2a                	je     801041bf <cps+0x6f>
      if ( p->state == SLEEPING )
80104195:	8b 43 0c             	mov    0xc(%ebx),%eax
80104198:	83 f8 02             	cmp    $0x2,%eax
8010419b:	75 e3                	jne    80104180 <cps+0x30>
        cprintf("%s \t %d  \t SLEEPING \t %d\n ", p->name, p->pid, p->priority );
8010419d:	8d 43 6c             	lea    0x6c(%ebx),%eax
801041a0:	ff 73 7c             	pushl  0x7c(%ebx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041a3:	83 eb 80             	sub    $0xffffff80,%ebx
        cprintf("%s \t %d  \t SLEEPING \t %d\n ", p->name, p->pid, p->priority );
801041a6:	ff 73 90             	pushl  -0x70(%ebx)
801041a9:	50                   	push   %eax
801041aa:	68 c0 77 10 80       	push   $0x801077c0
801041af:	e8 fc c4 ff ff       	call   801006b0 <cprintf>
801041b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041b7:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801041bd:	75 d6                	jne    80104195 <cps+0x45>
       cprintf("%s \t %d  \t RUNNABLE \t %d\n ", p->name, p->pid, p->priority );  
  }
  
  release(&ptable.lock);
801041bf:	83 ec 0c             	sub    $0xc,%esp
801041c2:	68 20 2d 11 80       	push   $0x80112d20
801041c7:	e8 14 05 00 00       	call   801046e0 <release>
  
  return 22;
}
801041cc:	b8 16 00 00 00       	mov    $0x16,%eax
801041d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041d4:	c9                   	leave  
801041d5:	c3                   	ret    
801041d6:	8d 76 00             	lea    0x0(%esi),%esi
801041d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        cprintf("%s \t %d  \t RUNNING \t %d\n ", p->name, p->pid, p->priority );
801041e0:	8d 43 6c             	lea    0x6c(%ebx),%eax
801041e3:	ff 73 7c             	pushl  0x7c(%ebx)
801041e6:	ff 73 10             	pushl  0x10(%ebx)
801041e9:	50                   	push   %eax
801041ea:	68 db 77 10 80       	push   $0x801077db
801041ef:	e8 bc c4 ff ff       	call   801006b0 <cprintf>
801041f4:	83 c4 10             	add    $0x10,%esp
801041f7:	eb 91                	jmp    8010418a <cps+0x3a>
801041f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
       cprintf("%s \t %d  \t RUNNABLE \t %d\n ", p->name, p->pid, p->priority );  
80104200:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104203:	ff 73 7c             	pushl  0x7c(%ebx)
80104206:	ff 73 10             	pushl  0x10(%ebx)
80104209:	50                   	push   %eax
8010420a:	68 f5 77 10 80       	push   $0x801077f5
8010420f:	e8 9c c4 ff ff       	call   801006b0 <cprintf>
80104214:	83 c4 10             	add    $0x10,%esp
80104217:	e9 6e ff ff ff       	jmp    8010418a <cps+0x3a>
8010421c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104220 <nps>:

int
nps()
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	53                   	push   %ebx
80104224:	83 ec 10             	sub    $0x10,%esp
80104227:	fb                   	sti    
  
  // Enable interrupts on this processor.
  sti();

  // Loop over process table looking for process with pid.
  acquire(&ptable.lock);
80104228:	68 20 2d 11 80       	push   $0x80112d20
  int s=0;
8010422d:	31 db                	xor    %ebx,%ebx
  acquire(&ptable.lock);
8010422f:	e8 8c 03 00 00       	call   801045c0 <acquire>
  cprintf("name \t pid \t state \n");
80104234:	c7 04 24 10 78 10 80 	movl   $0x80107810,(%esp)
8010423b:	e8 70 c4 ff ff       	call   801006b0 <cprintf>
80104240:	83 c4 10             	add    $0x10,%esp
  int r=0;
80104243:	31 c9                	xor    %ecx,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104245:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010424a:	eb 19                	jmp    80104265 <nps+0x45>
8010424c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if ( p->state == SLEEPING )
       s++;
      else if ( p->state == RUNNING )
       r++;
80104250:	83 fa 04             	cmp    $0x4,%edx
80104253:	0f 94 c2             	sete   %dl
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104256:	83 e8 80             	sub    $0xffffff80,%eax
       r++;
80104259:	0f b6 d2             	movzbl %dl,%edx
8010425c:	01 d1                	add    %edx,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010425e:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80104263:	74 15                	je     8010427a <nps+0x5a>
      if ( p->state == SLEEPING )
80104265:	8b 50 0c             	mov    0xc(%eax),%edx
80104268:	83 fa 02             	cmp    $0x2,%edx
8010426b:	75 e3                	jne    80104250 <nps+0x30>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010426d:	83 e8 80             	sub    $0xffffff80,%eax
       s++;
80104270:	83 c3 01             	add    $0x1,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104273:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80104278:	75 eb                	jne    80104265 <nps+0x45>
     
  }

  cprintf("number of sleeping and running processes %d \n", s+r);
8010427a:	83 ec 08             	sub    $0x8,%esp
8010427d:	01 d9                	add    %ebx,%ecx
8010427f:	51                   	push   %ecx
80104280:	68 a4 78 10 80       	push   $0x801078a4
80104285:	e8 26 c4 ff ff       	call   801006b0 <cprintf>
  
  release(&ptable.lock);
8010428a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104291:	e8 4a 04 00 00       	call   801046e0 <release>
  
  return 23;
}
80104296:	b8 17 00 00 00       	mov    $0x17,%eax
8010429b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010429e:	c9                   	leave  
8010429f:	c3                   	ret    

801042a0 <chpr>:

//change priority
int
chpr( int pid, int priority )
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	53                   	push   %ebx
801042a4:	83 ec 10             	sub    $0x10,%esp
801042a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;
  
  acquire(&ptable.lock);
801042aa:	68 20 2d 11 80       	push   $0x80112d20
801042af:	e8 0c 03 00 00       	call   801045c0 <acquire>
801042b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042b7:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
801042bc:	eb 0d                	jmp    801042cb <chpr+0x2b>
801042be:	66 90                	xchg   %ax,%ax
801042c0:	83 ea 80             	sub    $0xffffff80,%edx
801042c3:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
801042c9:	74 0b                	je     801042d6 <chpr+0x36>
    if(p->pid == pid ) {
801042cb:	39 5a 10             	cmp    %ebx,0x10(%edx)
801042ce:	75 f0                	jne    801042c0 <chpr+0x20>
        p->priority = priority;
801042d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801042d3:	89 42 7c             	mov    %eax,0x7c(%edx)
        break;
    }
  }
  release(&ptable.lock);
801042d6:	83 ec 0c             	sub    $0xc,%esp
801042d9:	68 20 2d 11 80       	push   $0x80112d20
801042de:	e8 fd 03 00 00       	call   801046e0 <release>
  return pid;
}
801042e3:	89 d8                	mov    %ebx,%eax
801042e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042e8:	c9                   	leave  
801042e9:	c3                   	ret    
801042ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042f0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	57                   	push   %edi
801042f4:	56                   	push   %esi
801042f5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801042f8:	53                   	push   %ebx
801042f9:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
801042fe:	83 ec 3c             	sub    $0x3c,%esp
80104301:	eb 24                	jmp    80104327 <procdump+0x37>
80104303:	90                   	nop
80104304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104308:	83 ec 0c             	sub    $0xc,%esp
8010430b:	68 23 78 10 80       	push   $0x80107823
80104310:	e8 9b c3 ff ff       	call   801006b0 <cprintf>
80104315:	83 c4 10             	add    $0x10,%esp
80104318:	83 eb 80             	sub    $0xffffff80,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010431b:	81 fb c0 4d 11 80    	cmp    $0x80114dc0,%ebx
80104321:	0f 84 81 00 00 00    	je     801043a8 <procdump+0xb8>
    if(p->state == UNUSED)
80104327:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010432a:	85 c0                	test   %eax,%eax
8010432c:	74 ea                	je     80104318 <procdump+0x28>
      state = "???";
8010432e:	ba 25 78 10 80       	mov    $0x80107825,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104333:	83 f8 05             	cmp    $0x5,%eax
80104336:	77 11                	ja     80104349 <procdump+0x59>
80104338:	8b 14 85 d4 78 10 80 	mov    -0x7fef872c(,%eax,4),%edx
      state = "???";
8010433f:	b8 25 78 10 80       	mov    $0x80107825,%eax
80104344:	85 d2                	test   %edx,%edx
80104346:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104349:	53                   	push   %ebx
8010434a:	52                   	push   %edx
8010434b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010434e:	68 29 78 10 80       	push   $0x80107829
80104353:	e8 58 c3 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104358:	83 c4 10             	add    $0x10,%esp
8010435b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010435f:	75 a7                	jne    80104308 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104361:	83 ec 08             	sub    $0x8,%esp
80104364:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104367:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010436a:	50                   	push   %eax
8010436b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010436e:	8b 40 0c             	mov    0xc(%eax),%eax
80104371:	83 c0 08             	add    $0x8,%eax
80104374:	50                   	push   %eax
80104375:	e8 66 01 00 00       	call   801044e0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010437a:	83 c4 10             	add    $0x10,%esp
8010437d:	8d 76 00             	lea    0x0(%esi),%esi
80104380:	8b 17                	mov    (%edi),%edx
80104382:	85 d2                	test   %edx,%edx
80104384:	74 82                	je     80104308 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104386:	83 ec 08             	sub    $0x8,%esp
80104389:	83 c7 04             	add    $0x4,%edi
8010438c:	52                   	push   %edx
8010438d:	68 01 72 10 80       	push   $0x80107201
80104392:	e8 19 c3 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104397:	83 c4 10             	add    $0x10,%esp
8010439a:	39 fe                	cmp    %edi,%esi
8010439c:	75 e2                	jne    80104380 <procdump+0x90>
8010439e:	e9 65 ff ff ff       	jmp    80104308 <procdump+0x18>
801043a3:	90                   	nop
801043a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
801043a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043ab:	5b                   	pop    %ebx
801043ac:	5e                   	pop    %esi
801043ad:	5f                   	pop    %edi
801043ae:	5d                   	pop    %ebp
801043af:	c3                   	ret    

801043b0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	53                   	push   %ebx
801043b4:	83 ec 0c             	sub    $0xc,%esp
801043b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801043ba:	68 ec 78 10 80       	push   $0x801078ec
801043bf:	8d 43 04             	lea    0x4(%ebx),%eax
801043c2:	50                   	push   %eax
801043c3:	e8 f8 00 00 00       	call   801044c0 <initlock>
  lk->name = name;
801043c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801043cb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801043d1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801043d4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801043db:	89 43 38             	mov    %eax,0x38(%ebx)
}
801043de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043e1:	c9                   	leave  
801043e2:	c3                   	ret    
801043e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801043e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043f0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	56                   	push   %esi
801043f4:	53                   	push   %ebx
801043f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801043f8:	8d 73 04             	lea    0x4(%ebx),%esi
801043fb:	83 ec 0c             	sub    $0xc,%esp
801043fe:	56                   	push   %esi
801043ff:	e8 bc 01 00 00       	call   801045c0 <acquire>
  while (lk->locked) {
80104404:	8b 13                	mov    (%ebx),%edx
80104406:	83 c4 10             	add    $0x10,%esp
80104409:	85 d2                	test   %edx,%edx
8010440b:	74 16                	je     80104423 <acquiresleep+0x33>
8010440d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104410:	83 ec 08             	sub    $0x8,%esp
80104413:	56                   	push   %esi
80104414:	53                   	push   %ebx
80104415:	e8 a6 fa ff ff       	call   80103ec0 <sleep>
  while (lk->locked) {
8010441a:	8b 03                	mov    (%ebx),%eax
8010441c:	83 c4 10             	add    $0x10,%esp
8010441f:	85 c0                	test   %eax,%eax
80104421:	75 ed                	jne    80104410 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104423:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104429:	e8 d2 f4 ff ff       	call   80103900 <myproc>
8010442e:	8b 40 10             	mov    0x10(%eax),%eax
80104431:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104434:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104437:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010443a:	5b                   	pop    %ebx
8010443b:	5e                   	pop    %esi
8010443c:	5d                   	pop    %ebp
  release(&lk->lk);
8010443d:	e9 9e 02 00 00       	jmp    801046e0 <release>
80104442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104450 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	56                   	push   %esi
80104454:	53                   	push   %ebx
80104455:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104458:	8d 73 04             	lea    0x4(%ebx),%esi
8010445b:	83 ec 0c             	sub    $0xc,%esp
8010445e:	56                   	push   %esi
8010445f:	e8 5c 01 00 00       	call   801045c0 <acquire>
  lk->locked = 0;
80104464:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010446a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104471:	89 1c 24             	mov    %ebx,(%esp)
80104474:	e8 f7 fb ff ff       	call   80104070 <wakeup>
  release(&lk->lk);
80104479:	89 75 08             	mov    %esi,0x8(%ebp)
8010447c:	83 c4 10             	add    $0x10,%esp
}
8010447f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104482:	5b                   	pop    %ebx
80104483:	5e                   	pop    %esi
80104484:	5d                   	pop    %ebp
  release(&lk->lk);
80104485:	e9 56 02 00 00       	jmp    801046e0 <release>
8010448a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104490 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	56                   	push   %esi
80104494:	53                   	push   %ebx
80104495:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104498:	8d 5e 04             	lea    0x4(%esi),%ebx
8010449b:	83 ec 0c             	sub    $0xc,%esp
8010449e:	53                   	push   %ebx
8010449f:	e8 1c 01 00 00       	call   801045c0 <acquire>
  r = lk->locked;
801044a4:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
801044a6:	89 1c 24             	mov    %ebx,(%esp)
801044a9:	e8 32 02 00 00       	call   801046e0 <release>
  return r;
}
801044ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044b1:	89 f0                	mov    %esi,%eax
801044b3:	5b                   	pop    %ebx
801044b4:	5e                   	pop    %esi
801044b5:	5d                   	pop    %ebp
801044b6:	c3                   	ret    
801044b7:	66 90                	xchg   %ax,%ax
801044b9:	66 90                	xchg   %ax,%ax
801044bb:	66 90                	xchg   %ax,%ax
801044bd:	66 90                	xchg   %ax,%ax
801044bf:	90                   	nop

801044c0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801044c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801044c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801044cf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801044d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801044d9:	5d                   	pop    %ebp
801044da:	c3                   	ret    
801044db:	90                   	nop
801044dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044e0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801044e0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801044e1:	31 d2                	xor    %edx,%edx
{
801044e3:	89 e5                	mov    %esp,%ebp
801044e5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801044e6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801044e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801044ec:	83 e8 08             	sub    $0x8,%eax
801044ef:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801044f0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801044f6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801044fc:	77 1a                	ja     80104518 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801044fe:	8b 58 04             	mov    0x4(%eax),%ebx
80104501:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104504:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104507:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104509:	83 fa 0a             	cmp    $0xa,%edx
8010450c:	75 e2                	jne    801044f0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010450e:	5b                   	pop    %ebx
8010450f:	5d                   	pop    %ebp
80104510:	c3                   	ret    
80104511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104518:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010451b:	8d 51 28             	lea    0x28(%ecx),%edx
8010451e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104520:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104526:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104529:	39 c2                	cmp    %eax,%edx
8010452b:	75 f3                	jne    80104520 <getcallerpcs+0x40>
}
8010452d:	5b                   	pop    %ebx
8010452e:	5d                   	pop    %ebp
8010452f:	c3                   	ret    

80104530 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	53                   	push   %ebx
80104534:	83 ec 04             	sub    $0x4,%esp
80104537:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010453a:	8b 02                	mov    (%edx),%eax
8010453c:	85 c0                	test   %eax,%eax
8010453e:	75 10                	jne    80104550 <holding+0x20>
}
80104540:	83 c4 04             	add    $0x4,%esp
80104543:	31 c0                	xor    %eax,%eax
80104545:	5b                   	pop    %ebx
80104546:	5d                   	pop    %ebp
80104547:	c3                   	ret    
80104548:	90                   	nop
80104549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104550:	8b 5a 08             	mov    0x8(%edx),%ebx
80104553:	e8 08 f3 ff ff       	call   80103860 <mycpu>
80104558:	39 c3                	cmp    %eax,%ebx
8010455a:	0f 94 c0             	sete   %al
}
8010455d:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104560:	0f b6 c0             	movzbl %al,%eax
}
80104563:	5b                   	pop    %ebx
80104564:	5d                   	pop    %ebp
80104565:	c3                   	ret    
80104566:	8d 76 00             	lea    0x0(%esi),%esi
80104569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104570 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	53                   	push   %ebx
80104574:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104577:	9c                   	pushf  
80104578:	5b                   	pop    %ebx
  asm volatile("cli");
80104579:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010457a:	e8 e1 f2 ff ff       	call   80103860 <mycpu>
8010457f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104585:	85 c0                	test   %eax,%eax
80104587:	74 17                	je     801045a0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104589:	e8 d2 f2 ff ff       	call   80103860 <mycpu>
8010458e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104595:	83 c4 04             	add    $0x4,%esp
80104598:	5b                   	pop    %ebx
80104599:	5d                   	pop    %ebp
8010459a:	c3                   	ret    
8010459b:	90                   	nop
8010459c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    mycpu()->intena = eflags & FL_IF;
801045a0:	e8 bb f2 ff ff       	call   80103860 <mycpu>
801045a5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801045ab:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801045b1:	eb d6                	jmp    80104589 <pushcli+0x19>
801045b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045c0 <acquire>:
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	56                   	push   %esi
801045c4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801045c5:	e8 a6 ff ff ff       	call   80104570 <pushcli>
  if(holding(lk))
801045ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801045cd:	8b 03                	mov    (%ebx),%eax
801045cf:	85 c0                	test   %eax,%eax
801045d1:	0f 85 81 00 00 00    	jne    80104658 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
801045d7:	ba 01 00 00 00       	mov    $0x1,%edx
801045dc:	eb 05                	jmp    801045e3 <acquire+0x23>
801045de:	66 90                	xchg   %ax,%ax
801045e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801045e3:	89 d0                	mov    %edx,%eax
801045e5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801045e8:	85 c0                	test   %eax,%eax
801045ea:	75 f4                	jne    801045e0 <acquire+0x20>
  __sync_synchronize();
801045ec:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801045f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801045f4:	e8 67 f2 ff ff       	call   80103860 <mycpu>
  ebp = (uint*)v - 2;
801045f9:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
801045fb:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
801045fe:	31 c0                	xor    %eax,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104600:	8d 8a 00 00 00 80    	lea    -0x80000000(%edx),%ecx
80104606:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
8010460c:	77 22                	ja     80104630 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
8010460e:	8b 4a 04             	mov    0x4(%edx),%ecx
80104611:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
  for(i = 0; i < 10; i++){
80104615:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104618:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010461a:	83 f8 0a             	cmp    $0xa,%eax
8010461d:	75 e1                	jne    80104600 <acquire+0x40>
}
8010461f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104622:	5b                   	pop    %ebx
80104623:	5e                   	pop    %esi
80104624:	5d                   	pop    %ebp
80104625:	c3                   	ret    
80104626:	8d 76 00             	lea    0x0(%esi),%esi
80104629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104630:	8d 44 83 0c          	lea    0xc(%ebx,%eax,4),%eax
80104634:	83 c3 34             	add    $0x34,%ebx
80104637:	89 f6                	mov    %esi,%esi
80104639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104640:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104646:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104649:	39 c3                	cmp    %eax,%ebx
8010464b:	75 f3                	jne    80104640 <acquire+0x80>
}
8010464d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104650:	5b                   	pop    %ebx
80104651:	5e                   	pop    %esi
80104652:	5d                   	pop    %ebp
80104653:	c3                   	ret    
80104654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104658:	8b 73 08             	mov    0x8(%ebx),%esi
8010465b:	e8 00 f2 ff ff       	call   80103860 <mycpu>
80104660:	39 c6                	cmp    %eax,%esi
80104662:	0f 85 6f ff ff ff    	jne    801045d7 <acquire+0x17>
    panic("acquire");
80104668:	83 ec 0c             	sub    $0xc,%esp
8010466b:	68 f7 78 10 80       	push   $0x801078f7
80104670:	e8 1b bd ff ff       	call   80100390 <panic>
80104675:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104680 <popcli>:

void
popcli(void)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104686:	9c                   	pushf  
80104687:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104688:	f6 c4 02             	test   $0x2,%ah
8010468b:	75 35                	jne    801046c2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010468d:	e8 ce f1 ff ff       	call   80103860 <mycpu>
80104692:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104699:	78 34                	js     801046cf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010469b:	e8 c0 f1 ff ff       	call   80103860 <mycpu>
801046a0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801046a6:	85 d2                	test   %edx,%edx
801046a8:	74 06                	je     801046b0 <popcli+0x30>
    sti();
}
801046aa:	c9                   	leave  
801046ab:	c3                   	ret    
801046ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801046b0:	e8 ab f1 ff ff       	call   80103860 <mycpu>
801046b5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801046bb:	85 c0                	test   %eax,%eax
801046bd:	74 eb                	je     801046aa <popcli+0x2a>
  asm volatile("sti");
801046bf:	fb                   	sti    
}
801046c0:	c9                   	leave  
801046c1:	c3                   	ret    
    panic("popcli - interruptible");
801046c2:	83 ec 0c             	sub    $0xc,%esp
801046c5:	68 ff 78 10 80       	push   $0x801078ff
801046ca:	e8 c1 bc ff ff       	call   80100390 <panic>
    panic("popcli");
801046cf:	83 ec 0c             	sub    $0xc,%esp
801046d2:	68 16 79 10 80       	push   $0x80107916
801046d7:	e8 b4 bc ff ff       	call   80100390 <panic>
801046dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046e0 <release>:
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	56                   	push   %esi
801046e4:	53                   	push   %ebx
801046e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801046e8:	8b 03                	mov    (%ebx),%eax
801046ea:	85 c0                	test   %eax,%eax
801046ec:	75 12                	jne    80104700 <release+0x20>
    panic("release");
801046ee:	83 ec 0c             	sub    $0xc,%esp
801046f1:	68 1d 79 10 80       	push   $0x8010791d
801046f6:	e8 95 bc ff ff       	call   80100390 <panic>
801046fb:	90                   	nop
801046fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104700:	8b 73 08             	mov    0x8(%ebx),%esi
80104703:	e8 58 f1 ff ff       	call   80103860 <mycpu>
80104708:	39 c6                	cmp    %eax,%esi
8010470a:	75 e2                	jne    801046ee <release+0xe>
  lk->pcs[0] = 0;
8010470c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104713:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
8010471a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010471f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104725:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104728:	5b                   	pop    %ebx
80104729:	5e                   	pop    %esi
8010472a:	5d                   	pop    %ebp
  popcli();
8010472b:	e9 50 ff ff ff       	jmp    80104680 <popcli>

80104730 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	57                   	push   %edi
80104734:	8b 55 08             	mov    0x8(%ebp),%edx
80104737:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010473a:	53                   	push   %ebx
8010473b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010473e:	89 d7                	mov    %edx,%edi
80104740:	09 cf                	or     %ecx,%edi
80104742:	83 e7 03             	and    $0x3,%edi
80104745:	75 29                	jne    80104770 <memset+0x40>
    c &= 0xFF;
80104747:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010474a:	c1 e0 18             	shl    $0x18,%eax
8010474d:	89 fb                	mov    %edi,%ebx
8010474f:	c1 e9 02             	shr    $0x2,%ecx
80104752:	c1 e3 10             	shl    $0x10,%ebx
80104755:	09 d8                	or     %ebx,%eax
80104757:	09 f8                	or     %edi,%eax
80104759:	c1 e7 08             	shl    $0x8,%edi
8010475c:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
8010475e:	89 d7                	mov    %edx,%edi
80104760:	fc                   	cld    
80104761:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104763:	5b                   	pop    %ebx
80104764:	89 d0                	mov    %edx,%eax
80104766:	5f                   	pop    %edi
80104767:	5d                   	pop    %ebp
80104768:	c3                   	ret    
80104769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104770:	89 d7                	mov    %edx,%edi
80104772:	fc                   	cld    
80104773:	f3 aa                	rep stos %al,%es:(%edi)
80104775:	5b                   	pop    %ebx
80104776:	89 d0                	mov    %edx,%eax
80104778:	5f                   	pop    %edi
80104779:	5d                   	pop    %ebp
8010477a:	c3                   	ret    
8010477b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010477f:	90                   	nop

80104780 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	56                   	push   %esi
80104784:	8b 75 10             	mov    0x10(%ebp),%esi
80104787:	8b 55 08             	mov    0x8(%ebp),%edx
8010478a:	53                   	push   %ebx
8010478b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010478e:	85 f6                	test   %esi,%esi
80104790:	74 2e                	je     801047c0 <memcmp+0x40>
80104792:	01 c6                	add    %eax,%esi
80104794:	eb 14                	jmp    801047aa <memcmp+0x2a>
80104796:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010479d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801047a0:	83 c0 01             	add    $0x1,%eax
801047a3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801047a6:	39 f0                	cmp    %esi,%eax
801047a8:	74 16                	je     801047c0 <memcmp+0x40>
    if(*s1 != *s2)
801047aa:	0f b6 0a             	movzbl (%edx),%ecx
801047ad:	0f b6 18             	movzbl (%eax),%ebx
801047b0:	38 d9                	cmp    %bl,%cl
801047b2:	74 ec                	je     801047a0 <memcmp+0x20>
      return *s1 - *s2;
801047b4:	0f b6 c1             	movzbl %cl,%eax
801047b7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801047b9:	5b                   	pop    %ebx
801047ba:	5e                   	pop    %esi
801047bb:	5d                   	pop    %ebp
801047bc:	c3                   	ret    
801047bd:	8d 76 00             	lea    0x0(%esi),%esi
801047c0:	5b                   	pop    %ebx
  return 0;
801047c1:	31 c0                	xor    %eax,%eax
}
801047c3:	5e                   	pop    %esi
801047c4:	5d                   	pop    %ebp
801047c5:	c3                   	ret    
801047c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047cd:	8d 76 00             	lea    0x0(%esi),%esi

801047d0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	57                   	push   %edi
801047d4:	8b 55 08             	mov    0x8(%ebp),%edx
801047d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801047da:	56                   	push   %esi
801047db:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801047de:	39 d6                	cmp    %edx,%esi
801047e0:	73 26                	jae    80104808 <memmove+0x38>
801047e2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801047e5:	39 fa                	cmp    %edi,%edx
801047e7:	73 1f                	jae    80104808 <memmove+0x38>
801047e9:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
801047ec:	85 c9                	test   %ecx,%ecx
801047ee:	74 0f                	je     801047ff <memmove+0x2f>
      *--d = *--s;
801047f0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801047f4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801047f7:	83 e8 01             	sub    $0x1,%eax
801047fa:	83 f8 ff             	cmp    $0xffffffff,%eax
801047fd:	75 f1                	jne    801047f0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801047ff:	5e                   	pop    %esi
80104800:	89 d0                	mov    %edx,%eax
80104802:	5f                   	pop    %edi
80104803:	5d                   	pop    %ebp
80104804:	c3                   	ret    
80104805:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104808:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010480b:	89 d7                	mov    %edx,%edi
8010480d:	85 c9                	test   %ecx,%ecx
8010480f:	74 ee                	je     801047ff <memmove+0x2f>
80104811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104818:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104819:	39 f0                	cmp    %esi,%eax
8010481b:	75 fb                	jne    80104818 <memmove+0x48>
}
8010481d:	5e                   	pop    %esi
8010481e:	89 d0                	mov    %edx,%eax
80104820:	5f                   	pop    %edi
80104821:	5d                   	pop    %ebp
80104822:	c3                   	ret    
80104823:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010482a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104830 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104830:	eb 9e                	jmp    801047d0 <memmove>
80104832:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104840 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	56                   	push   %esi
80104844:	8b 75 10             	mov    0x10(%ebp),%esi
80104847:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010484a:	53                   	push   %ebx
8010484b:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
8010484e:	85 f6                	test   %esi,%esi
80104850:	74 36                	je     80104888 <strncmp+0x48>
80104852:	01 c6                	add    %eax,%esi
80104854:	eb 18                	jmp    8010486e <strncmp+0x2e>
80104856:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010485d:	8d 76 00             	lea    0x0(%esi),%esi
80104860:	38 da                	cmp    %bl,%dl
80104862:	75 14                	jne    80104878 <strncmp+0x38>
    n--, p++, q++;
80104864:	83 c0 01             	add    $0x1,%eax
80104867:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010486a:	39 f0                	cmp    %esi,%eax
8010486c:	74 1a                	je     80104888 <strncmp+0x48>
8010486e:	0f b6 11             	movzbl (%ecx),%edx
80104871:	0f b6 18             	movzbl (%eax),%ebx
80104874:	84 d2                	test   %dl,%dl
80104876:	75 e8                	jne    80104860 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104878:	0f b6 c2             	movzbl %dl,%eax
8010487b:	29 d8                	sub    %ebx,%eax
}
8010487d:	5b                   	pop    %ebx
8010487e:	5e                   	pop    %esi
8010487f:	5d                   	pop    %ebp
80104880:	c3                   	ret    
80104881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104888:	5b                   	pop    %ebx
    return 0;
80104889:	31 c0                	xor    %eax,%eax
}
8010488b:	5e                   	pop    %esi
8010488c:	5d                   	pop    %ebp
8010488d:	c3                   	ret    
8010488e:	66 90                	xchg   %ax,%ax

80104890 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	57                   	push   %edi
80104894:	56                   	push   %esi
80104895:	8b 75 08             	mov    0x8(%ebp),%esi
80104898:	53                   	push   %ebx
80104899:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010489c:	89 f2                	mov    %esi,%edx
8010489e:	eb 17                	jmp    801048b7 <strncpy+0x27>
801048a0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801048a4:	8b 7d 0c             	mov    0xc(%ebp),%edi
801048a7:	83 c2 01             	add    $0x1,%edx
801048aa:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
801048ae:	89 f9                	mov    %edi,%ecx
801048b0:	88 4a ff             	mov    %cl,-0x1(%edx)
801048b3:	84 c9                	test   %cl,%cl
801048b5:	74 09                	je     801048c0 <strncpy+0x30>
801048b7:	89 c3                	mov    %eax,%ebx
801048b9:	83 e8 01             	sub    $0x1,%eax
801048bc:	85 db                	test   %ebx,%ebx
801048be:	7f e0                	jg     801048a0 <strncpy+0x10>
    ;
  while(n-- > 0)
801048c0:	89 d1                	mov    %edx,%ecx
801048c2:	85 c0                	test   %eax,%eax
801048c4:	7e 1d                	jle    801048e3 <strncpy+0x53>
801048c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048cd:	8d 76 00             	lea    0x0(%esi),%esi
    *s++ = 0;
801048d0:	83 c1 01             	add    $0x1,%ecx
801048d3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
801048d7:	89 c8                	mov    %ecx,%eax
801048d9:	f7 d0                	not    %eax
801048db:	01 d0                	add    %edx,%eax
801048dd:	01 d8                	add    %ebx,%eax
801048df:	85 c0                	test   %eax,%eax
801048e1:	7f ed                	jg     801048d0 <strncpy+0x40>
  return os;
}
801048e3:	5b                   	pop    %ebx
801048e4:	89 f0                	mov    %esi,%eax
801048e6:	5e                   	pop    %esi
801048e7:	5f                   	pop    %edi
801048e8:	5d                   	pop    %ebp
801048e9:	c3                   	ret    
801048ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048f0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	56                   	push   %esi
801048f4:	8b 55 10             	mov    0x10(%ebp),%edx
801048f7:	8b 75 08             	mov    0x8(%ebp),%esi
801048fa:	53                   	push   %ebx
801048fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801048fe:	85 d2                	test   %edx,%edx
80104900:	7e 25                	jle    80104927 <safestrcpy+0x37>
80104902:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104906:	89 f2                	mov    %esi,%edx
80104908:	eb 16                	jmp    80104920 <safestrcpy+0x30>
8010490a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104910:	0f b6 08             	movzbl (%eax),%ecx
80104913:	83 c0 01             	add    $0x1,%eax
80104916:	83 c2 01             	add    $0x1,%edx
80104919:	88 4a ff             	mov    %cl,-0x1(%edx)
8010491c:	84 c9                	test   %cl,%cl
8010491e:	74 04                	je     80104924 <safestrcpy+0x34>
80104920:	39 d8                	cmp    %ebx,%eax
80104922:	75 ec                	jne    80104910 <safestrcpy+0x20>
    ;
  *s = 0;
80104924:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104927:	89 f0                	mov    %esi,%eax
80104929:	5b                   	pop    %ebx
8010492a:	5e                   	pop    %esi
8010492b:	5d                   	pop    %ebp
8010492c:	c3                   	ret    
8010492d:	8d 76 00             	lea    0x0(%esi),%esi

80104930 <strlen>:

int
strlen(const char *s)
{
80104930:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104931:	31 c0                	xor    %eax,%eax
{
80104933:	89 e5                	mov    %esp,%ebp
80104935:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104938:	80 3a 00             	cmpb   $0x0,(%edx)
8010493b:	74 0c                	je     80104949 <strlen+0x19>
8010493d:	8d 76 00             	lea    0x0(%esi),%esi
80104940:	83 c0 01             	add    $0x1,%eax
80104943:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104947:	75 f7                	jne    80104940 <strlen+0x10>
    ;
  return n;
}
80104949:	5d                   	pop    %ebp
8010494a:	c3                   	ret    

8010494b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010494b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010494f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104953:	55                   	push   %ebp
  pushl %ebx
80104954:	53                   	push   %ebx
  pushl %esi
80104955:	56                   	push   %esi
  pushl %edi
80104956:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104957:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104959:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010495b:	5f                   	pop    %edi
  popl %esi
8010495c:	5e                   	pop    %esi
  popl %ebx
8010495d:	5b                   	pop    %ebx
  popl %ebp
8010495e:	5d                   	pop    %ebp
  ret
8010495f:	c3                   	ret    

80104960 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	53                   	push   %ebx
80104964:	83 ec 04             	sub    $0x4,%esp
80104967:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010496a:	e8 91 ef ff ff       	call   80103900 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010496f:	8b 00                	mov    (%eax),%eax
80104971:	39 d8                	cmp    %ebx,%eax
80104973:	76 1b                	jbe    80104990 <fetchint+0x30>
80104975:	8d 53 04             	lea    0x4(%ebx),%edx
80104978:	39 d0                	cmp    %edx,%eax
8010497a:	72 14                	jb     80104990 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010497c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010497f:	8b 13                	mov    (%ebx),%edx
80104981:	89 10                	mov    %edx,(%eax)
  return 0;
80104983:	31 c0                	xor    %eax,%eax
}
80104985:	83 c4 04             	add    $0x4,%esp
80104988:	5b                   	pop    %ebx
80104989:	5d                   	pop    %ebp
8010498a:	c3                   	ret    
8010498b:	90                   	nop
8010498c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104995:	eb ee                	jmp    80104985 <fetchint+0x25>
80104997:	89 f6                	mov    %esi,%esi
80104999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049a0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	53                   	push   %ebx
801049a4:	83 ec 04             	sub    $0x4,%esp
801049a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801049aa:	e8 51 ef ff ff       	call   80103900 <myproc>

  if(addr >= curproc->sz)
801049af:	39 18                	cmp    %ebx,(%eax)
801049b1:	76 29                	jbe    801049dc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801049b3:	8b 55 0c             	mov    0xc(%ebp),%edx
801049b6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801049b8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801049ba:	39 d3                	cmp    %edx,%ebx
801049bc:	73 1e                	jae    801049dc <fetchstr+0x3c>
    if(*s == 0)
801049be:	80 3b 00             	cmpb   $0x0,(%ebx)
801049c1:	74 35                	je     801049f8 <fetchstr+0x58>
801049c3:	89 d8                	mov    %ebx,%eax
801049c5:	eb 0e                	jmp    801049d5 <fetchstr+0x35>
801049c7:	89 f6                	mov    %esi,%esi
801049c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801049d0:	80 38 00             	cmpb   $0x0,(%eax)
801049d3:	74 1b                	je     801049f0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
801049d5:	83 c0 01             	add    $0x1,%eax
801049d8:	39 c2                	cmp    %eax,%edx
801049da:	77 f4                	ja     801049d0 <fetchstr+0x30>
    return -1;
801049dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
801049e1:	83 c4 04             	add    $0x4,%esp
801049e4:	5b                   	pop    %ebx
801049e5:	5d                   	pop    %ebp
801049e6:	c3                   	ret    
801049e7:	89 f6                	mov    %esi,%esi
801049e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801049f0:	83 c4 04             	add    $0x4,%esp
801049f3:	29 d8                	sub    %ebx,%eax
801049f5:	5b                   	pop    %ebx
801049f6:	5d                   	pop    %ebp
801049f7:	c3                   	ret    
    if(*s == 0)
801049f8:	31 c0                	xor    %eax,%eax
      return s - *pp;
801049fa:	eb e5                	jmp    801049e1 <fetchstr+0x41>
801049fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a00 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	56                   	push   %esi
80104a04:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a05:	e8 f6 ee ff ff       	call   80103900 <myproc>
80104a0a:	8b 55 08             	mov    0x8(%ebp),%edx
80104a0d:	8b 40 18             	mov    0x18(%eax),%eax
80104a10:	8b 40 44             	mov    0x44(%eax),%eax
80104a13:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a16:	e8 e5 ee ff ff       	call   80103900 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a1b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a1e:	8b 00                	mov    (%eax),%eax
80104a20:	39 c6                	cmp    %eax,%esi
80104a22:	73 1c                	jae    80104a40 <argint+0x40>
80104a24:	8d 53 08             	lea    0x8(%ebx),%edx
80104a27:	39 d0                	cmp    %edx,%eax
80104a29:	72 15                	jb     80104a40 <argint+0x40>
  *ip = *(int*)(addr);
80104a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a2e:	8b 53 04             	mov    0x4(%ebx),%edx
80104a31:	89 10                	mov    %edx,(%eax)
  return 0;
80104a33:	31 c0                	xor    %eax,%eax
}
80104a35:	5b                   	pop    %ebx
80104a36:	5e                   	pop    %esi
80104a37:	5d                   	pop    %ebp
80104a38:	c3                   	ret    
80104a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a45:	eb ee                	jmp    80104a35 <argint+0x35>
80104a47:	89 f6                	mov    %esi,%esi
80104a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a50 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	56                   	push   %esi
80104a54:	53                   	push   %ebx
80104a55:	83 ec 10             	sub    $0x10,%esp
80104a58:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104a5b:	e8 a0 ee ff ff       	call   80103900 <myproc>
 
  if(argint(n, &i) < 0)
80104a60:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104a63:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80104a65:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a68:	50                   	push   %eax
80104a69:	ff 75 08             	pushl  0x8(%ebp)
80104a6c:	e8 8f ff ff ff       	call   80104a00 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104a71:	83 c4 10             	add    $0x10,%esp
80104a74:	85 c0                	test   %eax,%eax
80104a76:	78 28                	js     80104aa0 <argptr+0x50>
80104a78:	85 db                	test   %ebx,%ebx
80104a7a:	78 24                	js     80104aa0 <argptr+0x50>
80104a7c:	8b 16                	mov    (%esi),%edx
80104a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a81:	39 c2                	cmp    %eax,%edx
80104a83:	76 1b                	jbe    80104aa0 <argptr+0x50>
80104a85:	01 c3                	add    %eax,%ebx
80104a87:	39 da                	cmp    %ebx,%edx
80104a89:	72 15                	jb     80104aa0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104a8b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a8e:	89 02                	mov    %eax,(%edx)
  return 0;
80104a90:	31 c0                	xor    %eax,%eax
}
80104a92:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a95:	5b                   	pop    %ebx
80104a96:	5e                   	pop    %esi
80104a97:	5d                   	pop    %ebp
80104a98:	c3                   	ret    
80104a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104aa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104aa5:	eb eb                	jmp    80104a92 <argptr+0x42>
80104aa7:	89 f6                	mov    %esi,%esi
80104aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ab0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104ab6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ab9:	50                   	push   %eax
80104aba:	ff 75 08             	pushl  0x8(%ebp)
80104abd:	e8 3e ff ff ff       	call   80104a00 <argint>
80104ac2:	83 c4 10             	add    $0x10,%esp
80104ac5:	85 c0                	test   %eax,%eax
80104ac7:	78 17                	js     80104ae0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104ac9:	83 ec 08             	sub    $0x8,%esp
80104acc:	ff 75 0c             	pushl  0xc(%ebp)
80104acf:	ff 75 f4             	pushl  -0xc(%ebp)
80104ad2:	e8 c9 fe ff ff       	call   801049a0 <fetchstr>
80104ad7:	83 c4 10             	add    $0x10,%esp
}
80104ada:	c9                   	leave  
80104adb:	c3                   	ret    
80104adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ae0:	c9                   	leave  
    return -1;
80104ae1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ae6:	c3                   	ret    
80104ae7:	89 f6                	mov    %esi,%esi
80104ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104af0 <syscall>:
[SYS_date]    sys_date, //Alex Correia part f 2
};

void
syscall(void)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	53                   	push   %ebx
80104af4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104af7:	e8 04 ee ff ff       	call   80103900 <myproc>
80104afc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104afe:	8b 40 18             	mov    0x18(%eax),%eax
80104b01:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104b04:	8d 50 ff             	lea    -0x1(%eax),%edx
80104b07:	83 fa 18             	cmp    $0x18,%edx
80104b0a:	77 1c                	ja     80104b28 <syscall+0x38>
80104b0c:	8b 14 85 60 79 10 80 	mov    -0x7fef86a0(,%eax,4),%edx
80104b13:	85 d2                	test   %edx,%edx
80104b15:	74 11                	je     80104b28 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104b17:	ff d2                	call   *%edx
80104b19:	8b 53 18             	mov    0x18(%ebx),%edx
80104b1c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104b1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b22:	c9                   	leave  
80104b23:	c3                   	ret    
80104b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104b28:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104b29:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104b2c:	50                   	push   %eax
80104b2d:	ff 73 10             	pushl  0x10(%ebx)
80104b30:	68 25 79 10 80       	push   $0x80107925
80104b35:	e8 76 bb ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104b3a:	8b 43 18             	mov    0x18(%ebx),%eax
80104b3d:	83 c4 10             	add    $0x10,%esp
80104b40:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104b47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b4a:	c9                   	leave  
80104b4b:	c3                   	ret    
80104b4c:	66 90                	xchg   %ax,%ax
80104b4e:	66 90                	xchg   %ax,%ax

80104b50 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	57                   	push   %edi
80104b54:	56                   	push   %esi
80104b55:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104b56:	8d 5d da             	lea    -0x26(%ebp),%ebx
{
80104b59:	83 ec 44             	sub    $0x44,%esp
80104b5c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104b5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104b62:	53                   	push   %ebx
80104b63:	50                   	push   %eax
{
80104b64:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104b67:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104b6a:	e8 81 d4 ff ff       	call   80101ff0 <nameiparent>
80104b6f:	83 c4 10             	add    $0x10,%esp
80104b72:	85 c0                	test   %eax,%eax
80104b74:	0f 84 46 01 00 00    	je     80104cc0 <create+0x170>
    return 0;
  ilock(dp);
80104b7a:	83 ec 0c             	sub    $0xc,%esp
80104b7d:	89 c6                	mov    %eax,%esi
80104b7f:	50                   	push   %eax
80104b80:	e8 ab cb ff ff       	call   80101730 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104b85:	83 c4 0c             	add    $0xc,%esp
80104b88:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104b8b:	50                   	push   %eax
80104b8c:	53                   	push   %ebx
80104b8d:	56                   	push   %esi
80104b8e:	e8 cd d0 ff ff       	call   80101c60 <dirlookup>
80104b93:	83 c4 10             	add    $0x10,%esp
80104b96:	89 c7                	mov    %eax,%edi
80104b98:	85 c0                	test   %eax,%eax
80104b9a:	74 54                	je     80104bf0 <create+0xa0>
    iunlockput(dp);
80104b9c:	83 ec 0c             	sub    $0xc,%esp
80104b9f:	56                   	push   %esi
80104ba0:	e8 1b ce ff ff       	call   801019c0 <iunlockput>
    ilock(ip);
80104ba5:	89 3c 24             	mov    %edi,(%esp)
80104ba8:	e8 83 cb ff ff       	call   80101730 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104bad:	83 c4 10             	add    $0x10,%esp
80104bb0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104bb5:	75 19                	jne    80104bd0 <create+0x80>
80104bb7:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104bbc:	75 12                	jne    80104bd0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104bbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bc1:	89 f8                	mov    %edi,%eax
80104bc3:	5b                   	pop    %ebx
80104bc4:	5e                   	pop    %esi
80104bc5:	5f                   	pop    %edi
80104bc6:	5d                   	pop    %ebp
80104bc7:	c3                   	ret    
80104bc8:	90                   	nop
80104bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80104bd0:	83 ec 0c             	sub    $0xc,%esp
80104bd3:	57                   	push   %edi
    return 0;
80104bd4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104bd6:	e8 e5 cd ff ff       	call   801019c0 <iunlockput>
    return 0;
80104bdb:	83 c4 10             	add    $0x10,%esp
}
80104bde:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104be1:	89 f8                	mov    %edi,%eax
80104be3:	5b                   	pop    %ebx
80104be4:	5e                   	pop    %esi
80104be5:	5f                   	pop    %edi
80104be6:	5d                   	pop    %ebp
80104be7:	c3                   	ret    
80104be8:	90                   	nop
80104be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
80104bf0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104bf4:	83 ec 08             	sub    $0x8,%esp
80104bf7:	50                   	push   %eax
80104bf8:	ff 36                	pushl  (%esi)
80104bfa:	e8 c1 c9 ff ff       	call   801015c0 <ialloc>
80104bff:	83 c4 10             	add    $0x10,%esp
80104c02:	89 c7                	mov    %eax,%edi
80104c04:	85 c0                	test   %eax,%eax
80104c06:	0f 84 cd 00 00 00    	je     80104cd9 <create+0x189>
  ilock(ip);
80104c0c:	83 ec 0c             	sub    $0xc,%esp
80104c0f:	50                   	push   %eax
80104c10:	e8 1b cb ff ff       	call   80101730 <ilock>
  ip->major = major;
80104c15:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104c19:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104c1d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104c21:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104c25:	b8 01 00 00 00       	mov    $0x1,%eax
80104c2a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104c2e:	89 3c 24             	mov    %edi,(%esp)
80104c31:	e8 4a ca ff ff       	call   80101680 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104c36:	83 c4 10             	add    $0x10,%esp
80104c39:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104c3e:	74 30                	je     80104c70 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104c40:	83 ec 04             	sub    $0x4,%esp
80104c43:	ff 77 04             	pushl  0x4(%edi)
80104c46:	53                   	push   %ebx
80104c47:	56                   	push   %esi
80104c48:	e8 c3 d2 ff ff       	call   80101f10 <dirlink>
80104c4d:	83 c4 10             	add    $0x10,%esp
80104c50:	85 c0                	test   %eax,%eax
80104c52:	78 78                	js     80104ccc <create+0x17c>
  iunlockput(dp);
80104c54:	83 ec 0c             	sub    $0xc,%esp
80104c57:	56                   	push   %esi
80104c58:	e8 63 cd ff ff       	call   801019c0 <iunlockput>
  return ip;
80104c5d:	83 c4 10             	add    $0x10,%esp
}
80104c60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c63:	89 f8                	mov    %edi,%eax
80104c65:	5b                   	pop    %ebx
80104c66:	5e                   	pop    %esi
80104c67:	5f                   	pop    %edi
80104c68:	5d                   	pop    %ebp
80104c69:	c3                   	ret    
80104c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104c70:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104c73:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
80104c78:	56                   	push   %esi
80104c79:	e8 02 ca ff ff       	call   80101680 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104c7e:	83 c4 0c             	add    $0xc,%esp
80104c81:	ff 77 04             	pushl  0x4(%edi)
80104c84:	68 e4 79 10 80       	push   $0x801079e4
80104c89:	57                   	push   %edi
80104c8a:	e8 81 d2 ff ff       	call   80101f10 <dirlink>
80104c8f:	83 c4 10             	add    $0x10,%esp
80104c92:	85 c0                	test   %eax,%eax
80104c94:	78 18                	js     80104cae <create+0x15e>
80104c96:	83 ec 04             	sub    $0x4,%esp
80104c99:	ff 76 04             	pushl  0x4(%esi)
80104c9c:	68 e3 79 10 80       	push   $0x801079e3
80104ca1:	57                   	push   %edi
80104ca2:	e8 69 d2 ff ff       	call   80101f10 <dirlink>
80104ca7:	83 c4 10             	add    $0x10,%esp
80104caa:	85 c0                	test   %eax,%eax
80104cac:	79 92                	jns    80104c40 <create+0xf0>
      panic("create dots");
80104cae:	83 ec 0c             	sub    $0xc,%esp
80104cb1:	68 d7 79 10 80       	push   $0x801079d7
80104cb6:	e8 d5 b6 ff ff       	call   80100390 <panic>
80104cbb:	90                   	nop
80104cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80104cc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104cc3:	31 ff                	xor    %edi,%edi
}
80104cc5:	5b                   	pop    %ebx
80104cc6:	89 f8                	mov    %edi,%eax
80104cc8:	5e                   	pop    %esi
80104cc9:	5f                   	pop    %edi
80104cca:	5d                   	pop    %ebp
80104ccb:	c3                   	ret    
    panic("create: dirlink");
80104ccc:	83 ec 0c             	sub    $0xc,%esp
80104ccf:	68 e6 79 10 80       	push   $0x801079e6
80104cd4:	e8 b7 b6 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104cd9:	83 ec 0c             	sub    $0xc,%esp
80104cdc:	68 c8 79 10 80       	push   $0x801079c8
80104ce1:	e8 aa b6 ff ff       	call   80100390 <panic>
80104ce6:	8d 76 00             	lea    0x0(%esi),%esi
80104ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cf0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	56                   	push   %esi
80104cf4:	89 d6                	mov    %edx,%esi
80104cf6:	53                   	push   %ebx
80104cf7:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104cf9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104cfc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104cff:	50                   	push   %eax
80104d00:	6a 00                	push   $0x0
80104d02:	e8 f9 fc ff ff       	call   80104a00 <argint>
80104d07:	83 c4 10             	add    $0x10,%esp
80104d0a:	85 c0                	test   %eax,%eax
80104d0c:	78 2a                	js     80104d38 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d0e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d12:	77 24                	ja     80104d38 <argfd.constprop.0+0x48>
80104d14:	e8 e7 eb ff ff       	call   80103900 <myproc>
80104d19:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d1c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104d20:	85 c0                	test   %eax,%eax
80104d22:	74 14                	je     80104d38 <argfd.constprop.0+0x48>
  if(pfd)
80104d24:	85 db                	test   %ebx,%ebx
80104d26:	74 02                	je     80104d2a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104d28:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104d2a:	89 06                	mov    %eax,(%esi)
  return 0;
80104d2c:	31 c0                	xor    %eax,%eax
}
80104d2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d31:	5b                   	pop    %ebx
80104d32:	5e                   	pop    %esi
80104d33:	5d                   	pop    %ebp
80104d34:	c3                   	ret    
80104d35:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104d38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d3d:	eb ef                	jmp    80104d2e <argfd.constprop.0+0x3e>
80104d3f:	90                   	nop

80104d40 <sys_dup>:
{
80104d40:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104d41:	31 c0                	xor    %eax,%eax
{
80104d43:	89 e5                	mov    %esp,%ebp
80104d45:	56                   	push   %esi
80104d46:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104d47:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104d4a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104d4d:	e8 9e ff ff ff       	call   80104cf0 <argfd.constprop.0>
80104d52:	85 c0                	test   %eax,%eax
80104d54:	78 1a                	js     80104d70 <sys_dup+0x30>
  if((fd=fdalloc(f)) < 0)
80104d56:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104d59:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104d5b:	e8 a0 eb ff ff       	call   80103900 <myproc>
    if(curproc->ofile[fd] == 0){
80104d60:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104d64:	85 d2                	test   %edx,%edx
80104d66:	74 18                	je     80104d80 <sys_dup+0x40>
  for(fd = 0; fd < NOFILE; fd++){
80104d68:	83 c3 01             	add    $0x1,%ebx
80104d6b:	83 fb 10             	cmp    $0x10,%ebx
80104d6e:	75 f0                	jne    80104d60 <sys_dup+0x20>
}
80104d70:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104d73:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104d78:	89 d8                	mov    %ebx,%eax
80104d7a:	5b                   	pop    %ebx
80104d7b:	5e                   	pop    %esi
80104d7c:	5d                   	pop    %ebp
80104d7d:	c3                   	ret    
80104d7e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80104d80:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104d84:	83 ec 0c             	sub    $0xc,%esp
80104d87:	ff 75 f4             	pushl  -0xc(%ebp)
80104d8a:	e8 f1 c0 ff ff       	call   80100e80 <filedup>
  return fd;
80104d8f:	83 c4 10             	add    $0x10,%esp
}
80104d92:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d95:	89 d8                	mov    %ebx,%eax
80104d97:	5b                   	pop    %ebx
80104d98:	5e                   	pop    %esi
80104d99:	5d                   	pop    %ebp
80104d9a:	c3                   	ret    
80104d9b:	90                   	nop
80104d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104da0 <sys_read>:
{
80104da0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104da1:	31 c0                	xor    %eax,%eax
{
80104da3:	89 e5                	mov    %esp,%ebp
80104da5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104da8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104dab:	e8 40 ff ff ff       	call   80104cf0 <argfd.constprop.0>
80104db0:	85 c0                	test   %eax,%eax
80104db2:	78 4c                	js     80104e00 <sys_read+0x60>
80104db4:	83 ec 08             	sub    $0x8,%esp
80104db7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104dba:	50                   	push   %eax
80104dbb:	6a 02                	push   $0x2
80104dbd:	e8 3e fc ff ff       	call   80104a00 <argint>
80104dc2:	83 c4 10             	add    $0x10,%esp
80104dc5:	85 c0                	test   %eax,%eax
80104dc7:	78 37                	js     80104e00 <sys_read+0x60>
80104dc9:	83 ec 04             	sub    $0x4,%esp
80104dcc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dcf:	ff 75 f0             	pushl  -0x10(%ebp)
80104dd2:	50                   	push   %eax
80104dd3:	6a 01                	push   $0x1
80104dd5:	e8 76 fc ff ff       	call   80104a50 <argptr>
80104dda:	83 c4 10             	add    $0x10,%esp
80104ddd:	85 c0                	test   %eax,%eax
80104ddf:	78 1f                	js     80104e00 <sys_read+0x60>
  return fileread(f, p, n);
80104de1:	83 ec 04             	sub    $0x4,%esp
80104de4:	ff 75 f0             	pushl  -0x10(%ebp)
80104de7:	ff 75 f4             	pushl  -0xc(%ebp)
80104dea:	ff 75 ec             	pushl  -0x14(%ebp)
80104ded:	e8 0e c2 ff ff       	call   80101000 <fileread>
80104df2:	83 c4 10             	add    $0x10,%esp
}
80104df5:	c9                   	leave  
80104df6:	c3                   	ret    
80104df7:	89 f6                	mov    %esi,%esi
80104df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104e00:	c9                   	leave  
    return -1;
80104e01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e06:	c3                   	ret    
80104e07:	89 f6                	mov    %esi,%esi
80104e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e10 <sys_write>:
{
80104e10:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e11:	31 c0                	xor    %eax,%eax
{
80104e13:	89 e5                	mov    %esp,%ebp
80104e15:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e18:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e1b:	e8 d0 fe ff ff       	call   80104cf0 <argfd.constprop.0>
80104e20:	85 c0                	test   %eax,%eax
80104e22:	78 4c                	js     80104e70 <sys_write+0x60>
80104e24:	83 ec 08             	sub    $0x8,%esp
80104e27:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e2a:	50                   	push   %eax
80104e2b:	6a 02                	push   $0x2
80104e2d:	e8 ce fb ff ff       	call   80104a00 <argint>
80104e32:	83 c4 10             	add    $0x10,%esp
80104e35:	85 c0                	test   %eax,%eax
80104e37:	78 37                	js     80104e70 <sys_write+0x60>
80104e39:	83 ec 04             	sub    $0x4,%esp
80104e3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e3f:	ff 75 f0             	pushl  -0x10(%ebp)
80104e42:	50                   	push   %eax
80104e43:	6a 01                	push   $0x1
80104e45:	e8 06 fc ff ff       	call   80104a50 <argptr>
80104e4a:	83 c4 10             	add    $0x10,%esp
80104e4d:	85 c0                	test   %eax,%eax
80104e4f:	78 1f                	js     80104e70 <sys_write+0x60>
  return filewrite(f, p, n);
80104e51:	83 ec 04             	sub    $0x4,%esp
80104e54:	ff 75 f0             	pushl  -0x10(%ebp)
80104e57:	ff 75 f4             	pushl  -0xc(%ebp)
80104e5a:	ff 75 ec             	pushl  -0x14(%ebp)
80104e5d:	e8 2e c2 ff ff       	call   80101090 <filewrite>
80104e62:	83 c4 10             	add    $0x10,%esp
}
80104e65:	c9                   	leave  
80104e66:	c3                   	ret    
80104e67:	89 f6                	mov    %esi,%esi
80104e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104e70:	c9                   	leave  
    return -1;
80104e71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e76:	c3                   	ret    
80104e77:	89 f6                	mov    %esi,%esi
80104e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e80 <sys_close>:
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104e86:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104e89:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e8c:	e8 5f fe ff ff       	call   80104cf0 <argfd.constprop.0>
80104e91:	85 c0                	test   %eax,%eax
80104e93:	78 2b                	js     80104ec0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104e95:	e8 66 ea ff ff       	call   80103900 <myproc>
80104e9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104e9d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104ea0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104ea7:	00 
  fileclose(f);
80104ea8:	ff 75 f4             	pushl  -0xc(%ebp)
80104eab:	e8 20 c0 ff ff       	call   80100ed0 <fileclose>
  return 0;
80104eb0:	83 c4 10             	add    $0x10,%esp
80104eb3:	31 c0                	xor    %eax,%eax
}
80104eb5:	c9                   	leave  
80104eb6:	c3                   	ret    
80104eb7:	89 f6                	mov    %esi,%esi
80104eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104ec0:	c9                   	leave  
    return -1;
80104ec1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ec6:	c3                   	ret    
80104ec7:	89 f6                	mov    %esi,%esi
80104ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ed0 <sys_fstat>:
{
80104ed0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104ed1:	31 c0                	xor    %eax,%eax
{
80104ed3:	89 e5                	mov    %esp,%ebp
80104ed5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104ed8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104edb:	e8 10 fe ff ff       	call   80104cf0 <argfd.constprop.0>
80104ee0:	85 c0                	test   %eax,%eax
80104ee2:	78 2c                	js     80104f10 <sys_fstat+0x40>
80104ee4:	83 ec 04             	sub    $0x4,%esp
80104ee7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104eea:	6a 14                	push   $0x14
80104eec:	50                   	push   %eax
80104eed:	6a 01                	push   $0x1
80104eef:	e8 5c fb ff ff       	call   80104a50 <argptr>
80104ef4:	83 c4 10             	add    $0x10,%esp
80104ef7:	85 c0                	test   %eax,%eax
80104ef9:	78 15                	js     80104f10 <sys_fstat+0x40>
  return filestat(f, st);
80104efb:	83 ec 08             	sub    $0x8,%esp
80104efe:	ff 75 f4             	pushl  -0xc(%ebp)
80104f01:	ff 75 f0             	pushl  -0x10(%ebp)
80104f04:	e8 a7 c0 ff ff       	call   80100fb0 <filestat>
80104f09:	83 c4 10             	add    $0x10,%esp
}
80104f0c:	c9                   	leave  
80104f0d:	c3                   	ret    
80104f0e:	66 90                	xchg   %ax,%ax
80104f10:	c9                   	leave  
    return -1;
80104f11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f16:	c3                   	ret    
80104f17:	89 f6                	mov    %esi,%esi
80104f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f20 <sys_link>:
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	57                   	push   %edi
80104f24:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f25:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104f28:	53                   	push   %ebx
80104f29:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f2c:	50                   	push   %eax
80104f2d:	6a 00                	push   $0x0
80104f2f:	e8 7c fb ff ff       	call   80104ab0 <argstr>
80104f34:	83 c4 10             	add    $0x10,%esp
80104f37:	85 c0                	test   %eax,%eax
80104f39:	0f 88 fb 00 00 00    	js     8010503a <sys_link+0x11a>
80104f3f:	83 ec 08             	sub    $0x8,%esp
80104f42:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104f45:	50                   	push   %eax
80104f46:	6a 01                	push   $0x1
80104f48:	e8 63 fb ff ff       	call   80104ab0 <argstr>
80104f4d:	83 c4 10             	add    $0x10,%esp
80104f50:	85 c0                	test   %eax,%eax
80104f52:	0f 88 e2 00 00 00    	js     8010503a <sys_link+0x11a>
  begin_op();
80104f58:	e8 53 dd ff ff       	call   80102cb0 <begin_op>
  if((ip = namei(old)) == 0){
80104f5d:	83 ec 0c             	sub    $0xc,%esp
80104f60:	ff 75 d4             	pushl  -0x2c(%ebp)
80104f63:	e8 68 d0 ff ff       	call   80101fd0 <namei>
80104f68:	83 c4 10             	add    $0x10,%esp
80104f6b:	89 c3                	mov    %eax,%ebx
80104f6d:	85 c0                	test   %eax,%eax
80104f6f:	0f 84 e4 00 00 00    	je     80105059 <sys_link+0x139>
  ilock(ip);
80104f75:	83 ec 0c             	sub    $0xc,%esp
80104f78:	50                   	push   %eax
80104f79:	e8 b2 c7 ff ff       	call   80101730 <ilock>
  if(ip->type == T_DIR){
80104f7e:	83 c4 10             	add    $0x10,%esp
80104f81:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f86:	0f 84 b5 00 00 00    	je     80105041 <sys_link+0x121>
  iupdate(ip);
80104f8c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104f8f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104f94:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104f97:	53                   	push   %ebx
80104f98:	e8 e3 c6 ff ff       	call   80101680 <iupdate>
  iunlock(ip);
80104f9d:	89 1c 24             	mov    %ebx,(%esp)
80104fa0:	e8 6b c8 ff ff       	call   80101810 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104fa5:	58                   	pop    %eax
80104fa6:	5a                   	pop    %edx
80104fa7:	57                   	push   %edi
80104fa8:	ff 75 d0             	pushl  -0x30(%ebp)
80104fab:	e8 40 d0 ff ff       	call   80101ff0 <nameiparent>
80104fb0:	83 c4 10             	add    $0x10,%esp
80104fb3:	89 c6                	mov    %eax,%esi
80104fb5:	85 c0                	test   %eax,%eax
80104fb7:	74 5b                	je     80105014 <sys_link+0xf4>
  ilock(dp);
80104fb9:	83 ec 0c             	sub    $0xc,%esp
80104fbc:	50                   	push   %eax
80104fbd:	e8 6e c7 ff ff       	call   80101730 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104fc2:	83 c4 10             	add    $0x10,%esp
80104fc5:	8b 03                	mov    (%ebx),%eax
80104fc7:	39 06                	cmp    %eax,(%esi)
80104fc9:	75 3d                	jne    80105008 <sys_link+0xe8>
80104fcb:	83 ec 04             	sub    $0x4,%esp
80104fce:	ff 73 04             	pushl  0x4(%ebx)
80104fd1:	57                   	push   %edi
80104fd2:	56                   	push   %esi
80104fd3:	e8 38 cf ff ff       	call   80101f10 <dirlink>
80104fd8:	83 c4 10             	add    $0x10,%esp
80104fdb:	85 c0                	test   %eax,%eax
80104fdd:	78 29                	js     80105008 <sys_link+0xe8>
  iunlockput(dp);
80104fdf:	83 ec 0c             	sub    $0xc,%esp
80104fe2:	56                   	push   %esi
80104fe3:	e8 d8 c9 ff ff       	call   801019c0 <iunlockput>
  iput(ip);
80104fe8:	89 1c 24             	mov    %ebx,(%esp)
80104feb:	e8 70 c8 ff ff       	call   80101860 <iput>
  end_op();
80104ff0:	e8 2b dd ff ff       	call   80102d20 <end_op>
  return 0;
80104ff5:	83 c4 10             	add    $0x10,%esp
80104ff8:	31 c0                	xor    %eax,%eax
}
80104ffa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ffd:	5b                   	pop    %ebx
80104ffe:	5e                   	pop    %esi
80104fff:	5f                   	pop    %edi
80105000:	5d                   	pop    %ebp
80105001:	c3                   	ret    
80105002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105008:	83 ec 0c             	sub    $0xc,%esp
8010500b:	56                   	push   %esi
8010500c:	e8 af c9 ff ff       	call   801019c0 <iunlockput>
    goto bad;
80105011:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105014:	83 ec 0c             	sub    $0xc,%esp
80105017:	53                   	push   %ebx
80105018:	e8 13 c7 ff ff       	call   80101730 <ilock>
  ip->nlink--;
8010501d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105022:	89 1c 24             	mov    %ebx,(%esp)
80105025:	e8 56 c6 ff ff       	call   80101680 <iupdate>
  iunlockput(ip);
8010502a:	89 1c 24             	mov    %ebx,(%esp)
8010502d:	e8 8e c9 ff ff       	call   801019c0 <iunlockput>
  end_op();
80105032:	e8 e9 dc ff ff       	call   80102d20 <end_op>
  return -1;
80105037:	83 c4 10             	add    $0x10,%esp
8010503a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010503f:	eb b9                	jmp    80104ffa <sys_link+0xda>
    iunlockput(ip);
80105041:	83 ec 0c             	sub    $0xc,%esp
80105044:	53                   	push   %ebx
80105045:	e8 76 c9 ff ff       	call   801019c0 <iunlockput>
    end_op();
8010504a:	e8 d1 dc ff ff       	call   80102d20 <end_op>
    return -1;
8010504f:	83 c4 10             	add    $0x10,%esp
80105052:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105057:	eb a1                	jmp    80104ffa <sys_link+0xda>
    end_op();
80105059:	e8 c2 dc ff ff       	call   80102d20 <end_op>
    return -1;
8010505e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105063:	eb 95                	jmp    80104ffa <sys_link+0xda>
80105065:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105070 <sys_unlink>:
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	57                   	push   %edi
80105074:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105075:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105078:	53                   	push   %ebx
80105079:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010507c:	50                   	push   %eax
8010507d:	6a 00                	push   $0x0
8010507f:	e8 2c fa ff ff       	call   80104ab0 <argstr>
80105084:	83 c4 10             	add    $0x10,%esp
80105087:	85 c0                	test   %eax,%eax
80105089:	0f 88 91 01 00 00    	js     80105220 <sys_unlink+0x1b0>
  begin_op();
8010508f:	e8 1c dc ff ff       	call   80102cb0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105094:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105097:	83 ec 08             	sub    $0x8,%esp
8010509a:	53                   	push   %ebx
8010509b:	ff 75 c0             	pushl  -0x40(%ebp)
8010509e:	e8 4d cf ff ff       	call   80101ff0 <nameiparent>
801050a3:	83 c4 10             	add    $0x10,%esp
801050a6:	89 c6                	mov    %eax,%esi
801050a8:	85 c0                	test   %eax,%eax
801050aa:	0f 84 7a 01 00 00    	je     8010522a <sys_unlink+0x1ba>
  ilock(dp);
801050b0:	83 ec 0c             	sub    $0xc,%esp
801050b3:	50                   	push   %eax
801050b4:	e8 77 c6 ff ff       	call   80101730 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801050b9:	58                   	pop    %eax
801050ba:	5a                   	pop    %edx
801050bb:	68 e4 79 10 80       	push   $0x801079e4
801050c0:	53                   	push   %ebx
801050c1:	e8 7a cb ff ff       	call   80101c40 <namecmp>
801050c6:	83 c4 10             	add    $0x10,%esp
801050c9:	85 c0                	test   %eax,%eax
801050cb:	0f 84 0f 01 00 00    	je     801051e0 <sys_unlink+0x170>
801050d1:	83 ec 08             	sub    $0x8,%esp
801050d4:	68 e3 79 10 80       	push   $0x801079e3
801050d9:	53                   	push   %ebx
801050da:	e8 61 cb ff ff       	call   80101c40 <namecmp>
801050df:	83 c4 10             	add    $0x10,%esp
801050e2:	85 c0                	test   %eax,%eax
801050e4:	0f 84 f6 00 00 00    	je     801051e0 <sys_unlink+0x170>
  if((ip = dirlookup(dp, name, &off)) == 0)
801050ea:	83 ec 04             	sub    $0x4,%esp
801050ed:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801050f0:	50                   	push   %eax
801050f1:	53                   	push   %ebx
801050f2:	56                   	push   %esi
801050f3:	e8 68 cb ff ff       	call   80101c60 <dirlookup>
801050f8:	83 c4 10             	add    $0x10,%esp
801050fb:	89 c3                	mov    %eax,%ebx
801050fd:	85 c0                	test   %eax,%eax
801050ff:	0f 84 db 00 00 00    	je     801051e0 <sys_unlink+0x170>
  ilock(ip);
80105105:	83 ec 0c             	sub    $0xc,%esp
80105108:	50                   	push   %eax
80105109:	e8 22 c6 ff ff       	call   80101730 <ilock>
  if(ip->nlink < 1)
8010510e:	83 c4 10             	add    $0x10,%esp
80105111:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105116:	0f 8e 37 01 00 00    	jle    80105253 <sys_unlink+0x1e3>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010511c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105121:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105124:	74 6a                	je     80105190 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105126:	83 ec 04             	sub    $0x4,%esp
80105129:	6a 10                	push   $0x10
8010512b:	6a 00                	push   $0x0
8010512d:	57                   	push   %edi
8010512e:	e8 fd f5 ff ff       	call   80104730 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105133:	6a 10                	push   $0x10
80105135:	ff 75 c4             	pushl  -0x3c(%ebp)
80105138:	57                   	push   %edi
80105139:	56                   	push   %esi
8010513a:	e8 d1 c9 ff ff       	call   80101b10 <writei>
8010513f:	83 c4 20             	add    $0x20,%esp
80105142:	83 f8 10             	cmp    $0x10,%eax
80105145:	0f 85 fb 00 00 00    	jne    80105246 <sys_unlink+0x1d6>
  if(ip->type == T_DIR){
8010514b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105150:	0f 84 aa 00 00 00    	je     80105200 <sys_unlink+0x190>
  iunlockput(dp);
80105156:	83 ec 0c             	sub    $0xc,%esp
80105159:	56                   	push   %esi
8010515a:	e8 61 c8 ff ff       	call   801019c0 <iunlockput>
  ip->nlink--;
8010515f:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105164:	89 1c 24             	mov    %ebx,(%esp)
80105167:	e8 14 c5 ff ff       	call   80101680 <iupdate>
  iunlockput(ip);
8010516c:	89 1c 24             	mov    %ebx,(%esp)
8010516f:	e8 4c c8 ff ff       	call   801019c0 <iunlockput>
  end_op();
80105174:	e8 a7 db ff ff       	call   80102d20 <end_op>
  return 0;
80105179:	83 c4 10             	add    $0x10,%esp
8010517c:	31 c0                	xor    %eax,%eax
}
8010517e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105181:	5b                   	pop    %ebx
80105182:	5e                   	pop    %esi
80105183:	5f                   	pop    %edi
80105184:	5d                   	pop    %ebp
80105185:	c3                   	ret    
80105186:	8d 76 00             	lea    0x0(%esi),%esi
80105189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105190:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105194:	76 90                	jbe    80105126 <sys_unlink+0xb6>
80105196:	ba 20 00 00 00       	mov    $0x20,%edx
8010519b:	eb 0f                	jmp    801051ac <sys_unlink+0x13c>
8010519d:	8d 76 00             	lea    0x0(%esi),%esi
801051a0:	83 c2 10             	add    $0x10,%edx
801051a3:	39 53 58             	cmp    %edx,0x58(%ebx)
801051a6:	0f 86 7a ff ff ff    	jbe    80105126 <sys_unlink+0xb6>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051ac:	6a 10                	push   $0x10
801051ae:	52                   	push   %edx
801051af:	57                   	push   %edi
801051b0:	53                   	push   %ebx
801051b1:	89 55 b4             	mov    %edx,-0x4c(%ebp)
801051b4:	e8 57 c8 ff ff       	call   80101a10 <readi>
801051b9:	83 c4 10             	add    $0x10,%esp
801051bc:	8b 55 b4             	mov    -0x4c(%ebp),%edx
801051bf:	83 f8 10             	cmp    $0x10,%eax
801051c2:	75 75                	jne    80105239 <sys_unlink+0x1c9>
    if(de.inum != 0)
801051c4:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801051c9:	74 d5                	je     801051a0 <sys_unlink+0x130>
    iunlockput(ip);
801051cb:	83 ec 0c             	sub    $0xc,%esp
801051ce:	53                   	push   %ebx
801051cf:	e8 ec c7 ff ff       	call   801019c0 <iunlockput>
    goto bad;
801051d4:	83 c4 10             	add    $0x10,%esp
801051d7:	89 f6                	mov    %esi,%esi
801051d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  iunlockput(dp);
801051e0:	83 ec 0c             	sub    $0xc,%esp
801051e3:	56                   	push   %esi
801051e4:	e8 d7 c7 ff ff       	call   801019c0 <iunlockput>
  end_op();
801051e9:	e8 32 db ff ff       	call   80102d20 <end_op>
  return -1;
801051ee:	83 c4 10             	add    $0x10,%esp
801051f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051f6:	eb 86                	jmp    8010517e <sys_unlink+0x10e>
801051f8:	90                   	nop
801051f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(dp);
80105200:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105203:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105208:	56                   	push   %esi
80105209:	e8 72 c4 ff ff       	call   80101680 <iupdate>
8010520e:	83 c4 10             	add    $0x10,%esp
80105211:	e9 40 ff ff ff       	jmp    80105156 <sys_unlink+0xe6>
80105216:	8d 76 00             	lea    0x0(%esi),%esi
80105219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105220:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105225:	e9 54 ff ff ff       	jmp    8010517e <sys_unlink+0x10e>
    end_op();
8010522a:	e8 f1 da ff ff       	call   80102d20 <end_op>
    return -1;
8010522f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105234:	e9 45 ff ff ff       	jmp    8010517e <sys_unlink+0x10e>
      panic("isdirempty: readi");
80105239:	83 ec 0c             	sub    $0xc,%esp
8010523c:	68 08 7a 10 80       	push   $0x80107a08
80105241:	e8 4a b1 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105246:	83 ec 0c             	sub    $0xc,%esp
80105249:	68 1a 7a 10 80       	push   $0x80107a1a
8010524e:	e8 3d b1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105253:	83 ec 0c             	sub    $0xc,%esp
80105256:	68 f6 79 10 80       	push   $0x801079f6
8010525b:	e8 30 b1 ff ff       	call   80100390 <panic>

80105260 <sys_open>:

int
sys_open(void)
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	57                   	push   %edi
80105264:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105265:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105268:	53                   	push   %ebx
80105269:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010526c:	50                   	push   %eax
8010526d:	6a 00                	push   $0x0
8010526f:	e8 3c f8 ff ff       	call   80104ab0 <argstr>
80105274:	83 c4 10             	add    $0x10,%esp
80105277:	85 c0                	test   %eax,%eax
80105279:	0f 88 8e 00 00 00    	js     8010530d <sys_open+0xad>
8010527f:	83 ec 08             	sub    $0x8,%esp
80105282:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105285:	50                   	push   %eax
80105286:	6a 01                	push   $0x1
80105288:	e8 73 f7 ff ff       	call   80104a00 <argint>
8010528d:	83 c4 10             	add    $0x10,%esp
80105290:	85 c0                	test   %eax,%eax
80105292:	78 79                	js     8010530d <sys_open+0xad>
    return -1;

  begin_op();
80105294:	e8 17 da ff ff       	call   80102cb0 <begin_op>

  if(omode & O_CREATE){
80105299:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010529d:	75 79                	jne    80105318 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010529f:	83 ec 0c             	sub    $0xc,%esp
801052a2:	ff 75 e0             	pushl  -0x20(%ebp)
801052a5:	e8 26 cd ff ff       	call   80101fd0 <namei>
801052aa:	83 c4 10             	add    $0x10,%esp
801052ad:	89 c6                	mov    %eax,%esi
801052af:	85 c0                	test   %eax,%eax
801052b1:	0f 84 7e 00 00 00    	je     80105335 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801052b7:	83 ec 0c             	sub    $0xc,%esp
801052ba:	50                   	push   %eax
801052bb:	e8 70 c4 ff ff       	call   80101730 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801052c0:	83 c4 10             	add    $0x10,%esp
801052c3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801052c8:	0f 84 c2 00 00 00    	je     80105390 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801052ce:	e8 3d bb ff ff       	call   80100e10 <filealloc>
801052d3:	89 c7                	mov    %eax,%edi
801052d5:	85 c0                	test   %eax,%eax
801052d7:	74 23                	je     801052fc <sys_open+0x9c>
  struct proc *curproc = myproc();
801052d9:	e8 22 e6 ff ff       	call   80103900 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801052de:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801052e0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801052e4:	85 d2                	test   %edx,%edx
801052e6:	74 60                	je     80105348 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801052e8:	83 c3 01             	add    $0x1,%ebx
801052eb:	83 fb 10             	cmp    $0x10,%ebx
801052ee:	75 f0                	jne    801052e0 <sys_open+0x80>
    if(f)
      fileclose(f);
801052f0:	83 ec 0c             	sub    $0xc,%esp
801052f3:	57                   	push   %edi
801052f4:	e8 d7 bb ff ff       	call   80100ed0 <fileclose>
801052f9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801052fc:	83 ec 0c             	sub    $0xc,%esp
801052ff:	56                   	push   %esi
80105300:	e8 bb c6 ff ff       	call   801019c0 <iunlockput>
    end_op();
80105305:	e8 16 da ff ff       	call   80102d20 <end_op>
    return -1;
8010530a:	83 c4 10             	add    $0x10,%esp
8010530d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105312:	eb 6d                	jmp    80105381 <sys_open+0x121>
80105314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105318:	83 ec 0c             	sub    $0xc,%esp
8010531b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010531e:	31 c9                	xor    %ecx,%ecx
80105320:	ba 02 00 00 00       	mov    $0x2,%edx
80105325:	6a 00                	push   $0x0
80105327:	e8 24 f8 ff ff       	call   80104b50 <create>
    if(ip == 0){
8010532c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010532f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105331:	85 c0                	test   %eax,%eax
80105333:	75 99                	jne    801052ce <sys_open+0x6e>
      end_op();
80105335:	e8 e6 d9 ff ff       	call   80102d20 <end_op>
      return -1;
8010533a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010533f:	eb 40                	jmp    80105381 <sys_open+0x121>
80105341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105348:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010534b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010534f:	56                   	push   %esi
80105350:	e8 bb c4 ff ff       	call   80101810 <iunlock>
  end_op();
80105355:	e8 c6 d9 ff ff       	call   80102d20 <end_op>

  f->type = FD_INODE;
8010535a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105360:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105363:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105366:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105369:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010536b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105372:	f7 d0                	not    %eax
80105374:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105377:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010537a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010537d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105381:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105384:	89 d8                	mov    %ebx,%eax
80105386:	5b                   	pop    %ebx
80105387:	5e                   	pop    %esi
80105388:	5f                   	pop    %edi
80105389:	5d                   	pop    %ebp
8010538a:	c3                   	ret    
8010538b:	90                   	nop
8010538c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105390:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105393:	85 c9                	test   %ecx,%ecx
80105395:	0f 84 33 ff ff ff    	je     801052ce <sys_open+0x6e>
8010539b:	e9 5c ff ff ff       	jmp    801052fc <sys_open+0x9c>

801053a0 <sys_mkdir>:

int
sys_mkdir(void)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801053a6:	e8 05 d9 ff ff       	call   80102cb0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801053ab:	83 ec 08             	sub    $0x8,%esp
801053ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053b1:	50                   	push   %eax
801053b2:	6a 00                	push   $0x0
801053b4:	e8 f7 f6 ff ff       	call   80104ab0 <argstr>
801053b9:	83 c4 10             	add    $0x10,%esp
801053bc:	85 c0                	test   %eax,%eax
801053be:	78 30                	js     801053f0 <sys_mkdir+0x50>
801053c0:	83 ec 0c             	sub    $0xc,%esp
801053c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053c6:	31 c9                	xor    %ecx,%ecx
801053c8:	ba 01 00 00 00       	mov    $0x1,%edx
801053cd:	6a 00                	push   $0x0
801053cf:	e8 7c f7 ff ff       	call   80104b50 <create>
801053d4:	83 c4 10             	add    $0x10,%esp
801053d7:	85 c0                	test   %eax,%eax
801053d9:	74 15                	je     801053f0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801053db:	83 ec 0c             	sub    $0xc,%esp
801053de:	50                   	push   %eax
801053df:	e8 dc c5 ff ff       	call   801019c0 <iunlockput>
  end_op();
801053e4:	e8 37 d9 ff ff       	call   80102d20 <end_op>
  return 0;
801053e9:	83 c4 10             	add    $0x10,%esp
801053ec:	31 c0                	xor    %eax,%eax
}
801053ee:	c9                   	leave  
801053ef:	c3                   	ret    
    end_op();
801053f0:	e8 2b d9 ff ff       	call   80102d20 <end_op>
    return -1;
801053f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053fa:	c9                   	leave  
801053fb:	c3                   	ret    
801053fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105400 <sys_mknod>:

int
sys_mknod(void)
{
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp
80105403:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105406:	e8 a5 d8 ff ff       	call   80102cb0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010540b:	83 ec 08             	sub    $0x8,%esp
8010540e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105411:	50                   	push   %eax
80105412:	6a 00                	push   $0x0
80105414:	e8 97 f6 ff ff       	call   80104ab0 <argstr>
80105419:	83 c4 10             	add    $0x10,%esp
8010541c:	85 c0                	test   %eax,%eax
8010541e:	78 60                	js     80105480 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105420:	83 ec 08             	sub    $0x8,%esp
80105423:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105426:	50                   	push   %eax
80105427:	6a 01                	push   $0x1
80105429:	e8 d2 f5 ff ff       	call   80104a00 <argint>
  if((argstr(0, &path)) < 0 ||
8010542e:	83 c4 10             	add    $0x10,%esp
80105431:	85 c0                	test   %eax,%eax
80105433:	78 4b                	js     80105480 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105435:	83 ec 08             	sub    $0x8,%esp
80105438:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010543b:	50                   	push   %eax
8010543c:	6a 02                	push   $0x2
8010543e:	e8 bd f5 ff ff       	call   80104a00 <argint>
     argint(1, &major) < 0 ||
80105443:	83 c4 10             	add    $0x10,%esp
80105446:	85 c0                	test   %eax,%eax
80105448:	78 36                	js     80105480 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010544a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010544e:	83 ec 0c             	sub    $0xc,%esp
80105451:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105455:	ba 03 00 00 00       	mov    $0x3,%edx
8010545a:	50                   	push   %eax
8010545b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010545e:	e8 ed f6 ff ff       	call   80104b50 <create>
     argint(2, &minor) < 0 ||
80105463:	83 c4 10             	add    $0x10,%esp
80105466:	85 c0                	test   %eax,%eax
80105468:	74 16                	je     80105480 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010546a:	83 ec 0c             	sub    $0xc,%esp
8010546d:	50                   	push   %eax
8010546e:	e8 4d c5 ff ff       	call   801019c0 <iunlockput>
  end_op();
80105473:	e8 a8 d8 ff ff       	call   80102d20 <end_op>
  return 0;
80105478:	83 c4 10             	add    $0x10,%esp
8010547b:	31 c0                	xor    %eax,%eax
}
8010547d:	c9                   	leave  
8010547e:	c3                   	ret    
8010547f:	90                   	nop
    end_op();
80105480:	e8 9b d8 ff ff       	call   80102d20 <end_op>
    return -1;
80105485:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010548a:	c9                   	leave  
8010548b:	c3                   	ret    
8010548c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105490 <sys_chdir>:

int
sys_chdir(void)
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	56                   	push   %esi
80105494:	53                   	push   %ebx
80105495:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105498:	e8 63 e4 ff ff       	call   80103900 <myproc>
8010549d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010549f:	e8 0c d8 ff ff       	call   80102cb0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801054a4:	83 ec 08             	sub    $0x8,%esp
801054a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054aa:	50                   	push   %eax
801054ab:	6a 00                	push   $0x0
801054ad:	e8 fe f5 ff ff       	call   80104ab0 <argstr>
801054b2:	83 c4 10             	add    $0x10,%esp
801054b5:	85 c0                	test   %eax,%eax
801054b7:	78 77                	js     80105530 <sys_chdir+0xa0>
801054b9:	83 ec 0c             	sub    $0xc,%esp
801054bc:	ff 75 f4             	pushl  -0xc(%ebp)
801054bf:	e8 0c cb ff ff       	call   80101fd0 <namei>
801054c4:	83 c4 10             	add    $0x10,%esp
801054c7:	89 c3                	mov    %eax,%ebx
801054c9:	85 c0                	test   %eax,%eax
801054cb:	74 63                	je     80105530 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801054cd:	83 ec 0c             	sub    $0xc,%esp
801054d0:	50                   	push   %eax
801054d1:	e8 5a c2 ff ff       	call   80101730 <ilock>
  if(ip->type != T_DIR){
801054d6:	83 c4 10             	add    $0x10,%esp
801054d9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054de:	75 30                	jne    80105510 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801054e0:	83 ec 0c             	sub    $0xc,%esp
801054e3:	53                   	push   %ebx
801054e4:	e8 27 c3 ff ff       	call   80101810 <iunlock>
  iput(curproc->cwd);
801054e9:	58                   	pop    %eax
801054ea:	ff 76 68             	pushl  0x68(%esi)
801054ed:	e8 6e c3 ff ff       	call   80101860 <iput>
  end_op();
801054f2:	e8 29 d8 ff ff       	call   80102d20 <end_op>
  curproc->cwd = ip;
801054f7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801054fa:	83 c4 10             	add    $0x10,%esp
801054fd:	31 c0                	xor    %eax,%eax
}
801054ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105502:	5b                   	pop    %ebx
80105503:	5e                   	pop    %esi
80105504:	5d                   	pop    %ebp
80105505:	c3                   	ret    
80105506:	8d 76 00             	lea    0x0(%esi),%esi
80105509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105510:	83 ec 0c             	sub    $0xc,%esp
80105513:	53                   	push   %ebx
80105514:	e8 a7 c4 ff ff       	call   801019c0 <iunlockput>
    end_op();
80105519:	e8 02 d8 ff ff       	call   80102d20 <end_op>
    return -1;
8010551e:	83 c4 10             	add    $0x10,%esp
80105521:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105526:	eb d7                	jmp    801054ff <sys_chdir+0x6f>
80105528:	90                   	nop
80105529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105530:	e8 eb d7 ff ff       	call   80102d20 <end_op>
    return -1;
80105535:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010553a:	eb c3                	jmp    801054ff <sys_chdir+0x6f>
8010553c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105540 <sys_exec>:

int
sys_exec(void)
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	57                   	push   %edi
80105544:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105545:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010554b:	53                   	push   %ebx
8010554c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105552:	50                   	push   %eax
80105553:	6a 00                	push   $0x0
80105555:	e8 56 f5 ff ff       	call   80104ab0 <argstr>
8010555a:	83 c4 10             	add    $0x10,%esp
8010555d:	85 c0                	test   %eax,%eax
8010555f:	0f 88 87 00 00 00    	js     801055ec <sys_exec+0xac>
80105565:	83 ec 08             	sub    $0x8,%esp
80105568:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010556e:	50                   	push   %eax
8010556f:	6a 01                	push   $0x1
80105571:	e8 8a f4 ff ff       	call   80104a00 <argint>
80105576:	83 c4 10             	add    $0x10,%esp
80105579:	85 c0                	test   %eax,%eax
8010557b:	78 6f                	js     801055ec <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010557d:	83 ec 04             	sub    $0x4,%esp
80105580:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105586:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105588:	68 80 00 00 00       	push   $0x80
8010558d:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105593:	6a 00                	push   $0x0
80105595:	50                   	push   %eax
80105596:	e8 95 f1 ff ff       	call   80104730 <memset>
8010559b:	83 c4 10             	add    $0x10,%esp
8010559e:	66 90                	xchg   %ax,%ax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801055a0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801055a6:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801055ad:	83 ec 08             	sub    $0x8,%esp
801055b0:	57                   	push   %edi
801055b1:	01 f0                	add    %esi,%eax
801055b3:	50                   	push   %eax
801055b4:	e8 a7 f3 ff ff       	call   80104960 <fetchint>
801055b9:	83 c4 10             	add    $0x10,%esp
801055bc:	85 c0                	test   %eax,%eax
801055be:	78 2c                	js     801055ec <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801055c0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801055c6:	85 c0                	test   %eax,%eax
801055c8:	74 36                	je     80105600 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801055ca:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801055d0:	83 ec 08             	sub    $0x8,%esp
801055d3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801055d6:	52                   	push   %edx
801055d7:	50                   	push   %eax
801055d8:	e8 c3 f3 ff ff       	call   801049a0 <fetchstr>
801055dd:	83 c4 10             	add    $0x10,%esp
801055e0:	85 c0                	test   %eax,%eax
801055e2:	78 08                	js     801055ec <sys_exec+0xac>
  for(i=0;; i++){
801055e4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801055e7:	83 fb 20             	cmp    $0x20,%ebx
801055ea:	75 b4                	jne    801055a0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801055ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801055ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055f4:	5b                   	pop    %ebx
801055f5:	5e                   	pop    %esi
801055f6:	5f                   	pop    %edi
801055f7:	5d                   	pop    %ebp
801055f8:	c3                   	ret    
801055f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105600:	83 ec 08             	sub    $0x8,%esp
80105603:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105609:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105610:	00 00 00 00 
  return exec(path, argv);
80105614:	50                   	push   %eax
80105615:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010561b:	e8 60 b4 ff ff       	call   80100a80 <exec>
80105620:	83 c4 10             	add    $0x10,%esp
}
80105623:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105626:	5b                   	pop    %ebx
80105627:	5e                   	pop    %esi
80105628:	5f                   	pop    %edi
80105629:	5d                   	pop    %ebp
8010562a:	c3                   	ret    
8010562b:	90                   	nop
8010562c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105630 <sys_pipe>:

int
sys_pipe(void)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	57                   	push   %edi
80105634:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105635:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105638:	53                   	push   %ebx
80105639:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010563c:	6a 08                	push   $0x8
8010563e:	50                   	push   %eax
8010563f:	6a 00                	push   $0x0
80105641:	e8 0a f4 ff ff       	call   80104a50 <argptr>
80105646:	83 c4 10             	add    $0x10,%esp
80105649:	85 c0                	test   %eax,%eax
8010564b:	78 4a                	js     80105697 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010564d:	83 ec 08             	sub    $0x8,%esp
80105650:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105653:	50                   	push   %eax
80105654:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105657:	50                   	push   %eax
80105658:	e8 03 dd ff ff       	call   80103360 <pipealloc>
8010565d:	83 c4 10             	add    $0x10,%esp
80105660:	85 c0                	test   %eax,%eax
80105662:	78 33                	js     80105697 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105664:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105667:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105669:	e8 92 e2 ff ff       	call   80103900 <myproc>
8010566e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105670:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105674:	85 f6                	test   %esi,%esi
80105676:	74 28                	je     801056a0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105678:	83 c3 01             	add    $0x1,%ebx
8010567b:	83 fb 10             	cmp    $0x10,%ebx
8010567e:	75 f0                	jne    80105670 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105680:	83 ec 0c             	sub    $0xc,%esp
80105683:	ff 75 e0             	pushl  -0x20(%ebp)
80105686:	e8 45 b8 ff ff       	call   80100ed0 <fileclose>
    fileclose(wf);
8010568b:	58                   	pop    %eax
8010568c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010568f:	e8 3c b8 ff ff       	call   80100ed0 <fileclose>
    return -1;
80105694:	83 c4 10             	add    $0x10,%esp
80105697:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010569c:	eb 53                	jmp    801056f1 <sys_pipe+0xc1>
8010569e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801056a0:	8d 73 08             	lea    0x8(%ebx),%esi
801056a3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801056a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801056aa:	e8 51 e2 ff ff       	call   80103900 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801056af:	31 d2                	xor    %edx,%edx
801056b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801056b8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801056bc:	85 c9                	test   %ecx,%ecx
801056be:	74 20                	je     801056e0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
801056c0:	83 c2 01             	add    $0x1,%edx
801056c3:	83 fa 10             	cmp    $0x10,%edx
801056c6:	75 f0                	jne    801056b8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
801056c8:	e8 33 e2 ff ff       	call   80103900 <myproc>
801056cd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801056d4:	00 
801056d5:	eb a9                	jmp    80105680 <sys_pipe+0x50>
801056d7:	89 f6                	mov    %esi,%esi
801056d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      curproc->ofile[fd] = f;
801056e0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801056e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056e7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801056e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056ec:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801056ef:	31 c0                	xor    %eax,%eax
}
801056f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056f4:	5b                   	pop    %ebx
801056f5:	5e                   	pop    %esi
801056f6:	5f                   	pop    %edi
801056f7:	5d                   	pop    %ebp
801056f8:	c3                   	ret    
801056f9:	66 90                	xchg   %ax,%ax
801056fb:	66 90                	xchg   %ax,%ax
801056fd:	66 90                	xchg   %ax,%ax
801056ff:	90                   	nop

80105700 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105700:	e9 9b e3 ff ff       	jmp    80103aa0 <fork>
80105705:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105710 <sys_exit>:
}

int
sys_exit(void)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	83 ec 08             	sub    $0x8,%esp
  exit();
80105716:	e8 25 e6 ff ff       	call   80103d40 <exit>
  return 0;  // not reached
}
8010571b:	31 c0                	xor    %eax,%eax
8010571d:	c9                   	leave  
8010571e:	c3                   	ret    
8010571f:	90                   	nop

80105720 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105720:	e9 5b e8 ff ff       	jmp    80103f80 <wait>
80105725:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105730 <sys_kill>:
}

int
sys_kill(void)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105736:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105739:	50                   	push   %eax
8010573a:	6a 00                	push   $0x0
8010573c:	e8 bf f2 ff ff       	call   80104a00 <argint>
80105741:	83 c4 10             	add    $0x10,%esp
80105744:	85 c0                	test   %eax,%eax
80105746:	78 18                	js     80105760 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105748:	83 ec 0c             	sub    $0xc,%esp
8010574b:	ff 75 f4             	pushl  -0xc(%ebp)
8010574e:	e8 7d e9 ff ff       	call   801040d0 <kill>
80105753:	83 c4 10             	add    $0x10,%esp
}
80105756:	c9                   	leave  
80105757:	c3                   	ret    
80105758:	90                   	nop
80105759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105760:	c9                   	leave  
    return -1;
80105761:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105766:	c3                   	ret    
80105767:	89 f6                	mov    %esi,%esi
80105769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105770 <sys_getpid>:

int
sys_getpid(void)
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105776:	e8 85 e1 ff ff       	call   80103900 <myproc>
8010577b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010577e:	c9                   	leave  
8010577f:	c3                   	ret    

80105780 <sys_sbrk>:

int
sys_sbrk(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105784:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105787:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010578a:	50                   	push   %eax
8010578b:	6a 00                	push   $0x0
8010578d:	e8 6e f2 ff ff       	call   80104a00 <argint>
80105792:	83 c4 10             	add    $0x10,%esp
80105795:	85 c0                	test   %eax,%eax
80105797:	78 27                	js     801057c0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105799:	e8 62 e1 ff ff       	call   80103900 <myproc>
  if(growproc(n) < 0)
8010579e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801057a1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801057a3:	ff 75 f4             	pushl  -0xc(%ebp)
801057a6:	e8 75 e2 ff ff       	call   80103a20 <growproc>
801057ab:	83 c4 10             	add    $0x10,%esp
801057ae:	85 c0                	test   %eax,%eax
801057b0:	78 0e                	js     801057c0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801057b2:	89 d8                	mov    %ebx,%eax
801057b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057b7:	c9                   	leave  
801057b8:	c3                   	ret    
801057b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801057c0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801057c5:	eb eb                	jmp    801057b2 <sys_sbrk+0x32>
801057c7:	89 f6                	mov    %esi,%esi
801057c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057d0 <sys_cps>:

int
sys_cps(void)
{
  return cps();
801057d0:	e9 7b e9 ff ff       	jmp    80104150 <cps>
801057d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057e0 <sys_nps>:
}

int
sys_nps(void)
{
  return nps();
801057e0:	e9 3b ea ff ff       	jmp    80104220 <nps>
801057e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057f0 <sys_chpr>:
}

int
sys_chpr (void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	83 ec 20             	sub    $0x20,%esp
  int pid, pr;
  if(argint(0, &pid) < 0)
801057f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057f9:	50                   	push   %eax
801057fa:	6a 00                	push   $0x0
801057fc:	e8 ff f1 ff ff       	call   80104a00 <argint>
80105801:	83 c4 10             	add    $0x10,%esp
80105804:	85 c0                	test   %eax,%eax
80105806:	78 28                	js     80105830 <sys_chpr+0x40>
    return -1;
  if(argint(1, &pr) < 0)
80105808:	83 ec 08             	sub    $0x8,%esp
8010580b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010580e:	50                   	push   %eax
8010580f:	6a 01                	push   $0x1
80105811:	e8 ea f1 ff ff       	call   80104a00 <argint>
80105816:	83 c4 10             	add    $0x10,%esp
80105819:	85 c0                	test   %eax,%eax
8010581b:	78 13                	js     80105830 <sys_chpr+0x40>
    return -1;

  return chpr ( pid, pr );
8010581d:	83 ec 08             	sub    $0x8,%esp
80105820:	ff 75 f4             	pushl  -0xc(%ebp)
80105823:	ff 75 f0             	pushl  -0x10(%ebp)
80105826:	e8 75 ea ff ff       	call   801042a0 <chpr>
8010582b:	83 c4 10             	add    $0x10,%esp
}
8010582e:	c9                   	leave  
8010582f:	c3                   	ret    
80105830:	c9                   	leave  
    return -1;
80105831:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105836:	c3                   	ret    
80105837:	89 f6                	mov    %esi,%esi
80105839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105840 <sys_date>:

int         //Alex Correia part d
sys_date(void)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	83 ec 1c             	sub    $0x1c,%esp
  struct rtcdate *d;
  if(argptr(0, (void*) &d, sizeof(struct rtcdate)) < 0)
80105846:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105849:	6a 18                	push   $0x18
8010584b:	50                   	push   %eax
8010584c:	6a 00                	push   $0x0
8010584e:	e8 fd f1 ff ff       	call   80104a50 <argptr>
80105853:	83 c4 10             	add    $0x10,%esp
80105856:	85 c0                	test   %eax,%eax
80105858:	78 16                	js     80105870 <sys_date+0x30>
  {
    return -1;
  }  
  cmostime(d);
8010585a:	83 ec 0c             	sub    $0xc,%esp
8010585d:	ff 75 f4             	pushl  -0xc(%ebp)
80105860:	e8 bb d0 ff ff       	call   80102920 <cmostime>
  return 0;
80105865:	83 c4 10             	add    $0x10,%esp
80105868:	31 c0                	xor    %eax,%eax
}
8010586a:	c9                   	leave  
8010586b:	c3                   	ret    
8010586c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105870:	c9                   	leave  
    return -1;
80105871:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105876:	c3                   	ret    
80105877:	89 f6                	mov    %esi,%esi
80105879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105880 <sys_sleep>:

int
sys_sleep(void)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105884:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105887:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010588a:	50                   	push   %eax
8010588b:	6a 00                	push   $0x0
8010588d:	e8 6e f1 ff ff       	call   80104a00 <argint>
80105892:	83 c4 10             	add    $0x10,%esp
80105895:	85 c0                	test   %eax,%eax
80105897:	0f 88 8a 00 00 00    	js     80105927 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010589d:	83 ec 0c             	sub    $0xc,%esp
801058a0:	68 60 4d 11 80       	push   $0x80114d60
801058a5:	e8 16 ed ff ff       	call   801045c0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801058aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801058ad:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  while(ticks - ticks0 < n){
801058b3:	83 c4 10             	add    $0x10,%esp
801058b6:	85 d2                	test   %edx,%edx
801058b8:	75 27                	jne    801058e1 <sys_sleep+0x61>
801058ba:	eb 54                	jmp    80105910 <sys_sleep+0x90>
801058bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801058c0:	83 ec 08             	sub    $0x8,%esp
801058c3:	68 60 4d 11 80       	push   $0x80114d60
801058c8:	68 a0 55 11 80       	push   $0x801155a0
801058cd:	e8 ee e5 ff ff       	call   80103ec0 <sleep>
  while(ticks - ticks0 < n){
801058d2:	a1 a0 55 11 80       	mov    0x801155a0,%eax
801058d7:	83 c4 10             	add    $0x10,%esp
801058da:	29 d8                	sub    %ebx,%eax
801058dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801058df:	73 2f                	jae    80105910 <sys_sleep+0x90>
    if(myproc()->killed){
801058e1:	e8 1a e0 ff ff       	call   80103900 <myproc>
801058e6:	8b 40 24             	mov    0x24(%eax),%eax
801058e9:	85 c0                	test   %eax,%eax
801058eb:	74 d3                	je     801058c0 <sys_sleep+0x40>
      release(&tickslock);
801058ed:	83 ec 0c             	sub    $0xc,%esp
801058f0:	68 60 4d 11 80       	push   $0x80114d60
801058f5:	e8 e6 ed ff ff       	call   801046e0 <release>
      return -1;
801058fa:	83 c4 10             	add    $0x10,%esp
801058fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105902:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105905:	c9                   	leave  
80105906:	c3                   	ret    
80105907:	89 f6                	mov    %esi,%esi
80105909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105910:	83 ec 0c             	sub    $0xc,%esp
80105913:	68 60 4d 11 80       	push   $0x80114d60
80105918:	e8 c3 ed ff ff       	call   801046e0 <release>
  return 0;
8010591d:	83 c4 10             	add    $0x10,%esp
80105920:	31 c0                	xor    %eax,%eax
}
80105922:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105925:	c9                   	leave  
80105926:	c3                   	ret    
    return -1;
80105927:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010592c:	eb f4                	jmp    80105922 <sys_sleep+0xa2>
8010592e:	66 90                	xchg   %ax,%ax

80105930 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	53                   	push   %ebx
80105934:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105937:	68 60 4d 11 80       	push   $0x80114d60
8010593c:	e8 7f ec ff ff       	call   801045c0 <acquire>
  xticks = ticks;
80105941:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  release(&tickslock);
80105947:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
8010594e:	e8 8d ed ff ff       	call   801046e0 <release>
  return xticks;
}
80105953:	89 d8                	mov    %ebx,%eax
80105955:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105958:	c9                   	leave  
80105959:	c3                   	ret    

8010595a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010595a:	1e                   	push   %ds
  pushl %es
8010595b:	06                   	push   %es
  pushl %fs
8010595c:	0f a0                	push   %fs
  pushl %gs
8010595e:	0f a8                	push   %gs
  pushal
80105960:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105961:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105965:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105967:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105969:	54                   	push   %esp
  call trap
8010596a:	e8 c1 00 00 00       	call   80105a30 <trap>
  addl $4, %esp
8010596f:	83 c4 04             	add    $0x4,%esp

80105972 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105972:	61                   	popa   
  popl %gs
80105973:	0f a9                	pop    %gs
  popl %fs
80105975:	0f a1                	pop    %fs
  popl %es
80105977:	07                   	pop    %es
  popl %ds
80105978:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105979:	83 c4 08             	add    $0x8,%esp
  iret
8010597c:	cf                   	iret   
8010597d:	66 90                	xchg   %ax,%ax
8010597f:	90                   	nop

80105980 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105980:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105981:	31 c0                	xor    %eax,%eax
{
80105983:	89 e5                	mov    %esp,%ebp
80105985:	83 ec 08             	sub    $0x8,%esp
80105988:	90                   	nop
80105989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105990:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105997:	c7 04 c5 a2 4d 11 80 	movl   $0x8e000008,-0x7feeb25e(,%eax,8)
8010599e:	08 00 00 8e 
801059a2:	66 89 14 c5 a0 4d 11 	mov    %dx,-0x7feeb260(,%eax,8)
801059a9:	80 
801059aa:	c1 ea 10             	shr    $0x10,%edx
801059ad:	66 89 14 c5 a6 4d 11 	mov    %dx,-0x7feeb25a(,%eax,8)
801059b4:	80 
  for(i = 0; i < 256; i++)
801059b5:	83 c0 01             	add    $0x1,%eax
801059b8:	3d 00 01 00 00       	cmp    $0x100,%eax
801059bd:	75 d1                	jne    80105990 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801059bf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801059c2:	a1 08 a1 10 80       	mov    0x8010a108,%eax
801059c7:	c7 05 a2 4f 11 80 08 	movl   $0xef000008,0x80114fa2
801059ce:	00 00 ef 
  initlock(&tickslock, "time");
801059d1:	68 29 7a 10 80       	push   $0x80107a29
801059d6:	68 60 4d 11 80       	push   $0x80114d60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801059db:	66 a3 a0 4f 11 80    	mov    %ax,0x80114fa0
801059e1:	c1 e8 10             	shr    $0x10,%eax
801059e4:	66 a3 a6 4f 11 80    	mov    %ax,0x80114fa6
  initlock(&tickslock, "time");
801059ea:	e8 d1 ea ff ff       	call   801044c0 <initlock>
}
801059ef:	83 c4 10             	add    $0x10,%esp
801059f2:	c9                   	leave  
801059f3:	c3                   	ret    
801059f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801059fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105a00 <idtinit>:

void
idtinit(void)
{
80105a00:	55                   	push   %ebp
  pd[0] = size-1;
80105a01:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105a06:	89 e5                	mov    %esp,%ebp
80105a08:	83 ec 10             	sub    $0x10,%esp
80105a0b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105a0f:	b8 a0 4d 11 80       	mov    $0x80114da0,%eax
80105a14:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105a18:	c1 e8 10             	shr    $0x10,%eax
80105a1b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105a1f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105a22:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105a25:	c9                   	leave  
80105a26:	c3                   	ret    
80105a27:	89 f6                	mov    %esi,%esi
80105a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a30 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	57                   	push   %edi
80105a34:	56                   	push   %esi
80105a35:	53                   	push   %ebx
80105a36:	83 ec 1c             	sub    $0x1c,%esp
80105a39:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105a3c:	8b 47 30             	mov    0x30(%edi),%eax
80105a3f:	83 f8 40             	cmp    $0x40,%eax
80105a42:	0f 84 b8 01 00 00    	je     80105c00 <trap+0x1d0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105a48:	83 e8 20             	sub    $0x20,%eax
80105a4b:	83 f8 1f             	cmp    $0x1f,%eax
80105a4e:	77 10                	ja     80105a60 <trap+0x30>
80105a50:	ff 24 85 d0 7a 10 80 	jmp    *-0x7fef8530(,%eax,4)
80105a57:	89 f6                	mov    %esi,%esi
80105a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105a60:	e8 9b de ff ff       	call   80103900 <myproc>
80105a65:	8b 5f 38             	mov    0x38(%edi),%ebx
80105a68:	85 c0                	test   %eax,%eax
80105a6a:	0f 84 17 02 00 00    	je     80105c87 <trap+0x257>
80105a70:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105a74:	0f 84 0d 02 00 00    	je     80105c87 <trap+0x257>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105a7a:	0f 20 d1             	mov    %cr2,%ecx
80105a7d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a80:	e8 5b de ff ff       	call   801038e0 <cpuid>
80105a85:	8b 77 30             	mov    0x30(%edi),%esi
80105a88:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105a8b:	8b 47 34             	mov    0x34(%edi),%eax
80105a8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105a91:	e8 6a de ff ff       	call   80103900 <myproc>
80105a96:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105a99:	e8 62 de ff ff       	call   80103900 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a9e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105aa1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105aa4:	51                   	push   %ecx
80105aa5:	53                   	push   %ebx
80105aa6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105aa7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105aaa:	ff 75 e4             	pushl  -0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105aad:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ab0:	56                   	push   %esi
80105ab1:	52                   	push   %edx
80105ab2:	ff 70 10             	pushl  0x10(%eax)
80105ab5:	68 8c 7a 10 80       	push   $0x80107a8c
80105aba:	e8 f1 ab ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105abf:	83 c4 20             	add    $0x20,%esp
80105ac2:	e8 39 de ff ff       	call   80103900 <myproc>
80105ac7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ace:	e8 2d de ff ff       	call   80103900 <myproc>
80105ad3:	85 c0                	test   %eax,%eax
80105ad5:	74 1d                	je     80105af4 <trap+0xc4>
80105ad7:	e8 24 de ff ff       	call   80103900 <myproc>
80105adc:	8b 50 24             	mov    0x24(%eax),%edx
80105adf:	85 d2                	test   %edx,%edx
80105ae1:	74 11                	je     80105af4 <trap+0xc4>
80105ae3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105ae7:	83 e0 03             	and    $0x3,%eax
80105aea:	66 83 f8 03          	cmp    $0x3,%ax
80105aee:	0f 84 44 01 00 00    	je     80105c38 <trap+0x208>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105af4:	e8 07 de ff ff       	call   80103900 <myproc>
80105af9:	85 c0                	test   %eax,%eax
80105afb:	74 0b                	je     80105b08 <trap+0xd8>
80105afd:	e8 fe dd ff ff       	call   80103900 <myproc>
80105b02:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105b06:	74 38                	je     80105b40 <trap+0x110>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b08:	e8 f3 dd ff ff       	call   80103900 <myproc>
80105b0d:	85 c0                	test   %eax,%eax
80105b0f:	74 1d                	je     80105b2e <trap+0xfe>
80105b11:	e8 ea dd ff ff       	call   80103900 <myproc>
80105b16:	8b 40 24             	mov    0x24(%eax),%eax
80105b19:	85 c0                	test   %eax,%eax
80105b1b:	74 11                	je     80105b2e <trap+0xfe>
80105b1d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105b21:	83 e0 03             	and    $0x3,%eax
80105b24:	66 83 f8 03          	cmp    $0x3,%ax
80105b28:	0f 84 fb 00 00 00    	je     80105c29 <trap+0x1f9>
    exit();
}
80105b2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b31:	5b                   	pop    %ebx
80105b32:	5e                   	pop    %esi
80105b33:	5f                   	pop    %edi
80105b34:	5d                   	pop    %ebp
80105b35:	c3                   	ret    
80105b36:	8d 76 00             	lea    0x0(%esi),%esi
80105b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(myproc() && myproc()->state == RUNNING &&
80105b40:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105b44:	75 c2                	jne    80105b08 <trap+0xd8>
    yield();
80105b46:	e8 25 e3 ff ff       	call   80103e70 <yield>
80105b4b:	eb bb                	jmp    80105b08 <trap+0xd8>
80105b4d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105b50:	e8 8b dd ff ff       	call   801038e0 <cpuid>
80105b55:	85 c0                	test   %eax,%eax
80105b57:	0f 84 eb 00 00 00    	je     80105c48 <trap+0x218>
    lapiceoi();
80105b5d:	e8 fe cc ff ff       	call   80102860 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b62:	e8 99 dd ff ff       	call   80103900 <myproc>
80105b67:	85 c0                	test   %eax,%eax
80105b69:	0f 85 68 ff ff ff    	jne    80105ad7 <trap+0xa7>
80105b6f:	eb 83                	jmp    80105af4 <trap+0xc4>
80105b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105b78:	e8 a3 cb ff ff       	call   80102720 <kbdintr>
    lapiceoi();
80105b7d:	e8 de cc ff ff       	call   80102860 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b82:	e8 79 dd ff ff       	call   80103900 <myproc>
80105b87:	85 c0                	test   %eax,%eax
80105b89:	0f 85 48 ff ff ff    	jne    80105ad7 <trap+0xa7>
80105b8f:	e9 60 ff ff ff       	jmp    80105af4 <trap+0xc4>
80105b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105b98:	e8 83 02 00 00       	call   80105e20 <uartintr>
    lapiceoi();
80105b9d:	e8 be cc ff ff       	call   80102860 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ba2:	e8 59 dd ff ff       	call   80103900 <myproc>
80105ba7:	85 c0                	test   %eax,%eax
80105ba9:	0f 85 28 ff ff ff    	jne    80105ad7 <trap+0xa7>
80105baf:	e9 40 ff ff ff       	jmp    80105af4 <trap+0xc4>
80105bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105bb8:	8b 77 38             	mov    0x38(%edi),%esi
80105bbb:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105bbf:	e8 1c dd ff ff       	call   801038e0 <cpuid>
80105bc4:	56                   	push   %esi
80105bc5:	53                   	push   %ebx
80105bc6:	50                   	push   %eax
80105bc7:	68 34 7a 10 80       	push   $0x80107a34
80105bcc:	e8 df aa ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105bd1:	e8 8a cc ff ff       	call   80102860 <lapiceoi>
    break;
80105bd6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bd9:	e8 22 dd ff ff       	call   80103900 <myproc>
80105bde:	85 c0                	test   %eax,%eax
80105be0:	0f 85 f1 fe ff ff    	jne    80105ad7 <trap+0xa7>
80105be6:	e9 09 ff ff ff       	jmp    80105af4 <trap+0xc4>
80105beb:	90                   	nop
80105bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105bf0:	e8 7b c5 ff ff       	call   80102170 <ideintr>
80105bf5:	e9 63 ff ff ff       	jmp    80105b5d <trap+0x12d>
80105bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105c00:	e8 fb dc ff ff       	call   80103900 <myproc>
80105c05:	8b 58 24             	mov    0x24(%eax),%ebx
80105c08:	85 db                	test   %ebx,%ebx
80105c0a:	75 74                	jne    80105c80 <trap+0x250>
    myproc()->tf = tf;
80105c0c:	e8 ef dc ff ff       	call   80103900 <myproc>
80105c11:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105c14:	e8 d7 ee ff ff       	call   80104af0 <syscall>
    if(myproc()->killed)
80105c19:	e8 e2 dc ff ff       	call   80103900 <myproc>
80105c1e:	8b 48 24             	mov    0x24(%eax),%ecx
80105c21:	85 c9                	test   %ecx,%ecx
80105c23:	0f 84 05 ff ff ff    	je     80105b2e <trap+0xfe>
}
80105c29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c2c:	5b                   	pop    %ebx
80105c2d:	5e                   	pop    %esi
80105c2e:	5f                   	pop    %edi
80105c2f:	5d                   	pop    %ebp
      exit();
80105c30:	e9 0b e1 ff ff       	jmp    80103d40 <exit>
80105c35:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80105c38:	e8 03 e1 ff ff       	call   80103d40 <exit>
80105c3d:	e9 b2 fe ff ff       	jmp    80105af4 <trap+0xc4>
80105c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105c48:	83 ec 0c             	sub    $0xc,%esp
80105c4b:	68 60 4d 11 80       	push   $0x80114d60
80105c50:	e8 6b e9 ff ff       	call   801045c0 <acquire>
      wakeup(&ticks);
80105c55:	c7 04 24 a0 55 11 80 	movl   $0x801155a0,(%esp)
      ticks++;
80105c5c:	83 05 a0 55 11 80 01 	addl   $0x1,0x801155a0
      wakeup(&ticks);
80105c63:	e8 08 e4 ff ff       	call   80104070 <wakeup>
      release(&tickslock);
80105c68:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105c6f:	e8 6c ea ff ff       	call   801046e0 <release>
80105c74:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105c77:	e9 e1 fe ff ff       	jmp    80105b5d <trap+0x12d>
80105c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      exit();
80105c80:	e8 bb e0 ff ff       	call   80103d40 <exit>
80105c85:	eb 85                	jmp    80105c0c <trap+0x1dc>
80105c87:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105c8a:	e8 51 dc ff ff       	call   801038e0 <cpuid>
80105c8f:	83 ec 0c             	sub    $0xc,%esp
80105c92:	56                   	push   %esi
80105c93:	53                   	push   %ebx
80105c94:	50                   	push   %eax
80105c95:	ff 77 30             	pushl  0x30(%edi)
80105c98:	68 58 7a 10 80       	push   $0x80107a58
80105c9d:	e8 0e aa ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105ca2:	83 c4 14             	add    $0x14,%esp
80105ca5:	68 2e 7a 10 80       	push   $0x80107a2e
80105caa:	e8 e1 a6 ff ff       	call   80100390 <panic>
80105caf:	90                   	nop

80105cb0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105cb0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105cb5:	85 c0                	test   %eax,%eax
80105cb7:	74 17                	je     80105cd0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105cb9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105cbe:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105cbf:	a8 01                	test   $0x1,%al
80105cc1:	74 0d                	je     80105cd0 <uartgetc+0x20>
80105cc3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cc8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105cc9:	0f b6 c0             	movzbl %al,%eax
80105ccc:	c3                   	ret    
80105ccd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105cd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cd5:	c3                   	ret    
80105cd6:	8d 76 00             	lea    0x0(%esi),%esi
80105cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ce0 <uartputc.part.0>:
uartputc(int c)
80105ce0:	55                   	push   %ebp
80105ce1:	89 e5                	mov    %esp,%ebp
80105ce3:	57                   	push   %edi
80105ce4:	89 c7                	mov    %eax,%edi
80105ce6:	56                   	push   %esi
80105ce7:	be fd 03 00 00       	mov    $0x3fd,%esi
80105cec:	53                   	push   %ebx
80105ced:	bb 80 00 00 00       	mov    $0x80,%ebx
80105cf2:	83 ec 0c             	sub    $0xc,%esp
80105cf5:	eb 1b                	jmp    80105d12 <uartputc.part.0+0x32>
80105cf7:	89 f6                	mov    %esi,%esi
80105cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105d00:	83 ec 0c             	sub    $0xc,%esp
80105d03:	6a 0a                	push   $0xa
80105d05:	e8 76 cb ff ff       	call   80102880 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105d0a:	83 c4 10             	add    $0x10,%esp
80105d0d:	83 eb 01             	sub    $0x1,%ebx
80105d10:	74 07                	je     80105d19 <uartputc.part.0+0x39>
80105d12:	89 f2                	mov    %esi,%edx
80105d14:	ec                   	in     (%dx),%al
80105d15:	a8 20                	test   $0x20,%al
80105d17:	74 e7                	je     80105d00 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105d19:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d1e:	89 f8                	mov    %edi,%eax
80105d20:	ee                   	out    %al,(%dx)
}
80105d21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d24:	5b                   	pop    %ebx
80105d25:	5e                   	pop    %esi
80105d26:	5f                   	pop    %edi
80105d27:	5d                   	pop    %ebp
80105d28:	c3                   	ret    
80105d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d30 <uartinit>:
{
80105d30:	55                   	push   %ebp
80105d31:	31 c9                	xor    %ecx,%ecx
80105d33:	89 c8                	mov    %ecx,%eax
80105d35:	89 e5                	mov    %esp,%ebp
80105d37:	57                   	push   %edi
80105d38:	56                   	push   %esi
80105d39:	53                   	push   %ebx
80105d3a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105d3f:	89 da                	mov    %ebx,%edx
80105d41:	83 ec 0c             	sub    $0xc,%esp
80105d44:	ee                   	out    %al,(%dx)
80105d45:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105d4a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105d4f:	89 fa                	mov    %edi,%edx
80105d51:	ee                   	out    %al,(%dx)
80105d52:	b8 0c 00 00 00       	mov    $0xc,%eax
80105d57:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d5c:	ee                   	out    %al,(%dx)
80105d5d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105d62:	89 c8                	mov    %ecx,%eax
80105d64:	89 f2                	mov    %esi,%edx
80105d66:	ee                   	out    %al,(%dx)
80105d67:	b8 03 00 00 00       	mov    $0x3,%eax
80105d6c:	89 fa                	mov    %edi,%edx
80105d6e:	ee                   	out    %al,(%dx)
80105d6f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105d74:	89 c8                	mov    %ecx,%eax
80105d76:	ee                   	out    %al,(%dx)
80105d77:	b8 01 00 00 00       	mov    $0x1,%eax
80105d7c:	89 f2                	mov    %esi,%edx
80105d7e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d7f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d84:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105d85:	3c ff                	cmp    $0xff,%al
80105d87:	74 56                	je     80105ddf <uartinit+0xaf>
  uart = 1;
80105d89:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105d90:	00 00 00 
80105d93:	89 da                	mov    %ebx,%edx
80105d95:	ec                   	in     (%dx),%al
80105d96:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d9b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105d9c:	83 ec 08             	sub    $0x8,%esp
80105d9f:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80105da4:	bb 50 7b 10 80       	mov    $0x80107b50,%ebx
  ioapicenable(IRQ_COM1, 0);
80105da9:	6a 00                	push   $0x0
80105dab:	6a 04                	push   $0x4
80105dad:	e8 0e c6 ff ff       	call   801023c0 <ioapicenable>
80105db2:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105db5:	b8 78 00 00 00       	mov    $0x78,%eax
80105dba:	eb 08                	jmp    80105dc4 <uartinit+0x94>
80105dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105dc0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80105dc4:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105dca:	85 d2                	test   %edx,%edx
80105dcc:	74 08                	je     80105dd6 <uartinit+0xa6>
    uartputc(*p);
80105dce:	0f be c0             	movsbl %al,%eax
80105dd1:	e8 0a ff ff ff       	call   80105ce0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80105dd6:	89 f0                	mov    %esi,%eax
80105dd8:	83 c3 01             	add    $0x1,%ebx
80105ddb:	84 c0                	test   %al,%al
80105ddd:	75 e1                	jne    80105dc0 <uartinit+0x90>
}
80105ddf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105de2:	5b                   	pop    %ebx
80105de3:	5e                   	pop    %esi
80105de4:	5f                   	pop    %edi
80105de5:	5d                   	pop    %ebp
80105de6:	c3                   	ret    
80105de7:	89 f6                	mov    %esi,%esi
80105de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105df0 <uartputc>:
{
80105df0:	55                   	push   %ebp
  if(!uart)
80105df1:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105df7:	89 e5                	mov    %esp,%ebp
80105df9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105dfc:	85 d2                	test   %edx,%edx
80105dfe:	74 10                	je     80105e10 <uartputc+0x20>
}
80105e00:	5d                   	pop    %ebp
80105e01:	e9 da fe ff ff       	jmp    80105ce0 <uartputc.part.0>
80105e06:	8d 76 00             	lea    0x0(%esi),%esi
80105e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105e10:	5d                   	pop    %ebp
80105e11:	c3                   	ret    
80105e12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e20 <uartintr>:

void
uartintr(void)
{
80105e20:	55                   	push   %ebp
80105e21:	89 e5                	mov    %esp,%ebp
80105e23:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105e26:	68 b0 5c 10 80       	push   $0x80105cb0
80105e2b:	e8 30 aa ff ff       	call   80100860 <consoleintr>
}
80105e30:	83 c4 10             	add    $0x10,%esp
80105e33:	c9                   	leave  
80105e34:	c3                   	ret    

80105e35 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105e35:	6a 00                	push   $0x0
  pushl $0
80105e37:	6a 00                	push   $0x0
  jmp alltraps
80105e39:	e9 1c fb ff ff       	jmp    8010595a <alltraps>

80105e3e <vector1>:
.globl vector1
vector1:
  pushl $0
80105e3e:	6a 00                	push   $0x0
  pushl $1
80105e40:	6a 01                	push   $0x1
  jmp alltraps
80105e42:	e9 13 fb ff ff       	jmp    8010595a <alltraps>

80105e47 <vector2>:
.globl vector2
vector2:
  pushl $0
80105e47:	6a 00                	push   $0x0
  pushl $2
80105e49:	6a 02                	push   $0x2
  jmp alltraps
80105e4b:	e9 0a fb ff ff       	jmp    8010595a <alltraps>

80105e50 <vector3>:
.globl vector3
vector3:
  pushl $0
80105e50:	6a 00                	push   $0x0
  pushl $3
80105e52:	6a 03                	push   $0x3
  jmp alltraps
80105e54:	e9 01 fb ff ff       	jmp    8010595a <alltraps>

80105e59 <vector4>:
.globl vector4
vector4:
  pushl $0
80105e59:	6a 00                	push   $0x0
  pushl $4
80105e5b:	6a 04                	push   $0x4
  jmp alltraps
80105e5d:	e9 f8 fa ff ff       	jmp    8010595a <alltraps>

80105e62 <vector5>:
.globl vector5
vector5:
  pushl $0
80105e62:	6a 00                	push   $0x0
  pushl $5
80105e64:	6a 05                	push   $0x5
  jmp alltraps
80105e66:	e9 ef fa ff ff       	jmp    8010595a <alltraps>

80105e6b <vector6>:
.globl vector6
vector6:
  pushl $0
80105e6b:	6a 00                	push   $0x0
  pushl $6
80105e6d:	6a 06                	push   $0x6
  jmp alltraps
80105e6f:	e9 e6 fa ff ff       	jmp    8010595a <alltraps>

80105e74 <vector7>:
.globl vector7
vector7:
  pushl $0
80105e74:	6a 00                	push   $0x0
  pushl $7
80105e76:	6a 07                	push   $0x7
  jmp alltraps
80105e78:	e9 dd fa ff ff       	jmp    8010595a <alltraps>

80105e7d <vector8>:
.globl vector8
vector8:
  pushl $8
80105e7d:	6a 08                	push   $0x8
  jmp alltraps
80105e7f:	e9 d6 fa ff ff       	jmp    8010595a <alltraps>

80105e84 <vector9>:
.globl vector9
vector9:
  pushl $0
80105e84:	6a 00                	push   $0x0
  pushl $9
80105e86:	6a 09                	push   $0x9
  jmp alltraps
80105e88:	e9 cd fa ff ff       	jmp    8010595a <alltraps>

80105e8d <vector10>:
.globl vector10
vector10:
  pushl $10
80105e8d:	6a 0a                	push   $0xa
  jmp alltraps
80105e8f:	e9 c6 fa ff ff       	jmp    8010595a <alltraps>

80105e94 <vector11>:
.globl vector11
vector11:
  pushl $11
80105e94:	6a 0b                	push   $0xb
  jmp alltraps
80105e96:	e9 bf fa ff ff       	jmp    8010595a <alltraps>

80105e9b <vector12>:
.globl vector12
vector12:
  pushl $12
80105e9b:	6a 0c                	push   $0xc
  jmp alltraps
80105e9d:	e9 b8 fa ff ff       	jmp    8010595a <alltraps>

80105ea2 <vector13>:
.globl vector13
vector13:
  pushl $13
80105ea2:	6a 0d                	push   $0xd
  jmp alltraps
80105ea4:	e9 b1 fa ff ff       	jmp    8010595a <alltraps>

80105ea9 <vector14>:
.globl vector14
vector14:
  pushl $14
80105ea9:	6a 0e                	push   $0xe
  jmp alltraps
80105eab:	e9 aa fa ff ff       	jmp    8010595a <alltraps>

80105eb0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105eb0:	6a 00                	push   $0x0
  pushl $15
80105eb2:	6a 0f                	push   $0xf
  jmp alltraps
80105eb4:	e9 a1 fa ff ff       	jmp    8010595a <alltraps>

80105eb9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105eb9:	6a 00                	push   $0x0
  pushl $16
80105ebb:	6a 10                	push   $0x10
  jmp alltraps
80105ebd:	e9 98 fa ff ff       	jmp    8010595a <alltraps>

80105ec2 <vector17>:
.globl vector17
vector17:
  pushl $17
80105ec2:	6a 11                	push   $0x11
  jmp alltraps
80105ec4:	e9 91 fa ff ff       	jmp    8010595a <alltraps>

80105ec9 <vector18>:
.globl vector18
vector18:
  pushl $0
80105ec9:	6a 00                	push   $0x0
  pushl $18
80105ecb:	6a 12                	push   $0x12
  jmp alltraps
80105ecd:	e9 88 fa ff ff       	jmp    8010595a <alltraps>

80105ed2 <vector19>:
.globl vector19
vector19:
  pushl $0
80105ed2:	6a 00                	push   $0x0
  pushl $19
80105ed4:	6a 13                	push   $0x13
  jmp alltraps
80105ed6:	e9 7f fa ff ff       	jmp    8010595a <alltraps>

80105edb <vector20>:
.globl vector20
vector20:
  pushl $0
80105edb:	6a 00                	push   $0x0
  pushl $20
80105edd:	6a 14                	push   $0x14
  jmp alltraps
80105edf:	e9 76 fa ff ff       	jmp    8010595a <alltraps>

80105ee4 <vector21>:
.globl vector21
vector21:
  pushl $0
80105ee4:	6a 00                	push   $0x0
  pushl $21
80105ee6:	6a 15                	push   $0x15
  jmp alltraps
80105ee8:	e9 6d fa ff ff       	jmp    8010595a <alltraps>

80105eed <vector22>:
.globl vector22
vector22:
  pushl $0
80105eed:	6a 00                	push   $0x0
  pushl $22
80105eef:	6a 16                	push   $0x16
  jmp alltraps
80105ef1:	e9 64 fa ff ff       	jmp    8010595a <alltraps>

80105ef6 <vector23>:
.globl vector23
vector23:
  pushl $0
80105ef6:	6a 00                	push   $0x0
  pushl $23
80105ef8:	6a 17                	push   $0x17
  jmp alltraps
80105efa:	e9 5b fa ff ff       	jmp    8010595a <alltraps>

80105eff <vector24>:
.globl vector24
vector24:
  pushl $0
80105eff:	6a 00                	push   $0x0
  pushl $24
80105f01:	6a 18                	push   $0x18
  jmp alltraps
80105f03:	e9 52 fa ff ff       	jmp    8010595a <alltraps>

80105f08 <vector25>:
.globl vector25
vector25:
  pushl $0
80105f08:	6a 00                	push   $0x0
  pushl $25
80105f0a:	6a 19                	push   $0x19
  jmp alltraps
80105f0c:	e9 49 fa ff ff       	jmp    8010595a <alltraps>

80105f11 <vector26>:
.globl vector26
vector26:
  pushl $0
80105f11:	6a 00                	push   $0x0
  pushl $26
80105f13:	6a 1a                	push   $0x1a
  jmp alltraps
80105f15:	e9 40 fa ff ff       	jmp    8010595a <alltraps>

80105f1a <vector27>:
.globl vector27
vector27:
  pushl $0
80105f1a:	6a 00                	push   $0x0
  pushl $27
80105f1c:	6a 1b                	push   $0x1b
  jmp alltraps
80105f1e:	e9 37 fa ff ff       	jmp    8010595a <alltraps>

80105f23 <vector28>:
.globl vector28
vector28:
  pushl $0
80105f23:	6a 00                	push   $0x0
  pushl $28
80105f25:	6a 1c                	push   $0x1c
  jmp alltraps
80105f27:	e9 2e fa ff ff       	jmp    8010595a <alltraps>

80105f2c <vector29>:
.globl vector29
vector29:
  pushl $0
80105f2c:	6a 00                	push   $0x0
  pushl $29
80105f2e:	6a 1d                	push   $0x1d
  jmp alltraps
80105f30:	e9 25 fa ff ff       	jmp    8010595a <alltraps>

80105f35 <vector30>:
.globl vector30
vector30:
  pushl $0
80105f35:	6a 00                	push   $0x0
  pushl $30
80105f37:	6a 1e                	push   $0x1e
  jmp alltraps
80105f39:	e9 1c fa ff ff       	jmp    8010595a <alltraps>

80105f3e <vector31>:
.globl vector31
vector31:
  pushl $0
80105f3e:	6a 00                	push   $0x0
  pushl $31
80105f40:	6a 1f                	push   $0x1f
  jmp alltraps
80105f42:	e9 13 fa ff ff       	jmp    8010595a <alltraps>

80105f47 <vector32>:
.globl vector32
vector32:
  pushl $0
80105f47:	6a 00                	push   $0x0
  pushl $32
80105f49:	6a 20                	push   $0x20
  jmp alltraps
80105f4b:	e9 0a fa ff ff       	jmp    8010595a <alltraps>

80105f50 <vector33>:
.globl vector33
vector33:
  pushl $0
80105f50:	6a 00                	push   $0x0
  pushl $33
80105f52:	6a 21                	push   $0x21
  jmp alltraps
80105f54:	e9 01 fa ff ff       	jmp    8010595a <alltraps>

80105f59 <vector34>:
.globl vector34
vector34:
  pushl $0
80105f59:	6a 00                	push   $0x0
  pushl $34
80105f5b:	6a 22                	push   $0x22
  jmp alltraps
80105f5d:	e9 f8 f9 ff ff       	jmp    8010595a <alltraps>

80105f62 <vector35>:
.globl vector35
vector35:
  pushl $0
80105f62:	6a 00                	push   $0x0
  pushl $35
80105f64:	6a 23                	push   $0x23
  jmp alltraps
80105f66:	e9 ef f9 ff ff       	jmp    8010595a <alltraps>

80105f6b <vector36>:
.globl vector36
vector36:
  pushl $0
80105f6b:	6a 00                	push   $0x0
  pushl $36
80105f6d:	6a 24                	push   $0x24
  jmp alltraps
80105f6f:	e9 e6 f9 ff ff       	jmp    8010595a <alltraps>

80105f74 <vector37>:
.globl vector37
vector37:
  pushl $0
80105f74:	6a 00                	push   $0x0
  pushl $37
80105f76:	6a 25                	push   $0x25
  jmp alltraps
80105f78:	e9 dd f9 ff ff       	jmp    8010595a <alltraps>

80105f7d <vector38>:
.globl vector38
vector38:
  pushl $0
80105f7d:	6a 00                	push   $0x0
  pushl $38
80105f7f:	6a 26                	push   $0x26
  jmp alltraps
80105f81:	e9 d4 f9 ff ff       	jmp    8010595a <alltraps>

80105f86 <vector39>:
.globl vector39
vector39:
  pushl $0
80105f86:	6a 00                	push   $0x0
  pushl $39
80105f88:	6a 27                	push   $0x27
  jmp alltraps
80105f8a:	e9 cb f9 ff ff       	jmp    8010595a <alltraps>

80105f8f <vector40>:
.globl vector40
vector40:
  pushl $0
80105f8f:	6a 00                	push   $0x0
  pushl $40
80105f91:	6a 28                	push   $0x28
  jmp alltraps
80105f93:	e9 c2 f9 ff ff       	jmp    8010595a <alltraps>

80105f98 <vector41>:
.globl vector41
vector41:
  pushl $0
80105f98:	6a 00                	push   $0x0
  pushl $41
80105f9a:	6a 29                	push   $0x29
  jmp alltraps
80105f9c:	e9 b9 f9 ff ff       	jmp    8010595a <alltraps>

80105fa1 <vector42>:
.globl vector42
vector42:
  pushl $0
80105fa1:	6a 00                	push   $0x0
  pushl $42
80105fa3:	6a 2a                	push   $0x2a
  jmp alltraps
80105fa5:	e9 b0 f9 ff ff       	jmp    8010595a <alltraps>

80105faa <vector43>:
.globl vector43
vector43:
  pushl $0
80105faa:	6a 00                	push   $0x0
  pushl $43
80105fac:	6a 2b                	push   $0x2b
  jmp alltraps
80105fae:	e9 a7 f9 ff ff       	jmp    8010595a <alltraps>

80105fb3 <vector44>:
.globl vector44
vector44:
  pushl $0
80105fb3:	6a 00                	push   $0x0
  pushl $44
80105fb5:	6a 2c                	push   $0x2c
  jmp alltraps
80105fb7:	e9 9e f9 ff ff       	jmp    8010595a <alltraps>

80105fbc <vector45>:
.globl vector45
vector45:
  pushl $0
80105fbc:	6a 00                	push   $0x0
  pushl $45
80105fbe:	6a 2d                	push   $0x2d
  jmp alltraps
80105fc0:	e9 95 f9 ff ff       	jmp    8010595a <alltraps>

80105fc5 <vector46>:
.globl vector46
vector46:
  pushl $0
80105fc5:	6a 00                	push   $0x0
  pushl $46
80105fc7:	6a 2e                	push   $0x2e
  jmp alltraps
80105fc9:	e9 8c f9 ff ff       	jmp    8010595a <alltraps>

80105fce <vector47>:
.globl vector47
vector47:
  pushl $0
80105fce:	6a 00                	push   $0x0
  pushl $47
80105fd0:	6a 2f                	push   $0x2f
  jmp alltraps
80105fd2:	e9 83 f9 ff ff       	jmp    8010595a <alltraps>

80105fd7 <vector48>:
.globl vector48
vector48:
  pushl $0
80105fd7:	6a 00                	push   $0x0
  pushl $48
80105fd9:	6a 30                	push   $0x30
  jmp alltraps
80105fdb:	e9 7a f9 ff ff       	jmp    8010595a <alltraps>

80105fe0 <vector49>:
.globl vector49
vector49:
  pushl $0
80105fe0:	6a 00                	push   $0x0
  pushl $49
80105fe2:	6a 31                	push   $0x31
  jmp alltraps
80105fe4:	e9 71 f9 ff ff       	jmp    8010595a <alltraps>

80105fe9 <vector50>:
.globl vector50
vector50:
  pushl $0
80105fe9:	6a 00                	push   $0x0
  pushl $50
80105feb:	6a 32                	push   $0x32
  jmp alltraps
80105fed:	e9 68 f9 ff ff       	jmp    8010595a <alltraps>

80105ff2 <vector51>:
.globl vector51
vector51:
  pushl $0
80105ff2:	6a 00                	push   $0x0
  pushl $51
80105ff4:	6a 33                	push   $0x33
  jmp alltraps
80105ff6:	e9 5f f9 ff ff       	jmp    8010595a <alltraps>

80105ffb <vector52>:
.globl vector52
vector52:
  pushl $0
80105ffb:	6a 00                	push   $0x0
  pushl $52
80105ffd:	6a 34                	push   $0x34
  jmp alltraps
80105fff:	e9 56 f9 ff ff       	jmp    8010595a <alltraps>

80106004 <vector53>:
.globl vector53
vector53:
  pushl $0
80106004:	6a 00                	push   $0x0
  pushl $53
80106006:	6a 35                	push   $0x35
  jmp alltraps
80106008:	e9 4d f9 ff ff       	jmp    8010595a <alltraps>

8010600d <vector54>:
.globl vector54
vector54:
  pushl $0
8010600d:	6a 00                	push   $0x0
  pushl $54
8010600f:	6a 36                	push   $0x36
  jmp alltraps
80106011:	e9 44 f9 ff ff       	jmp    8010595a <alltraps>

80106016 <vector55>:
.globl vector55
vector55:
  pushl $0
80106016:	6a 00                	push   $0x0
  pushl $55
80106018:	6a 37                	push   $0x37
  jmp alltraps
8010601a:	e9 3b f9 ff ff       	jmp    8010595a <alltraps>

8010601f <vector56>:
.globl vector56
vector56:
  pushl $0
8010601f:	6a 00                	push   $0x0
  pushl $56
80106021:	6a 38                	push   $0x38
  jmp alltraps
80106023:	e9 32 f9 ff ff       	jmp    8010595a <alltraps>

80106028 <vector57>:
.globl vector57
vector57:
  pushl $0
80106028:	6a 00                	push   $0x0
  pushl $57
8010602a:	6a 39                	push   $0x39
  jmp alltraps
8010602c:	e9 29 f9 ff ff       	jmp    8010595a <alltraps>

80106031 <vector58>:
.globl vector58
vector58:
  pushl $0
80106031:	6a 00                	push   $0x0
  pushl $58
80106033:	6a 3a                	push   $0x3a
  jmp alltraps
80106035:	e9 20 f9 ff ff       	jmp    8010595a <alltraps>

8010603a <vector59>:
.globl vector59
vector59:
  pushl $0
8010603a:	6a 00                	push   $0x0
  pushl $59
8010603c:	6a 3b                	push   $0x3b
  jmp alltraps
8010603e:	e9 17 f9 ff ff       	jmp    8010595a <alltraps>

80106043 <vector60>:
.globl vector60
vector60:
  pushl $0
80106043:	6a 00                	push   $0x0
  pushl $60
80106045:	6a 3c                	push   $0x3c
  jmp alltraps
80106047:	e9 0e f9 ff ff       	jmp    8010595a <alltraps>

8010604c <vector61>:
.globl vector61
vector61:
  pushl $0
8010604c:	6a 00                	push   $0x0
  pushl $61
8010604e:	6a 3d                	push   $0x3d
  jmp alltraps
80106050:	e9 05 f9 ff ff       	jmp    8010595a <alltraps>

80106055 <vector62>:
.globl vector62
vector62:
  pushl $0
80106055:	6a 00                	push   $0x0
  pushl $62
80106057:	6a 3e                	push   $0x3e
  jmp alltraps
80106059:	e9 fc f8 ff ff       	jmp    8010595a <alltraps>

8010605e <vector63>:
.globl vector63
vector63:
  pushl $0
8010605e:	6a 00                	push   $0x0
  pushl $63
80106060:	6a 3f                	push   $0x3f
  jmp alltraps
80106062:	e9 f3 f8 ff ff       	jmp    8010595a <alltraps>

80106067 <vector64>:
.globl vector64
vector64:
  pushl $0
80106067:	6a 00                	push   $0x0
  pushl $64
80106069:	6a 40                	push   $0x40
  jmp alltraps
8010606b:	e9 ea f8 ff ff       	jmp    8010595a <alltraps>

80106070 <vector65>:
.globl vector65
vector65:
  pushl $0
80106070:	6a 00                	push   $0x0
  pushl $65
80106072:	6a 41                	push   $0x41
  jmp alltraps
80106074:	e9 e1 f8 ff ff       	jmp    8010595a <alltraps>

80106079 <vector66>:
.globl vector66
vector66:
  pushl $0
80106079:	6a 00                	push   $0x0
  pushl $66
8010607b:	6a 42                	push   $0x42
  jmp alltraps
8010607d:	e9 d8 f8 ff ff       	jmp    8010595a <alltraps>

80106082 <vector67>:
.globl vector67
vector67:
  pushl $0
80106082:	6a 00                	push   $0x0
  pushl $67
80106084:	6a 43                	push   $0x43
  jmp alltraps
80106086:	e9 cf f8 ff ff       	jmp    8010595a <alltraps>

8010608b <vector68>:
.globl vector68
vector68:
  pushl $0
8010608b:	6a 00                	push   $0x0
  pushl $68
8010608d:	6a 44                	push   $0x44
  jmp alltraps
8010608f:	e9 c6 f8 ff ff       	jmp    8010595a <alltraps>

80106094 <vector69>:
.globl vector69
vector69:
  pushl $0
80106094:	6a 00                	push   $0x0
  pushl $69
80106096:	6a 45                	push   $0x45
  jmp alltraps
80106098:	e9 bd f8 ff ff       	jmp    8010595a <alltraps>

8010609d <vector70>:
.globl vector70
vector70:
  pushl $0
8010609d:	6a 00                	push   $0x0
  pushl $70
8010609f:	6a 46                	push   $0x46
  jmp alltraps
801060a1:	e9 b4 f8 ff ff       	jmp    8010595a <alltraps>

801060a6 <vector71>:
.globl vector71
vector71:
  pushl $0
801060a6:	6a 00                	push   $0x0
  pushl $71
801060a8:	6a 47                	push   $0x47
  jmp alltraps
801060aa:	e9 ab f8 ff ff       	jmp    8010595a <alltraps>

801060af <vector72>:
.globl vector72
vector72:
  pushl $0
801060af:	6a 00                	push   $0x0
  pushl $72
801060b1:	6a 48                	push   $0x48
  jmp alltraps
801060b3:	e9 a2 f8 ff ff       	jmp    8010595a <alltraps>

801060b8 <vector73>:
.globl vector73
vector73:
  pushl $0
801060b8:	6a 00                	push   $0x0
  pushl $73
801060ba:	6a 49                	push   $0x49
  jmp alltraps
801060bc:	e9 99 f8 ff ff       	jmp    8010595a <alltraps>

801060c1 <vector74>:
.globl vector74
vector74:
  pushl $0
801060c1:	6a 00                	push   $0x0
  pushl $74
801060c3:	6a 4a                	push   $0x4a
  jmp alltraps
801060c5:	e9 90 f8 ff ff       	jmp    8010595a <alltraps>

801060ca <vector75>:
.globl vector75
vector75:
  pushl $0
801060ca:	6a 00                	push   $0x0
  pushl $75
801060cc:	6a 4b                	push   $0x4b
  jmp alltraps
801060ce:	e9 87 f8 ff ff       	jmp    8010595a <alltraps>

801060d3 <vector76>:
.globl vector76
vector76:
  pushl $0
801060d3:	6a 00                	push   $0x0
  pushl $76
801060d5:	6a 4c                	push   $0x4c
  jmp alltraps
801060d7:	e9 7e f8 ff ff       	jmp    8010595a <alltraps>

801060dc <vector77>:
.globl vector77
vector77:
  pushl $0
801060dc:	6a 00                	push   $0x0
  pushl $77
801060de:	6a 4d                	push   $0x4d
  jmp alltraps
801060e0:	e9 75 f8 ff ff       	jmp    8010595a <alltraps>

801060e5 <vector78>:
.globl vector78
vector78:
  pushl $0
801060e5:	6a 00                	push   $0x0
  pushl $78
801060e7:	6a 4e                	push   $0x4e
  jmp alltraps
801060e9:	e9 6c f8 ff ff       	jmp    8010595a <alltraps>

801060ee <vector79>:
.globl vector79
vector79:
  pushl $0
801060ee:	6a 00                	push   $0x0
  pushl $79
801060f0:	6a 4f                	push   $0x4f
  jmp alltraps
801060f2:	e9 63 f8 ff ff       	jmp    8010595a <alltraps>

801060f7 <vector80>:
.globl vector80
vector80:
  pushl $0
801060f7:	6a 00                	push   $0x0
  pushl $80
801060f9:	6a 50                	push   $0x50
  jmp alltraps
801060fb:	e9 5a f8 ff ff       	jmp    8010595a <alltraps>

80106100 <vector81>:
.globl vector81
vector81:
  pushl $0
80106100:	6a 00                	push   $0x0
  pushl $81
80106102:	6a 51                	push   $0x51
  jmp alltraps
80106104:	e9 51 f8 ff ff       	jmp    8010595a <alltraps>

80106109 <vector82>:
.globl vector82
vector82:
  pushl $0
80106109:	6a 00                	push   $0x0
  pushl $82
8010610b:	6a 52                	push   $0x52
  jmp alltraps
8010610d:	e9 48 f8 ff ff       	jmp    8010595a <alltraps>

80106112 <vector83>:
.globl vector83
vector83:
  pushl $0
80106112:	6a 00                	push   $0x0
  pushl $83
80106114:	6a 53                	push   $0x53
  jmp alltraps
80106116:	e9 3f f8 ff ff       	jmp    8010595a <alltraps>

8010611b <vector84>:
.globl vector84
vector84:
  pushl $0
8010611b:	6a 00                	push   $0x0
  pushl $84
8010611d:	6a 54                	push   $0x54
  jmp alltraps
8010611f:	e9 36 f8 ff ff       	jmp    8010595a <alltraps>

80106124 <vector85>:
.globl vector85
vector85:
  pushl $0
80106124:	6a 00                	push   $0x0
  pushl $85
80106126:	6a 55                	push   $0x55
  jmp alltraps
80106128:	e9 2d f8 ff ff       	jmp    8010595a <alltraps>

8010612d <vector86>:
.globl vector86
vector86:
  pushl $0
8010612d:	6a 00                	push   $0x0
  pushl $86
8010612f:	6a 56                	push   $0x56
  jmp alltraps
80106131:	e9 24 f8 ff ff       	jmp    8010595a <alltraps>

80106136 <vector87>:
.globl vector87
vector87:
  pushl $0
80106136:	6a 00                	push   $0x0
  pushl $87
80106138:	6a 57                	push   $0x57
  jmp alltraps
8010613a:	e9 1b f8 ff ff       	jmp    8010595a <alltraps>

8010613f <vector88>:
.globl vector88
vector88:
  pushl $0
8010613f:	6a 00                	push   $0x0
  pushl $88
80106141:	6a 58                	push   $0x58
  jmp alltraps
80106143:	e9 12 f8 ff ff       	jmp    8010595a <alltraps>

80106148 <vector89>:
.globl vector89
vector89:
  pushl $0
80106148:	6a 00                	push   $0x0
  pushl $89
8010614a:	6a 59                	push   $0x59
  jmp alltraps
8010614c:	e9 09 f8 ff ff       	jmp    8010595a <alltraps>

80106151 <vector90>:
.globl vector90
vector90:
  pushl $0
80106151:	6a 00                	push   $0x0
  pushl $90
80106153:	6a 5a                	push   $0x5a
  jmp alltraps
80106155:	e9 00 f8 ff ff       	jmp    8010595a <alltraps>

8010615a <vector91>:
.globl vector91
vector91:
  pushl $0
8010615a:	6a 00                	push   $0x0
  pushl $91
8010615c:	6a 5b                	push   $0x5b
  jmp alltraps
8010615e:	e9 f7 f7 ff ff       	jmp    8010595a <alltraps>

80106163 <vector92>:
.globl vector92
vector92:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $92
80106165:	6a 5c                	push   $0x5c
  jmp alltraps
80106167:	e9 ee f7 ff ff       	jmp    8010595a <alltraps>

8010616c <vector93>:
.globl vector93
vector93:
  pushl $0
8010616c:	6a 00                	push   $0x0
  pushl $93
8010616e:	6a 5d                	push   $0x5d
  jmp alltraps
80106170:	e9 e5 f7 ff ff       	jmp    8010595a <alltraps>

80106175 <vector94>:
.globl vector94
vector94:
  pushl $0
80106175:	6a 00                	push   $0x0
  pushl $94
80106177:	6a 5e                	push   $0x5e
  jmp alltraps
80106179:	e9 dc f7 ff ff       	jmp    8010595a <alltraps>

8010617e <vector95>:
.globl vector95
vector95:
  pushl $0
8010617e:	6a 00                	push   $0x0
  pushl $95
80106180:	6a 5f                	push   $0x5f
  jmp alltraps
80106182:	e9 d3 f7 ff ff       	jmp    8010595a <alltraps>

80106187 <vector96>:
.globl vector96
vector96:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $96
80106189:	6a 60                	push   $0x60
  jmp alltraps
8010618b:	e9 ca f7 ff ff       	jmp    8010595a <alltraps>

80106190 <vector97>:
.globl vector97
vector97:
  pushl $0
80106190:	6a 00                	push   $0x0
  pushl $97
80106192:	6a 61                	push   $0x61
  jmp alltraps
80106194:	e9 c1 f7 ff ff       	jmp    8010595a <alltraps>

80106199 <vector98>:
.globl vector98
vector98:
  pushl $0
80106199:	6a 00                	push   $0x0
  pushl $98
8010619b:	6a 62                	push   $0x62
  jmp alltraps
8010619d:	e9 b8 f7 ff ff       	jmp    8010595a <alltraps>

801061a2 <vector99>:
.globl vector99
vector99:
  pushl $0
801061a2:	6a 00                	push   $0x0
  pushl $99
801061a4:	6a 63                	push   $0x63
  jmp alltraps
801061a6:	e9 af f7 ff ff       	jmp    8010595a <alltraps>

801061ab <vector100>:
.globl vector100
vector100:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $100
801061ad:	6a 64                	push   $0x64
  jmp alltraps
801061af:	e9 a6 f7 ff ff       	jmp    8010595a <alltraps>

801061b4 <vector101>:
.globl vector101
vector101:
  pushl $0
801061b4:	6a 00                	push   $0x0
  pushl $101
801061b6:	6a 65                	push   $0x65
  jmp alltraps
801061b8:	e9 9d f7 ff ff       	jmp    8010595a <alltraps>

801061bd <vector102>:
.globl vector102
vector102:
  pushl $0
801061bd:	6a 00                	push   $0x0
  pushl $102
801061bf:	6a 66                	push   $0x66
  jmp alltraps
801061c1:	e9 94 f7 ff ff       	jmp    8010595a <alltraps>

801061c6 <vector103>:
.globl vector103
vector103:
  pushl $0
801061c6:	6a 00                	push   $0x0
  pushl $103
801061c8:	6a 67                	push   $0x67
  jmp alltraps
801061ca:	e9 8b f7 ff ff       	jmp    8010595a <alltraps>

801061cf <vector104>:
.globl vector104
vector104:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $104
801061d1:	6a 68                	push   $0x68
  jmp alltraps
801061d3:	e9 82 f7 ff ff       	jmp    8010595a <alltraps>

801061d8 <vector105>:
.globl vector105
vector105:
  pushl $0
801061d8:	6a 00                	push   $0x0
  pushl $105
801061da:	6a 69                	push   $0x69
  jmp alltraps
801061dc:	e9 79 f7 ff ff       	jmp    8010595a <alltraps>

801061e1 <vector106>:
.globl vector106
vector106:
  pushl $0
801061e1:	6a 00                	push   $0x0
  pushl $106
801061e3:	6a 6a                	push   $0x6a
  jmp alltraps
801061e5:	e9 70 f7 ff ff       	jmp    8010595a <alltraps>

801061ea <vector107>:
.globl vector107
vector107:
  pushl $0
801061ea:	6a 00                	push   $0x0
  pushl $107
801061ec:	6a 6b                	push   $0x6b
  jmp alltraps
801061ee:	e9 67 f7 ff ff       	jmp    8010595a <alltraps>

801061f3 <vector108>:
.globl vector108
vector108:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $108
801061f5:	6a 6c                	push   $0x6c
  jmp alltraps
801061f7:	e9 5e f7 ff ff       	jmp    8010595a <alltraps>

801061fc <vector109>:
.globl vector109
vector109:
  pushl $0
801061fc:	6a 00                	push   $0x0
  pushl $109
801061fe:	6a 6d                	push   $0x6d
  jmp alltraps
80106200:	e9 55 f7 ff ff       	jmp    8010595a <alltraps>

80106205 <vector110>:
.globl vector110
vector110:
  pushl $0
80106205:	6a 00                	push   $0x0
  pushl $110
80106207:	6a 6e                	push   $0x6e
  jmp alltraps
80106209:	e9 4c f7 ff ff       	jmp    8010595a <alltraps>

8010620e <vector111>:
.globl vector111
vector111:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $111
80106210:	6a 6f                	push   $0x6f
  jmp alltraps
80106212:	e9 43 f7 ff ff       	jmp    8010595a <alltraps>

80106217 <vector112>:
.globl vector112
vector112:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $112
80106219:	6a 70                	push   $0x70
  jmp alltraps
8010621b:	e9 3a f7 ff ff       	jmp    8010595a <alltraps>

80106220 <vector113>:
.globl vector113
vector113:
  pushl $0
80106220:	6a 00                	push   $0x0
  pushl $113
80106222:	6a 71                	push   $0x71
  jmp alltraps
80106224:	e9 31 f7 ff ff       	jmp    8010595a <alltraps>

80106229 <vector114>:
.globl vector114
vector114:
  pushl $0
80106229:	6a 00                	push   $0x0
  pushl $114
8010622b:	6a 72                	push   $0x72
  jmp alltraps
8010622d:	e9 28 f7 ff ff       	jmp    8010595a <alltraps>

80106232 <vector115>:
.globl vector115
vector115:
  pushl $0
80106232:	6a 00                	push   $0x0
  pushl $115
80106234:	6a 73                	push   $0x73
  jmp alltraps
80106236:	e9 1f f7 ff ff       	jmp    8010595a <alltraps>

8010623b <vector116>:
.globl vector116
vector116:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $116
8010623d:	6a 74                	push   $0x74
  jmp alltraps
8010623f:	e9 16 f7 ff ff       	jmp    8010595a <alltraps>

80106244 <vector117>:
.globl vector117
vector117:
  pushl $0
80106244:	6a 00                	push   $0x0
  pushl $117
80106246:	6a 75                	push   $0x75
  jmp alltraps
80106248:	e9 0d f7 ff ff       	jmp    8010595a <alltraps>

8010624d <vector118>:
.globl vector118
vector118:
  pushl $0
8010624d:	6a 00                	push   $0x0
  pushl $118
8010624f:	6a 76                	push   $0x76
  jmp alltraps
80106251:	e9 04 f7 ff ff       	jmp    8010595a <alltraps>

80106256 <vector119>:
.globl vector119
vector119:
  pushl $0
80106256:	6a 00                	push   $0x0
  pushl $119
80106258:	6a 77                	push   $0x77
  jmp alltraps
8010625a:	e9 fb f6 ff ff       	jmp    8010595a <alltraps>

8010625f <vector120>:
.globl vector120
vector120:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $120
80106261:	6a 78                	push   $0x78
  jmp alltraps
80106263:	e9 f2 f6 ff ff       	jmp    8010595a <alltraps>

80106268 <vector121>:
.globl vector121
vector121:
  pushl $0
80106268:	6a 00                	push   $0x0
  pushl $121
8010626a:	6a 79                	push   $0x79
  jmp alltraps
8010626c:	e9 e9 f6 ff ff       	jmp    8010595a <alltraps>

80106271 <vector122>:
.globl vector122
vector122:
  pushl $0
80106271:	6a 00                	push   $0x0
  pushl $122
80106273:	6a 7a                	push   $0x7a
  jmp alltraps
80106275:	e9 e0 f6 ff ff       	jmp    8010595a <alltraps>

8010627a <vector123>:
.globl vector123
vector123:
  pushl $0
8010627a:	6a 00                	push   $0x0
  pushl $123
8010627c:	6a 7b                	push   $0x7b
  jmp alltraps
8010627e:	e9 d7 f6 ff ff       	jmp    8010595a <alltraps>

80106283 <vector124>:
.globl vector124
vector124:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $124
80106285:	6a 7c                	push   $0x7c
  jmp alltraps
80106287:	e9 ce f6 ff ff       	jmp    8010595a <alltraps>

8010628c <vector125>:
.globl vector125
vector125:
  pushl $0
8010628c:	6a 00                	push   $0x0
  pushl $125
8010628e:	6a 7d                	push   $0x7d
  jmp alltraps
80106290:	e9 c5 f6 ff ff       	jmp    8010595a <alltraps>

80106295 <vector126>:
.globl vector126
vector126:
  pushl $0
80106295:	6a 00                	push   $0x0
  pushl $126
80106297:	6a 7e                	push   $0x7e
  jmp alltraps
80106299:	e9 bc f6 ff ff       	jmp    8010595a <alltraps>

8010629e <vector127>:
.globl vector127
vector127:
  pushl $0
8010629e:	6a 00                	push   $0x0
  pushl $127
801062a0:	6a 7f                	push   $0x7f
  jmp alltraps
801062a2:	e9 b3 f6 ff ff       	jmp    8010595a <alltraps>

801062a7 <vector128>:
.globl vector128
vector128:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $128
801062a9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801062ae:	e9 a7 f6 ff ff       	jmp    8010595a <alltraps>

801062b3 <vector129>:
.globl vector129
vector129:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $129
801062b5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801062ba:	e9 9b f6 ff ff       	jmp    8010595a <alltraps>

801062bf <vector130>:
.globl vector130
vector130:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $130
801062c1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801062c6:	e9 8f f6 ff ff       	jmp    8010595a <alltraps>

801062cb <vector131>:
.globl vector131
vector131:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $131
801062cd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801062d2:	e9 83 f6 ff ff       	jmp    8010595a <alltraps>

801062d7 <vector132>:
.globl vector132
vector132:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $132
801062d9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801062de:	e9 77 f6 ff ff       	jmp    8010595a <alltraps>

801062e3 <vector133>:
.globl vector133
vector133:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $133
801062e5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801062ea:	e9 6b f6 ff ff       	jmp    8010595a <alltraps>

801062ef <vector134>:
.globl vector134
vector134:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $134
801062f1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801062f6:	e9 5f f6 ff ff       	jmp    8010595a <alltraps>

801062fb <vector135>:
.globl vector135
vector135:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $135
801062fd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106302:	e9 53 f6 ff ff       	jmp    8010595a <alltraps>

80106307 <vector136>:
.globl vector136
vector136:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $136
80106309:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010630e:	e9 47 f6 ff ff       	jmp    8010595a <alltraps>

80106313 <vector137>:
.globl vector137
vector137:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $137
80106315:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010631a:	e9 3b f6 ff ff       	jmp    8010595a <alltraps>

8010631f <vector138>:
.globl vector138
vector138:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $138
80106321:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106326:	e9 2f f6 ff ff       	jmp    8010595a <alltraps>

8010632b <vector139>:
.globl vector139
vector139:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $139
8010632d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106332:	e9 23 f6 ff ff       	jmp    8010595a <alltraps>

80106337 <vector140>:
.globl vector140
vector140:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $140
80106339:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010633e:	e9 17 f6 ff ff       	jmp    8010595a <alltraps>

80106343 <vector141>:
.globl vector141
vector141:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $141
80106345:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010634a:	e9 0b f6 ff ff       	jmp    8010595a <alltraps>

8010634f <vector142>:
.globl vector142
vector142:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $142
80106351:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106356:	e9 ff f5 ff ff       	jmp    8010595a <alltraps>

8010635b <vector143>:
.globl vector143
vector143:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $143
8010635d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106362:	e9 f3 f5 ff ff       	jmp    8010595a <alltraps>

80106367 <vector144>:
.globl vector144
vector144:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $144
80106369:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010636e:	e9 e7 f5 ff ff       	jmp    8010595a <alltraps>

80106373 <vector145>:
.globl vector145
vector145:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $145
80106375:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010637a:	e9 db f5 ff ff       	jmp    8010595a <alltraps>

8010637f <vector146>:
.globl vector146
vector146:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $146
80106381:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106386:	e9 cf f5 ff ff       	jmp    8010595a <alltraps>

8010638b <vector147>:
.globl vector147
vector147:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $147
8010638d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106392:	e9 c3 f5 ff ff       	jmp    8010595a <alltraps>

80106397 <vector148>:
.globl vector148
vector148:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $148
80106399:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010639e:	e9 b7 f5 ff ff       	jmp    8010595a <alltraps>

801063a3 <vector149>:
.globl vector149
vector149:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $149
801063a5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801063aa:	e9 ab f5 ff ff       	jmp    8010595a <alltraps>

801063af <vector150>:
.globl vector150
vector150:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $150
801063b1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801063b6:	e9 9f f5 ff ff       	jmp    8010595a <alltraps>

801063bb <vector151>:
.globl vector151
vector151:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $151
801063bd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801063c2:	e9 93 f5 ff ff       	jmp    8010595a <alltraps>

801063c7 <vector152>:
.globl vector152
vector152:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $152
801063c9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801063ce:	e9 87 f5 ff ff       	jmp    8010595a <alltraps>

801063d3 <vector153>:
.globl vector153
vector153:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $153
801063d5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801063da:	e9 7b f5 ff ff       	jmp    8010595a <alltraps>

801063df <vector154>:
.globl vector154
vector154:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $154
801063e1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801063e6:	e9 6f f5 ff ff       	jmp    8010595a <alltraps>

801063eb <vector155>:
.globl vector155
vector155:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $155
801063ed:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801063f2:	e9 63 f5 ff ff       	jmp    8010595a <alltraps>

801063f7 <vector156>:
.globl vector156
vector156:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $156
801063f9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801063fe:	e9 57 f5 ff ff       	jmp    8010595a <alltraps>

80106403 <vector157>:
.globl vector157
vector157:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $157
80106405:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010640a:	e9 4b f5 ff ff       	jmp    8010595a <alltraps>

8010640f <vector158>:
.globl vector158
vector158:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $158
80106411:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106416:	e9 3f f5 ff ff       	jmp    8010595a <alltraps>

8010641b <vector159>:
.globl vector159
vector159:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $159
8010641d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106422:	e9 33 f5 ff ff       	jmp    8010595a <alltraps>

80106427 <vector160>:
.globl vector160
vector160:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $160
80106429:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010642e:	e9 27 f5 ff ff       	jmp    8010595a <alltraps>

80106433 <vector161>:
.globl vector161
vector161:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $161
80106435:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010643a:	e9 1b f5 ff ff       	jmp    8010595a <alltraps>

8010643f <vector162>:
.globl vector162
vector162:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $162
80106441:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106446:	e9 0f f5 ff ff       	jmp    8010595a <alltraps>

8010644b <vector163>:
.globl vector163
vector163:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $163
8010644d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106452:	e9 03 f5 ff ff       	jmp    8010595a <alltraps>

80106457 <vector164>:
.globl vector164
vector164:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $164
80106459:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010645e:	e9 f7 f4 ff ff       	jmp    8010595a <alltraps>

80106463 <vector165>:
.globl vector165
vector165:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $165
80106465:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010646a:	e9 eb f4 ff ff       	jmp    8010595a <alltraps>

8010646f <vector166>:
.globl vector166
vector166:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $166
80106471:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106476:	e9 df f4 ff ff       	jmp    8010595a <alltraps>

8010647b <vector167>:
.globl vector167
vector167:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $167
8010647d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106482:	e9 d3 f4 ff ff       	jmp    8010595a <alltraps>

80106487 <vector168>:
.globl vector168
vector168:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $168
80106489:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010648e:	e9 c7 f4 ff ff       	jmp    8010595a <alltraps>

80106493 <vector169>:
.globl vector169
vector169:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $169
80106495:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010649a:	e9 bb f4 ff ff       	jmp    8010595a <alltraps>

8010649f <vector170>:
.globl vector170
vector170:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $170
801064a1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801064a6:	e9 af f4 ff ff       	jmp    8010595a <alltraps>

801064ab <vector171>:
.globl vector171
vector171:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $171
801064ad:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801064b2:	e9 a3 f4 ff ff       	jmp    8010595a <alltraps>

801064b7 <vector172>:
.globl vector172
vector172:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $172
801064b9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801064be:	e9 97 f4 ff ff       	jmp    8010595a <alltraps>

801064c3 <vector173>:
.globl vector173
vector173:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $173
801064c5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801064ca:	e9 8b f4 ff ff       	jmp    8010595a <alltraps>

801064cf <vector174>:
.globl vector174
vector174:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $174
801064d1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801064d6:	e9 7f f4 ff ff       	jmp    8010595a <alltraps>

801064db <vector175>:
.globl vector175
vector175:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $175
801064dd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801064e2:	e9 73 f4 ff ff       	jmp    8010595a <alltraps>

801064e7 <vector176>:
.globl vector176
vector176:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $176
801064e9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801064ee:	e9 67 f4 ff ff       	jmp    8010595a <alltraps>

801064f3 <vector177>:
.globl vector177
vector177:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $177
801064f5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801064fa:	e9 5b f4 ff ff       	jmp    8010595a <alltraps>

801064ff <vector178>:
.globl vector178
vector178:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $178
80106501:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106506:	e9 4f f4 ff ff       	jmp    8010595a <alltraps>

8010650b <vector179>:
.globl vector179
vector179:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $179
8010650d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106512:	e9 43 f4 ff ff       	jmp    8010595a <alltraps>

80106517 <vector180>:
.globl vector180
vector180:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $180
80106519:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010651e:	e9 37 f4 ff ff       	jmp    8010595a <alltraps>

80106523 <vector181>:
.globl vector181
vector181:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $181
80106525:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010652a:	e9 2b f4 ff ff       	jmp    8010595a <alltraps>

8010652f <vector182>:
.globl vector182
vector182:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $182
80106531:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106536:	e9 1f f4 ff ff       	jmp    8010595a <alltraps>

8010653b <vector183>:
.globl vector183
vector183:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $183
8010653d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106542:	e9 13 f4 ff ff       	jmp    8010595a <alltraps>

80106547 <vector184>:
.globl vector184
vector184:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $184
80106549:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010654e:	e9 07 f4 ff ff       	jmp    8010595a <alltraps>

80106553 <vector185>:
.globl vector185
vector185:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $185
80106555:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010655a:	e9 fb f3 ff ff       	jmp    8010595a <alltraps>

8010655f <vector186>:
.globl vector186
vector186:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $186
80106561:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106566:	e9 ef f3 ff ff       	jmp    8010595a <alltraps>

8010656b <vector187>:
.globl vector187
vector187:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $187
8010656d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106572:	e9 e3 f3 ff ff       	jmp    8010595a <alltraps>

80106577 <vector188>:
.globl vector188
vector188:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $188
80106579:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010657e:	e9 d7 f3 ff ff       	jmp    8010595a <alltraps>

80106583 <vector189>:
.globl vector189
vector189:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $189
80106585:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010658a:	e9 cb f3 ff ff       	jmp    8010595a <alltraps>

8010658f <vector190>:
.globl vector190
vector190:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $190
80106591:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106596:	e9 bf f3 ff ff       	jmp    8010595a <alltraps>

8010659b <vector191>:
.globl vector191
vector191:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $191
8010659d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801065a2:	e9 b3 f3 ff ff       	jmp    8010595a <alltraps>

801065a7 <vector192>:
.globl vector192
vector192:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $192
801065a9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801065ae:	e9 a7 f3 ff ff       	jmp    8010595a <alltraps>

801065b3 <vector193>:
.globl vector193
vector193:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $193
801065b5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801065ba:	e9 9b f3 ff ff       	jmp    8010595a <alltraps>

801065bf <vector194>:
.globl vector194
vector194:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $194
801065c1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801065c6:	e9 8f f3 ff ff       	jmp    8010595a <alltraps>

801065cb <vector195>:
.globl vector195
vector195:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $195
801065cd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801065d2:	e9 83 f3 ff ff       	jmp    8010595a <alltraps>

801065d7 <vector196>:
.globl vector196
vector196:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $196
801065d9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801065de:	e9 77 f3 ff ff       	jmp    8010595a <alltraps>

801065e3 <vector197>:
.globl vector197
vector197:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $197
801065e5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801065ea:	e9 6b f3 ff ff       	jmp    8010595a <alltraps>

801065ef <vector198>:
.globl vector198
vector198:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $198
801065f1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801065f6:	e9 5f f3 ff ff       	jmp    8010595a <alltraps>

801065fb <vector199>:
.globl vector199
vector199:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $199
801065fd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106602:	e9 53 f3 ff ff       	jmp    8010595a <alltraps>

80106607 <vector200>:
.globl vector200
vector200:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $200
80106609:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010660e:	e9 47 f3 ff ff       	jmp    8010595a <alltraps>

80106613 <vector201>:
.globl vector201
vector201:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $201
80106615:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010661a:	e9 3b f3 ff ff       	jmp    8010595a <alltraps>

8010661f <vector202>:
.globl vector202
vector202:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $202
80106621:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106626:	e9 2f f3 ff ff       	jmp    8010595a <alltraps>

8010662b <vector203>:
.globl vector203
vector203:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $203
8010662d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106632:	e9 23 f3 ff ff       	jmp    8010595a <alltraps>

80106637 <vector204>:
.globl vector204
vector204:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $204
80106639:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010663e:	e9 17 f3 ff ff       	jmp    8010595a <alltraps>

80106643 <vector205>:
.globl vector205
vector205:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $205
80106645:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010664a:	e9 0b f3 ff ff       	jmp    8010595a <alltraps>

8010664f <vector206>:
.globl vector206
vector206:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $206
80106651:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106656:	e9 ff f2 ff ff       	jmp    8010595a <alltraps>

8010665b <vector207>:
.globl vector207
vector207:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $207
8010665d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106662:	e9 f3 f2 ff ff       	jmp    8010595a <alltraps>

80106667 <vector208>:
.globl vector208
vector208:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $208
80106669:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010666e:	e9 e7 f2 ff ff       	jmp    8010595a <alltraps>

80106673 <vector209>:
.globl vector209
vector209:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $209
80106675:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010667a:	e9 db f2 ff ff       	jmp    8010595a <alltraps>

8010667f <vector210>:
.globl vector210
vector210:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $210
80106681:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106686:	e9 cf f2 ff ff       	jmp    8010595a <alltraps>

8010668b <vector211>:
.globl vector211
vector211:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $211
8010668d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106692:	e9 c3 f2 ff ff       	jmp    8010595a <alltraps>

80106697 <vector212>:
.globl vector212
vector212:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $212
80106699:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010669e:	e9 b7 f2 ff ff       	jmp    8010595a <alltraps>

801066a3 <vector213>:
.globl vector213
vector213:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $213
801066a5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801066aa:	e9 ab f2 ff ff       	jmp    8010595a <alltraps>

801066af <vector214>:
.globl vector214
vector214:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $214
801066b1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801066b6:	e9 9f f2 ff ff       	jmp    8010595a <alltraps>

801066bb <vector215>:
.globl vector215
vector215:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $215
801066bd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801066c2:	e9 93 f2 ff ff       	jmp    8010595a <alltraps>

801066c7 <vector216>:
.globl vector216
vector216:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $216
801066c9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801066ce:	e9 87 f2 ff ff       	jmp    8010595a <alltraps>

801066d3 <vector217>:
.globl vector217
vector217:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $217
801066d5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801066da:	e9 7b f2 ff ff       	jmp    8010595a <alltraps>

801066df <vector218>:
.globl vector218
vector218:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $218
801066e1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801066e6:	e9 6f f2 ff ff       	jmp    8010595a <alltraps>

801066eb <vector219>:
.globl vector219
vector219:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $219
801066ed:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801066f2:	e9 63 f2 ff ff       	jmp    8010595a <alltraps>

801066f7 <vector220>:
.globl vector220
vector220:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $220
801066f9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801066fe:	e9 57 f2 ff ff       	jmp    8010595a <alltraps>

80106703 <vector221>:
.globl vector221
vector221:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $221
80106705:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010670a:	e9 4b f2 ff ff       	jmp    8010595a <alltraps>

8010670f <vector222>:
.globl vector222
vector222:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $222
80106711:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106716:	e9 3f f2 ff ff       	jmp    8010595a <alltraps>

8010671b <vector223>:
.globl vector223
vector223:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $223
8010671d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106722:	e9 33 f2 ff ff       	jmp    8010595a <alltraps>

80106727 <vector224>:
.globl vector224
vector224:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $224
80106729:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010672e:	e9 27 f2 ff ff       	jmp    8010595a <alltraps>

80106733 <vector225>:
.globl vector225
vector225:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $225
80106735:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010673a:	e9 1b f2 ff ff       	jmp    8010595a <alltraps>

8010673f <vector226>:
.globl vector226
vector226:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $226
80106741:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106746:	e9 0f f2 ff ff       	jmp    8010595a <alltraps>

8010674b <vector227>:
.globl vector227
vector227:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $227
8010674d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106752:	e9 03 f2 ff ff       	jmp    8010595a <alltraps>

80106757 <vector228>:
.globl vector228
vector228:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $228
80106759:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010675e:	e9 f7 f1 ff ff       	jmp    8010595a <alltraps>

80106763 <vector229>:
.globl vector229
vector229:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $229
80106765:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010676a:	e9 eb f1 ff ff       	jmp    8010595a <alltraps>

8010676f <vector230>:
.globl vector230
vector230:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $230
80106771:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106776:	e9 df f1 ff ff       	jmp    8010595a <alltraps>

8010677b <vector231>:
.globl vector231
vector231:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $231
8010677d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106782:	e9 d3 f1 ff ff       	jmp    8010595a <alltraps>

80106787 <vector232>:
.globl vector232
vector232:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $232
80106789:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010678e:	e9 c7 f1 ff ff       	jmp    8010595a <alltraps>

80106793 <vector233>:
.globl vector233
vector233:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $233
80106795:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010679a:	e9 bb f1 ff ff       	jmp    8010595a <alltraps>

8010679f <vector234>:
.globl vector234
vector234:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $234
801067a1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801067a6:	e9 af f1 ff ff       	jmp    8010595a <alltraps>

801067ab <vector235>:
.globl vector235
vector235:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $235
801067ad:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801067b2:	e9 a3 f1 ff ff       	jmp    8010595a <alltraps>

801067b7 <vector236>:
.globl vector236
vector236:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $236
801067b9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801067be:	e9 97 f1 ff ff       	jmp    8010595a <alltraps>

801067c3 <vector237>:
.globl vector237
vector237:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $237
801067c5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801067ca:	e9 8b f1 ff ff       	jmp    8010595a <alltraps>

801067cf <vector238>:
.globl vector238
vector238:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $238
801067d1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801067d6:	e9 7f f1 ff ff       	jmp    8010595a <alltraps>

801067db <vector239>:
.globl vector239
vector239:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $239
801067dd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801067e2:	e9 73 f1 ff ff       	jmp    8010595a <alltraps>

801067e7 <vector240>:
.globl vector240
vector240:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $240
801067e9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801067ee:	e9 67 f1 ff ff       	jmp    8010595a <alltraps>

801067f3 <vector241>:
.globl vector241
vector241:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $241
801067f5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801067fa:	e9 5b f1 ff ff       	jmp    8010595a <alltraps>

801067ff <vector242>:
.globl vector242
vector242:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $242
80106801:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106806:	e9 4f f1 ff ff       	jmp    8010595a <alltraps>

8010680b <vector243>:
.globl vector243
vector243:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $243
8010680d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106812:	e9 43 f1 ff ff       	jmp    8010595a <alltraps>

80106817 <vector244>:
.globl vector244
vector244:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $244
80106819:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010681e:	e9 37 f1 ff ff       	jmp    8010595a <alltraps>

80106823 <vector245>:
.globl vector245
vector245:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $245
80106825:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010682a:	e9 2b f1 ff ff       	jmp    8010595a <alltraps>

8010682f <vector246>:
.globl vector246
vector246:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $246
80106831:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106836:	e9 1f f1 ff ff       	jmp    8010595a <alltraps>

8010683b <vector247>:
.globl vector247
vector247:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $247
8010683d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106842:	e9 13 f1 ff ff       	jmp    8010595a <alltraps>

80106847 <vector248>:
.globl vector248
vector248:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $248
80106849:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010684e:	e9 07 f1 ff ff       	jmp    8010595a <alltraps>

80106853 <vector249>:
.globl vector249
vector249:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $249
80106855:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010685a:	e9 fb f0 ff ff       	jmp    8010595a <alltraps>

8010685f <vector250>:
.globl vector250
vector250:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $250
80106861:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106866:	e9 ef f0 ff ff       	jmp    8010595a <alltraps>

8010686b <vector251>:
.globl vector251
vector251:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $251
8010686d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106872:	e9 e3 f0 ff ff       	jmp    8010595a <alltraps>

80106877 <vector252>:
.globl vector252
vector252:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $252
80106879:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010687e:	e9 d7 f0 ff ff       	jmp    8010595a <alltraps>

80106883 <vector253>:
.globl vector253
vector253:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $253
80106885:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010688a:	e9 cb f0 ff ff       	jmp    8010595a <alltraps>

8010688f <vector254>:
.globl vector254
vector254:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $254
80106891:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106896:	e9 bf f0 ff ff       	jmp    8010595a <alltraps>

8010689b <vector255>:
.globl vector255
vector255:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $255
8010689d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801068a2:	e9 b3 f0 ff ff       	jmp    8010595a <alltraps>
801068a7:	66 90                	xchg   %ax,%ax
801068a9:	66 90                	xchg   %ax,%ax
801068ab:	66 90                	xchg   %ax,%ax
801068ad:	66 90                	xchg   %ax,%ax
801068af:	90                   	nop

801068b0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801068b0:	55                   	push   %ebp
801068b1:	89 e5                	mov    %esp,%ebp
801068b3:	57                   	push   %edi
801068b4:	56                   	push   %esi
801068b5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801068b7:	c1 ea 16             	shr    $0x16,%edx
{
801068ba:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
801068bb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
801068be:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801068c1:	8b 07                	mov    (%edi),%eax
801068c3:	a8 01                	test   $0x1,%al
801068c5:	74 29                	je     801068f0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801068c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801068cc:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801068d2:	c1 ee 0a             	shr    $0xa,%esi
}
801068d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801068d8:	89 f2                	mov    %esi,%edx
801068da:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801068e0:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801068e3:	5b                   	pop    %ebx
801068e4:	5e                   	pop    %esi
801068e5:	5f                   	pop    %edi
801068e6:	5d                   	pop    %ebp
801068e7:	c3                   	ret    
801068e8:	90                   	nop
801068e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801068f0:	85 c9                	test   %ecx,%ecx
801068f2:	74 2c                	je     80106920 <walkpgdir+0x70>
801068f4:	e8 c7 bc ff ff       	call   801025c0 <kalloc>
801068f9:	89 c3                	mov    %eax,%ebx
801068fb:	85 c0                	test   %eax,%eax
801068fd:	74 21                	je     80106920 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801068ff:	83 ec 04             	sub    $0x4,%esp
80106902:	68 00 10 00 00       	push   $0x1000
80106907:	6a 00                	push   $0x0
80106909:	50                   	push   %eax
8010690a:	e8 21 de ff ff       	call   80104730 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010690f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106915:	83 c4 10             	add    $0x10,%esp
80106918:	83 c8 07             	or     $0x7,%eax
8010691b:	89 07                	mov    %eax,(%edi)
8010691d:	eb b3                	jmp    801068d2 <walkpgdir+0x22>
8010691f:	90                   	nop
}
80106920:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106923:	31 c0                	xor    %eax,%eax
}
80106925:	5b                   	pop    %ebx
80106926:	5e                   	pop    %esi
80106927:	5f                   	pop    %edi
80106928:	5d                   	pop    %ebp
80106929:	c3                   	ret    
8010692a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106930 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106930:	55                   	push   %ebp
80106931:	89 e5                	mov    %esp,%ebp
80106933:	57                   	push   %edi
80106934:	56                   	push   %esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106935:	89 d6                	mov    %edx,%esi
{
80106937:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106938:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
8010693e:	83 ec 1c             	sub    $0x1c,%esp
80106941:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106944:	8b 7d 08             	mov    0x8(%ebp),%edi
80106947:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
8010694b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106950:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106953:	29 f7                	sub    %esi,%edi
80106955:	eb 21                	jmp    80106978 <mappages+0x48>
80106957:	89 f6                	mov    %esi,%esi
80106959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106960:	f6 00 01             	testb  $0x1,(%eax)
80106963:	75 45                	jne    801069aa <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106965:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106968:	83 cb 01             	or     $0x1,%ebx
8010696b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010696d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106970:	74 2e                	je     801069a0 <mappages+0x70>
      break;
    a += PGSIZE;
80106972:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106978:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010697b:	b9 01 00 00 00       	mov    $0x1,%ecx
80106980:	89 f2                	mov    %esi,%edx
80106982:	8d 1c 3e             	lea    (%esi,%edi,1),%ebx
80106985:	e8 26 ff ff ff       	call   801068b0 <walkpgdir>
8010698a:	85 c0                	test   %eax,%eax
8010698c:	75 d2                	jne    80106960 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010698e:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106991:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106996:	5b                   	pop    %ebx
80106997:	5e                   	pop    %esi
80106998:	5f                   	pop    %edi
80106999:	5d                   	pop    %ebp
8010699a:	c3                   	ret    
8010699b:	90                   	nop
8010699c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801069a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801069a3:	31 c0                	xor    %eax,%eax
}
801069a5:	5b                   	pop    %ebx
801069a6:	5e                   	pop    %esi
801069a7:	5f                   	pop    %edi
801069a8:	5d                   	pop    %ebp
801069a9:	c3                   	ret    
      panic("remap");
801069aa:	83 ec 0c             	sub    $0xc,%esp
801069ad:	68 58 7b 10 80       	push   $0x80107b58
801069b2:	e8 d9 99 ff ff       	call   80100390 <panic>
801069b7:	89 f6                	mov    %esi,%esi
801069b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069c0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801069c0:	55                   	push   %ebp
801069c1:	89 e5                	mov    %esp,%ebp
801069c3:	57                   	push   %edi
801069c4:	89 c7                	mov    %eax,%edi
801069c6:	56                   	push   %esi
801069c7:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801069c8:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801069ce:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801069d4:	83 ec 1c             	sub    $0x1c,%esp
801069d7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801069da:	39 d3                	cmp    %edx,%ebx
801069dc:	73 5a                	jae    80106a38 <deallocuvm.part.0+0x78>
801069de:	89 d6                	mov    %edx,%esi
801069e0:	eb 10                	jmp    801069f2 <deallocuvm.part.0+0x32>
801069e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801069e8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801069ee:	39 de                	cmp    %ebx,%esi
801069f0:	76 46                	jbe    80106a38 <deallocuvm.part.0+0x78>
    pte = walkpgdir(pgdir, (char*)a, 0);
801069f2:	31 c9                	xor    %ecx,%ecx
801069f4:	89 da                	mov    %ebx,%edx
801069f6:	89 f8                	mov    %edi,%eax
801069f8:	e8 b3 fe ff ff       	call   801068b0 <walkpgdir>
    if(!pte)
801069fd:	85 c0                	test   %eax,%eax
801069ff:	74 47                	je     80106a48 <deallocuvm.part.0+0x88>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106a01:	8b 10                	mov    (%eax),%edx
80106a03:	f6 c2 01             	test   $0x1,%dl
80106a06:	74 e0                	je     801069e8 <deallocuvm.part.0+0x28>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106a08:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106a0e:	74 46                	je     80106a56 <deallocuvm.part.0+0x96>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106a10:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106a13:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106a19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106a1c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a22:	52                   	push   %edx
80106a23:	e8 d8 b9 ff ff       	call   80102400 <kfree>
      *pte = 0;
80106a28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a2b:	83 c4 10             	add    $0x10,%esp
80106a2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106a34:	39 de                	cmp    %ebx,%esi
80106a36:	77 ba                	ja     801069f2 <deallocuvm.part.0+0x32>
    }
  }
  return newsz;
}
80106a38:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a3e:	5b                   	pop    %ebx
80106a3f:	5e                   	pop    %esi
80106a40:	5f                   	pop    %edi
80106a41:	5d                   	pop    %ebp
80106a42:	c3                   	ret    
80106a43:	90                   	nop
80106a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106a48:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106a4e:	81 c3 00 00 40 00    	add    $0x400000,%ebx
80106a54:	eb 98                	jmp    801069ee <deallocuvm.part.0+0x2e>
        panic("kfree");
80106a56:	83 ec 0c             	sub    $0xc,%esp
80106a59:	68 26 74 10 80       	push   $0x80107426
80106a5e:	e8 2d 99 ff ff       	call   80100390 <panic>
80106a63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a70 <seginit>:
{
80106a70:	55                   	push   %ebp
80106a71:	89 e5                	mov    %esp,%ebp
80106a73:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106a76:	e8 65 ce ff ff       	call   801038e0 <cpuid>
  pd[0] = size-1;
80106a7b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106a80:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106a86:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106a8a:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106a91:	ff 00 00 
80106a94:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
80106a9b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106a9e:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
80106aa5:	ff 00 00 
80106aa8:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
80106aaf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106ab2:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
80106ab9:	ff 00 00 
80106abc:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
80106ac3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106ac6:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
80106acd:	ff 00 00 
80106ad0:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106ad7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106ada:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
80106adf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106ae3:	c1 e8 10             	shr    $0x10,%eax
80106ae6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106aea:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106aed:	0f 01 10             	lgdtl  (%eax)
}
80106af0:	c9                   	leave  
80106af1:	c3                   	ret    
80106af2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b00 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106b00:	a1 a4 55 11 80       	mov    0x801155a4,%eax
80106b05:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106b0a:	0f 22 d8             	mov    %eax,%cr3
}
80106b0d:	c3                   	ret    
80106b0e:	66 90                	xchg   %ax,%ax

80106b10 <switchuvm>:
{
80106b10:	55                   	push   %ebp
80106b11:	89 e5                	mov    %esp,%ebp
80106b13:	57                   	push   %edi
80106b14:	56                   	push   %esi
80106b15:	53                   	push   %ebx
80106b16:	83 ec 1c             	sub    $0x1c,%esp
80106b19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106b1c:	85 db                	test   %ebx,%ebx
80106b1e:	0f 84 cb 00 00 00    	je     80106bef <switchuvm+0xdf>
  if(p->kstack == 0)
80106b24:	8b 43 08             	mov    0x8(%ebx),%eax
80106b27:	85 c0                	test   %eax,%eax
80106b29:	0f 84 da 00 00 00    	je     80106c09 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106b2f:	8b 43 04             	mov    0x4(%ebx),%eax
80106b32:	85 c0                	test   %eax,%eax
80106b34:	0f 84 c2 00 00 00    	je     80106bfc <switchuvm+0xec>
  pushcli();
80106b3a:	e8 31 da ff ff       	call   80104570 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106b3f:	e8 1c cd ff ff       	call   80103860 <mycpu>
80106b44:	89 c6                	mov    %eax,%esi
80106b46:	e8 15 cd ff ff       	call   80103860 <mycpu>
80106b4b:	89 c7                	mov    %eax,%edi
80106b4d:	e8 0e cd ff ff       	call   80103860 <mycpu>
80106b52:	83 c7 08             	add    $0x8,%edi
80106b55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b58:	e8 03 cd ff ff       	call   80103860 <mycpu>
80106b5d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106b60:	ba 67 00 00 00       	mov    $0x67,%edx
80106b65:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106b6c:	83 c0 08             	add    $0x8,%eax
80106b6f:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106b76:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106b7b:	83 c1 08             	add    $0x8,%ecx
80106b7e:	c1 e8 18             	shr    $0x18,%eax
80106b81:	c1 e9 10             	shr    $0x10,%ecx
80106b84:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
80106b8a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106b90:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106b95:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106b9c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106ba1:	e8 ba cc ff ff       	call   80103860 <mycpu>
80106ba6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106bad:	e8 ae cc ff ff       	call   80103860 <mycpu>
80106bb2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106bb6:	8b 73 08             	mov    0x8(%ebx),%esi
80106bb9:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106bbf:	e8 9c cc ff ff       	call   80103860 <mycpu>
80106bc4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106bc7:	e8 94 cc ff ff       	call   80103860 <mycpu>
80106bcc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106bd0:	b8 28 00 00 00       	mov    $0x28,%eax
80106bd5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106bd8:	8b 43 04             	mov    0x4(%ebx),%eax
80106bdb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106be0:	0f 22 d8             	mov    %eax,%cr3
}
80106be3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106be6:	5b                   	pop    %ebx
80106be7:	5e                   	pop    %esi
80106be8:	5f                   	pop    %edi
80106be9:	5d                   	pop    %ebp
  popcli();
80106bea:	e9 91 da ff ff       	jmp    80104680 <popcli>
    panic("switchuvm: no process");
80106bef:	83 ec 0c             	sub    $0xc,%esp
80106bf2:	68 5e 7b 10 80       	push   $0x80107b5e
80106bf7:	e8 94 97 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106bfc:	83 ec 0c             	sub    $0xc,%esp
80106bff:	68 89 7b 10 80       	push   $0x80107b89
80106c04:	e8 87 97 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106c09:	83 ec 0c             	sub    $0xc,%esp
80106c0c:	68 74 7b 10 80       	push   $0x80107b74
80106c11:	e8 7a 97 ff ff       	call   80100390 <panic>
80106c16:	8d 76 00             	lea    0x0(%esi),%esi
80106c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c20 <inituvm>:
{
80106c20:	55                   	push   %ebp
80106c21:	89 e5                	mov    %esp,%ebp
80106c23:	57                   	push   %edi
80106c24:	56                   	push   %esi
80106c25:	53                   	push   %ebx
80106c26:	83 ec 1c             	sub    $0x1c,%esp
80106c29:	8b 45 08             	mov    0x8(%ebp),%eax
80106c2c:	8b 75 10             	mov    0x10(%ebp),%esi
80106c2f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106c32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106c35:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106c3b:	77 49                	ja     80106c86 <inituvm+0x66>
  mem = kalloc();
80106c3d:	e8 7e b9 ff ff       	call   801025c0 <kalloc>
  memset(mem, 0, PGSIZE);
80106c42:	83 ec 04             	sub    $0x4,%esp
80106c45:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106c4a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106c4c:	6a 00                	push   $0x0
80106c4e:	50                   	push   %eax
80106c4f:	e8 dc da ff ff       	call   80104730 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106c54:	58                   	pop    %eax
80106c55:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c5b:	5a                   	pop    %edx
80106c5c:	6a 06                	push   $0x6
80106c5e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c63:	31 d2                	xor    %edx,%edx
80106c65:	50                   	push   %eax
80106c66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c69:	e8 c2 fc ff ff       	call   80106930 <mappages>
  memmove(mem, init, sz);
80106c6e:	89 75 10             	mov    %esi,0x10(%ebp)
80106c71:	83 c4 10             	add    $0x10,%esp
80106c74:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106c77:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106c7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c7d:	5b                   	pop    %ebx
80106c7e:	5e                   	pop    %esi
80106c7f:	5f                   	pop    %edi
80106c80:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106c81:	e9 4a db ff ff       	jmp    801047d0 <memmove>
    panic("inituvm: more than a page");
80106c86:	83 ec 0c             	sub    $0xc,%esp
80106c89:	68 9d 7b 10 80       	push   $0x80107b9d
80106c8e:	e8 fd 96 ff ff       	call   80100390 <panic>
80106c93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ca0 <loaduvm>:
{
80106ca0:	55                   	push   %ebp
80106ca1:	89 e5                	mov    %esp,%ebp
80106ca3:	57                   	push   %edi
80106ca4:	56                   	push   %esi
80106ca5:	53                   	push   %ebx
80106ca6:	83 ec 1c             	sub    $0x1c,%esp
80106ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106cac:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106caf:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106cb4:	0f 85 8d 00 00 00    	jne    80106d47 <loaduvm+0xa7>
80106cba:	01 f0                	add    %esi,%eax
  for(i = 0; i < sz; i += PGSIZE){
80106cbc:	89 f3                	mov    %esi,%ebx
80106cbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106cc1:	8b 45 14             	mov    0x14(%ebp),%eax
80106cc4:	01 f0                	add    %esi,%eax
80106cc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106cc9:	85 f6                	test   %esi,%esi
80106ccb:	75 11                	jne    80106cde <loaduvm+0x3e>
80106ccd:	eb 61                	jmp    80106d30 <loaduvm+0x90>
80106ccf:	90                   	nop
80106cd0:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106cd6:	89 f0                	mov    %esi,%eax
80106cd8:	29 d8                	sub    %ebx,%eax
80106cda:	39 c6                	cmp    %eax,%esi
80106cdc:	76 52                	jbe    80106d30 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106cde:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106ce1:	8b 45 08             	mov    0x8(%ebp),%eax
80106ce4:	31 c9                	xor    %ecx,%ecx
80106ce6:	29 da                	sub    %ebx,%edx
80106ce8:	e8 c3 fb ff ff       	call   801068b0 <walkpgdir>
80106ced:	85 c0                	test   %eax,%eax
80106cef:	74 49                	je     80106d3a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106cf1:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106cf3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106cf6:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106cfb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106d00:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106d06:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d09:	29 d9                	sub    %ebx,%ecx
80106d0b:	05 00 00 00 80       	add    $0x80000000,%eax
80106d10:	57                   	push   %edi
80106d11:	51                   	push   %ecx
80106d12:	50                   	push   %eax
80106d13:	ff 75 10             	pushl  0x10(%ebp)
80106d16:	e8 f5 ac ff ff       	call   80101a10 <readi>
80106d1b:	83 c4 10             	add    $0x10,%esp
80106d1e:	39 f8                	cmp    %edi,%eax
80106d20:	74 ae                	je     80106cd0 <loaduvm+0x30>
}
80106d22:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106d25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d2a:	5b                   	pop    %ebx
80106d2b:	5e                   	pop    %esi
80106d2c:	5f                   	pop    %edi
80106d2d:	5d                   	pop    %ebp
80106d2e:	c3                   	ret    
80106d2f:	90                   	nop
80106d30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106d33:	31 c0                	xor    %eax,%eax
}
80106d35:	5b                   	pop    %ebx
80106d36:	5e                   	pop    %esi
80106d37:	5f                   	pop    %edi
80106d38:	5d                   	pop    %ebp
80106d39:	c3                   	ret    
      panic("loaduvm: address should exist");
80106d3a:	83 ec 0c             	sub    $0xc,%esp
80106d3d:	68 b7 7b 10 80       	push   $0x80107bb7
80106d42:	e8 49 96 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106d47:	83 ec 0c             	sub    $0xc,%esp
80106d4a:	68 58 7c 10 80       	push   $0x80107c58
80106d4f:	e8 3c 96 ff ff       	call   80100390 <panic>
80106d54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106d60 <allocuvm>:
{
80106d60:	55                   	push   %ebp
80106d61:	89 e5                	mov    %esp,%ebp
80106d63:	57                   	push   %edi
80106d64:	56                   	push   %esi
80106d65:	53                   	push   %ebx
80106d66:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106d69:	8b 7d 10             	mov    0x10(%ebp),%edi
80106d6c:	85 ff                	test   %edi,%edi
80106d6e:	0f 88 bc 00 00 00    	js     80106e30 <allocuvm+0xd0>
  if(newsz < oldsz)
80106d74:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106d77:	0f 82 a3 00 00 00    	jb     80106e20 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d80:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106d86:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106d8c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106d8f:	0f 86 8e 00 00 00    	jbe    80106e23 <allocuvm+0xc3>
80106d95:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106d98:	8b 7d 08             	mov    0x8(%ebp),%edi
80106d9b:	eb 42                	jmp    80106ddf <allocuvm+0x7f>
80106d9d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106da0:	83 ec 04             	sub    $0x4,%esp
80106da3:	68 00 10 00 00       	push   $0x1000
80106da8:	6a 00                	push   $0x0
80106daa:	50                   	push   %eax
80106dab:	e8 80 d9 ff ff       	call   80104730 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106db0:	58                   	pop    %eax
80106db1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106db7:	5a                   	pop    %edx
80106db8:	6a 06                	push   $0x6
80106dba:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106dbf:	89 da                	mov    %ebx,%edx
80106dc1:	50                   	push   %eax
80106dc2:	89 f8                	mov    %edi,%eax
80106dc4:	e8 67 fb ff ff       	call   80106930 <mappages>
80106dc9:	83 c4 10             	add    $0x10,%esp
80106dcc:	85 c0                	test   %eax,%eax
80106dce:	78 70                	js     80106e40 <allocuvm+0xe0>
  for(; a < newsz; a += PGSIZE){
80106dd0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106dd6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106dd9:	0f 86 a1 00 00 00    	jbe    80106e80 <allocuvm+0x120>
    mem = kalloc();
80106ddf:	e8 dc b7 ff ff       	call   801025c0 <kalloc>
80106de4:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106de6:	85 c0                	test   %eax,%eax
80106de8:	75 b6                	jne    80106da0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106dea:	83 ec 0c             	sub    $0xc,%esp
80106ded:	68 d5 7b 10 80       	push   $0x80107bd5
80106df2:	e8 b9 98 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106df7:	83 c4 10             	add    $0x10,%esp
80106dfa:	8b 45 0c             	mov    0xc(%ebp),%eax
80106dfd:	39 45 10             	cmp    %eax,0x10(%ebp)
80106e00:	74 2e                	je     80106e30 <allocuvm+0xd0>
80106e02:	89 c1                	mov    %eax,%ecx
80106e04:	8b 55 10             	mov    0x10(%ebp),%edx
80106e07:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80106e0a:	31 ff                	xor    %edi,%edi
80106e0c:	e8 af fb ff ff       	call   801069c0 <deallocuvm.part.0>
}
80106e11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e14:	89 f8                	mov    %edi,%eax
80106e16:	5b                   	pop    %ebx
80106e17:	5e                   	pop    %esi
80106e18:	5f                   	pop    %edi
80106e19:	5d                   	pop    %ebp
80106e1a:	c3                   	ret    
80106e1b:	90                   	nop
80106e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80106e20:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80106e23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e26:	89 f8                	mov    %edi,%eax
80106e28:	5b                   	pop    %ebx
80106e29:	5e                   	pop    %esi
80106e2a:	5f                   	pop    %edi
80106e2b:	5d                   	pop    %ebp
80106e2c:	c3                   	ret    
80106e2d:	8d 76 00             	lea    0x0(%esi),%esi
80106e30:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106e33:	31 ff                	xor    %edi,%edi
}
80106e35:	5b                   	pop    %ebx
80106e36:	89 f8                	mov    %edi,%eax
80106e38:	5e                   	pop    %esi
80106e39:	5f                   	pop    %edi
80106e3a:	5d                   	pop    %ebp
80106e3b:	c3                   	ret    
80106e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
80106e40:	83 ec 0c             	sub    $0xc,%esp
80106e43:	68 ed 7b 10 80       	push   $0x80107bed
80106e48:	e8 63 98 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106e4d:	83 c4 10             	add    $0x10,%esp
80106e50:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e53:	39 45 10             	cmp    %eax,0x10(%ebp)
80106e56:	74 0d                	je     80106e65 <allocuvm+0x105>
80106e58:	89 c1                	mov    %eax,%ecx
80106e5a:	8b 55 10             	mov    0x10(%ebp),%edx
80106e5d:	8b 45 08             	mov    0x8(%ebp),%eax
80106e60:	e8 5b fb ff ff       	call   801069c0 <deallocuvm.part.0>
      kfree(mem);
80106e65:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80106e68:	31 ff                	xor    %edi,%edi
      kfree(mem);
80106e6a:	56                   	push   %esi
80106e6b:	e8 90 b5 ff ff       	call   80102400 <kfree>
      return 0;
80106e70:	83 c4 10             	add    $0x10,%esp
}
80106e73:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e76:	89 f8                	mov    %edi,%eax
80106e78:	5b                   	pop    %ebx
80106e79:	5e                   	pop    %esi
80106e7a:	5f                   	pop    %edi
80106e7b:	5d                   	pop    %ebp
80106e7c:	c3                   	ret    
80106e7d:	8d 76 00             	lea    0x0(%esi),%esi
80106e80:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106e83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e86:	5b                   	pop    %ebx
80106e87:	5e                   	pop    %esi
80106e88:	89 f8                	mov    %edi,%eax
80106e8a:	5f                   	pop    %edi
80106e8b:	5d                   	pop    %ebp
80106e8c:	c3                   	ret    
80106e8d:	8d 76 00             	lea    0x0(%esi),%esi

80106e90 <deallocuvm>:
{
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e96:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106e99:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106e9c:	39 d1                	cmp    %edx,%ecx
80106e9e:	73 10                	jae    80106eb0 <deallocuvm+0x20>
}
80106ea0:	5d                   	pop    %ebp
80106ea1:	e9 1a fb ff ff       	jmp    801069c0 <deallocuvm.part.0>
80106ea6:	8d 76 00             	lea    0x0(%esi),%esi
80106ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106eb0:	89 d0                	mov    %edx,%eax
80106eb2:	5d                   	pop    %ebp
80106eb3:	c3                   	ret    
80106eb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106eba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106ec0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106ec0:	55                   	push   %ebp
80106ec1:	89 e5                	mov    %esp,%ebp
80106ec3:	57                   	push   %edi
80106ec4:	56                   	push   %esi
80106ec5:	53                   	push   %ebx
80106ec6:	83 ec 0c             	sub    $0xc,%esp
80106ec9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106ecc:	85 f6                	test   %esi,%esi
80106ece:	74 59                	je     80106f29 <freevm+0x69>
  if(newsz >= oldsz)
80106ed0:	31 c9                	xor    %ecx,%ecx
80106ed2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106ed7:	89 f0                	mov    %esi,%eax
80106ed9:	89 f3                	mov    %esi,%ebx
80106edb:	e8 e0 fa ff ff       	call   801069c0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106ee0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106ee6:	eb 0f                	jmp    80106ef7 <freevm+0x37>
80106ee8:	90                   	nop
80106ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ef0:	83 c3 04             	add    $0x4,%ebx
80106ef3:	39 df                	cmp    %ebx,%edi
80106ef5:	74 23                	je     80106f1a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106ef7:	8b 03                	mov    (%ebx),%eax
80106ef9:	a8 01                	test   $0x1,%al
80106efb:	74 f3                	je     80106ef0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106efd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106f02:	83 ec 0c             	sub    $0xc,%esp
80106f05:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106f08:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106f0d:	50                   	push   %eax
80106f0e:	e8 ed b4 ff ff       	call   80102400 <kfree>
80106f13:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106f16:	39 df                	cmp    %ebx,%edi
80106f18:	75 dd                	jne    80106ef7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106f1a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106f1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f20:	5b                   	pop    %ebx
80106f21:	5e                   	pop    %esi
80106f22:	5f                   	pop    %edi
80106f23:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106f24:	e9 d7 b4 ff ff       	jmp    80102400 <kfree>
    panic("freevm: no pgdir");
80106f29:	83 ec 0c             	sub    $0xc,%esp
80106f2c:	68 09 7c 10 80       	push   $0x80107c09
80106f31:	e8 5a 94 ff ff       	call   80100390 <panic>
80106f36:	8d 76 00             	lea    0x0(%esi),%esi
80106f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f40 <setupkvm>:
{
80106f40:	55                   	push   %ebp
80106f41:	89 e5                	mov    %esp,%ebp
80106f43:	56                   	push   %esi
80106f44:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106f45:	e8 76 b6 ff ff       	call   801025c0 <kalloc>
80106f4a:	89 c6                	mov    %eax,%esi
80106f4c:	85 c0                	test   %eax,%eax
80106f4e:	74 42                	je     80106f92 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80106f50:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106f53:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106f58:	68 00 10 00 00       	push   $0x1000
80106f5d:	6a 00                	push   $0x0
80106f5f:	50                   	push   %eax
80106f60:	e8 cb d7 ff ff       	call   80104730 <memset>
80106f65:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106f68:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106f6b:	83 ec 08             	sub    $0x8,%esp
80106f6e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106f71:	ff 73 0c             	pushl  0xc(%ebx)
80106f74:	8b 13                	mov    (%ebx),%edx
80106f76:	50                   	push   %eax
80106f77:	29 c1                	sub    %eax,%ecx
80106f79:	89 f0                	mov    %esi,%eax
80106f7b:	e8 b0 f9 ff ff       	call   80106930 <mappages>
80106f80:	83 c4 10             	add    $0x10,%esp
80106f83:	85 c0                	test   %eax,%eax
80106f85:	78 19                	js     80106fa0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106f87:	83 c3 10             	add    $0x10,%ebx
80106f8a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106f90:	75 d6                	jne    80106f68 <setupkvm+0x28>
}
80106f92:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f95:	89 f0                	mov    %esi,%eax
80106f97:	5b                   	pop    %ebx
80106f98:	5e                   	pop    %esi
80106f99:	5d                   	pop    %ebp
80106f9a:	c3                   	ret    
80106f9b:	90                   	nop
80106f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80106fa0:	83 ec 0c             	sub    $0xc,%esp
80106fa3:	56                   	push   %esi
      return 0;
80106fa4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106fa6:	e8 15 ff ff ff       	call   80106ec0 <freevm>
      return 0;
80106fab:	83 c4 10             	add    $0x10,%esp
}
80106fae:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106fb1:	89 f0                	mov    %esi,%eax
80106fb3:	5b                   	pop    %ebx
80106fb4:	5e                   	pop    %esi
80106fb5:	5d                   	pop    %ebp
80106fb6:	c3                   	ret    
80106fb7:	89 f6                	mov    %esi,%esi
80106fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fc0 <kvmalloc>:
{
80106fc0:	55                   	push   %ebp
80106fc1:	89 e5                	mov    %esp,%ebp
80106fc3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106fc6:	e8 75 ff ff ff       	call   80106f40 <setupkvm>
80106fcb:	a3 a4 55 11 80       	mov    %eax,0x801155a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106fd0:	05 00 00 00 80       	add    $0x80000000,%eax
80106fd5:	0f 22 d8             	mov    %eax,%cr3
}
80106fd8:	c9                   	leave  
80106fd9:	c3                   	ret    
80106fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106fe0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106fe0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106fe1:	31 c9                	xor    %ecx,%ecx
{
80106fe3:	89 e5                	mov    %esp,%ebp
80106fe5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106fe8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106feb:	8b 45 08             	mov    0x8(%ebp),%eax
80106fee:	e8 bd f8 ff ff       	call   801068b0 <walkpgdir>
  if(pte == 0)
80106ff3:	85 c0                	test   %eax,%eax
80106ff5:	74 05                	je     80106ffc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106ff7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106ffa:	c9                   	leave  
80106ffb:	c3                   	ret    
    panic("clearpteu");
80106ffc:	83 ec 0c             	sub    $0xc,%esp
80106fff:	68 1a 7c 10 80       	push   $0x80107c1a
80107004:	e8 87 93 ff ff       	call   80100390 <panic>
80107009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107010 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	57                   	push   %edi
80107014:	56                   	push   %esi
80107015:	53                   	push   %ebx
80107016:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107019:	e8 22 ff ff ff       	call   80106f40 <setupkvm>
8010701e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107021:	85 c0                	test   %eax,%eax
80107023:	0f 84 a0 00 00 00    	je     801070c9 <copyuvm+0xb9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107029:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010702c:	85 c9                	test   %ecx,%ecx
8010702e:	0f 84 95 00 00 00    	je     801070c9 <copyuvm+0xb9>
80107034:	31 f6                	xor    %esi,%esi
80107036:	eb 4e                	jmp    80107086 <copyuvm+0x76>
80107038:	90                   	nop
80107039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107040:	83 ec 04             	sub    $0x4,%esp
80107043:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107049:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010704c:	68 00 10 00 00       	push   $0x1000
80107051:	57                   	push   %edi
80107052:	50                   	push   %eax
80107053:	e8 78 d7 ff ff       	call   801047d0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107058:	58                   	pop    %eax
80107059:	5a                   	pop    %edx
8010705a:	53                   	push   %ebx
8010705b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010705e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107061:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107066:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010706c:	52                   	push   %edx
8010706d:	89 f2                	mov    %esi,%edx
8010706f:	e8 bc f8 ff ff       	call   80106930 <mappages>
80107074:	83 c4 10             	add    $0x10,%esp
80107077:	85 c0                	test   %eax,%eax
80107079:	78 39                	js     801070b4 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
8010707b:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107081:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107084:	76 43                	jbe    801070c9 <copyuvm+0xb9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107086:	8b 45 08             	mov    0x8(%ebp),%eax
80107089:	31 c9                	xor    %ecx,%ecx
8010708b:	89 f2                	mov    %esi,%edx
8010708d:	e8 1e f8 ff ff       	call   801068b0 <walkpgdir>
80107092:	85 c0                	test   %eax,%eax
80107094:	74 3e                	je     801070d4 <copyuvm+0xc4>
    if(!(*pte & PTE_P))
80107096:	8b 18                	mov    (%eax),%ebx
80107098:	f6 c3 01             	test   $0x1,%bl
8010709b:	74 44                	je     801070e1 <copyuvm+0xd1>
    pa = PTE_ADDR(*pte);
8010709d:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
8010709f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
801070a5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801070ab:	e8 10 b5 ff ff       	call   801025c0 <kalloc>
801070b0:	85 c0                	test   %eax,%eax
801070b2:	75 8c                	jne    80107040 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
801070b4:	83 ec 0c             	sub    $0xc,%esp
801070b7:	ff 75 e0             	pushl  -0x20(%ebp)
801070ba:	e8 01 fe ff ff       	call   80106ec0 <freevm>
  return 0;
801070bf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801070c6:	83 c4 10             	add    $0x10,%esp
}
801070c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801070cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070cf:	5b                   	pop    %ebx
801070d0:	5e                   	pop    %esi
801070d1:	5f                   	pop    %edi
801070d2:	5d                   	pop    %ebp
801070d3:	c3                   	ret    
      panic("copyuvm: pte should exist");
801070d4:	83 ec 0c             	sub    $0xc,%esp
801070d7:	68 24 7c 10 80       	push   $0x80107c24
801070dc:	e8 af 92 ff ff       	call   80100390 <panic>
      panic("copyuvm: page not present");
801070e1:	83 ec 0c             	sub    $0xc,%esp
801070e4:	68 3e 7c 10 80       	push   $0x80107c3e
801070e9:	e8 a2 92 ff ff       	call   80100390 <panic>
801070ee:	66 90                	xchg   %ax,%ax

801070f0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801070f0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801070f1:	31 c9                	xor    %ecx,%ecx
{
801070f3:	89 e5                	mov    %esp,%ebp
801070f5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801070f8:	8b 55 0c             	mov    0xc(%ebp),%edx
801070fb:	8b 45 08             	mov    0x8(%ebp),%eax
801070fe:	e8 ad f7 ff ff       	call   801068b0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107103:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107105:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107106:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107108:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010710d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107110:	05 00 00 00 80       	add    $0x80000000,%eax
80107115:	83 fa 05             	cmp    $0x5,%edx
80107118:	ba 00 00 00 00       	mov    $0x0,%edx
8010711d:	0f 45 c2             	cmovne %edx,%eax
}
80107120:	c3                   	ret    
80107121:	eb 0d                	jmp    80107130 <copyout>
80107123:	90                   	nop
80107124:	90                   	nop
80107125:	90                   	nop
80107126:	90                   	nop
80107127:	90                   	nop
80107128:	90                   	nop
80107129:	90                   	nop
8010712a:	90                   	nop
8010712b:	90                   	nop
8010712c:	90                   	nop
8010712d:	90                   	nop
8010712e:	90                   	nop
8010712f:	90                   	nop

80107130 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107130:	55                   	push   %ebp
80107131:	89 e5                	mov    %esp,%ebp
80107133:	57                   	push   %edi
80107134:	56                   	push   %esi
80107135:	53                   	push   %ebx
80107136:	83 ec 0c             	sub    $0xc,%esp
80107139:	8b 75 14             	mov    0x14(%ebp),%esi
8010713c:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010713f:	85 f6                	test   %esi,%esi
80107141:	75 38                	jne    8010717b <copyout+0x4b>
80107143:	eb 6b                	jmp    801071b0 <copyout+0x80>
80107145:	8d 76 00             	lea    0x0(%esi),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107148:	8b 55 0c             	mov    0xc(%ebp),%edx
8010714b:	89 fb                	mov    %edi,%ebx
8010714d:	29 d3                	sub    %edx,%ebx
8010714f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107155:	39 f3                	cmp    %esi,%ebx
80107157:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
8010715a:	29 fa                	sub    %edi,%edx
8010715c:	83 ec 04             	sub    $0x4,%esp
8010715f:	01 c2                	add    %eax,%edx
80107161:	53                   	push   %ebx
80107162:	ff 75 10             	pushl  0x10(%ebp)
80107165:	52                   	push   %edx
80107166:	e8 65 d6 ff ff       	call   801047d0 <memmove>
    len -= n;
    buf += n;
8010716b:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
8010716e:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80107174:	83 c4 10             	add    $0x10,%esp
80107177:	29 de                	sub    %ebx,%esi
80107179:	74 35                	je     801071b0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
8010717b:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
8010717d:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107180:	89 55 0c             	mov    %edx,0xc(%ebp)
80107183:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107189:	57                   	push   %edi
8010718a:	ff 75 08             	pushl  0x8(%ebp)
8010718d:	e8 5e ff ff ff       	call   801070f0 <uva2ka>
    if(pa0 == 0)
80107192:	83 c4 10             	add    $0x10,%esp
80107195:	85 c0                	test   %eax,%eax
80107197:	75 af                	jne    80107148 <copyout+0x18>
  }
  return 0;
}
80107199:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010719c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801071a1:	5b                   	pop    %ebx
801071a2:	5e                   	pop    %esi
801071a3:	5f                   	pop    %edi
801071a4:	5d                   	pop    %ebp
801071a5:	c3                   	ret    
801071a6:	8d 76 00             	lea    0x0(%esi),%esi
801071a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801071b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801071b3:	31 c0                	xor    %eax,%eax
}
801071b5:	5b                   	pop    %ebx
801071b6:	5e                   	pop    %esi
801071b7:	5f                   	pop    %edi
801071b8:	5d                   	pop    %ebp
801071b9:	c3                   	ret    
