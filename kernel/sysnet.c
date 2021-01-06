//
// network system calls.
//

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"
#include "fs.h"
#include "sleeplock.h"
#include "file.h"
#include "net.h"

struct sock {
  struct sock *next; // the next socket in the list
  uint32 raddr;      // the remote IPv4 address
  uint16 lport;      // the local UDP port number
  uint16 rport;      // the remote UDP port number
  struct spinlock lock; // protects the rxq
  struct mbufq rxq;  // a queue of packets waiting to be received
};

static struct spinlock lock;
static struct sock *sockets;

void
sockinit(void)
{
  initlock(&lock, "socktbl");
}

int
sockalloc(struct file **f, uint32 raddr, uint16 lport, uint16 rport)
{
  struct sock *si, *pos;

  si = 0;
  *f = 0;
  if ((*f = filealloc()) == 0)
    goto bad;
  if ((si = (struct sock*)kalloc()) == 0)
    goto bad;

  // initialize objects
  si->raddr = raddr;
  si->lport = lport;
  si->rport = rport;
  initlock(&si->lock, "sock");
  mbufq_init(&si->rxq);
  (*f)->type = FD_SOCK;
  (*f)->readable = 1;
  (*f)->writable = 1;
  (*f)->sock = si;

  // add to list of sockets
  acquire(&lock);
  pos = sockets;
  while (pos) {
    if (pos->raddr == raddr &&
        pos->lport == lport &&
	pos->rport == rport) {
      release(&lock);
      goto bad;
    }
    pos = pos->next;
  }
  si->next = sockets;
  sockets = si;
  release(&lock);
  return 0;

bad:
  if (si)
    kfree((char*)si);
  if (*f)
    fileclose(*f);
  return -1;
}

//
// Your code here.
//
// Add and wire in methods to handle closing, reading,
// and writing for network sockets.
//

//read sockets
int
sockread(struct sock *f,uint64 addr, int n){

  acquire(&f->lock);
  struct mbufq *p= &f->rxq;

  //check if rxq is empty, if empty sleep
  while(mbufq_empty(p) == 1){
    sleep(f,&f->lock);
  }
  //obtain mbuf
  struct mbuf *head = mbufq_pophead(p);
  
  struct proc *process = myproc();
  //copy data from head->head to addr
  if(copyout(process->pagetable,addr,head->head,head->len) == -1){
    return -1;
  }
  n=head->len;
  mbuffree(head);
  release(&f->lock);

  return n;
}

//write sockets
int
sockwrite(struct sock *f,uint64 addr,int n){
  acquire(&lock);
  //allocate new mbuf
  struct mbuf *b = mbufalloc(MBUF_DEFAULT_HEADROOM);
  
  struct proc *p = myproc();
  
  //update m->len and return pointer to it
  char *buf = mbufput(b,n);
  
  //copy data to buf from addr
  if(copyin(p->pagetable,buf,addr,n) == -1){
    return -1;
  }
  net_tx_udp(b,f->raddr,f->lport,f->rport);
  release(&lock);
  
  return n;
}

//close sockets
void sockclose(struct sock *f){
  acquire(&lock);
   
  acquire(&f->lock);
  struct mbufq *buf = &f->rxq;
  //check if queue is empty, if not empty free all the packets
  while(mbufq_empty(buf)!=1){
    struct mbuf *head=mbufq_pophead(buf);
    mbuffree(head);
  }
  release(&f->lock);
  struct sock *p=sockets;
  if(p==f){
    sockets=sockets->next;
    kfree(f);
  }else{
    while(p){
      if(p->next == f){
        acquire(&p->lock);
        p->next = f->next;
        kfree(f);
        release(&p->lock);
        break;
      }
    p=p->next;
    }
  }
  release(&lock);
}

// called by protocol handler layer to deliver UDP packets
void
sockrecvudp(struct mbuf *m, uint32 raddr, uint16 lport, uint16 rport)
{
  //
  // Your code here.
  //
  // Find the socket that handles this mbuf and deliver it, waking
  // any sleeping reader. Free the mbuf if there are no sockets
  // registered to handle it.
  //
  acquire(&lock);
  struct sock *pos = sockets;
  while(pos){
    if(pos->raddr == raddr && pos->lport == lport && pos->rport == rport){
      acquire(&pos->lock);
      mbufq_pushtail(&pos->rxq,m);
      release(&pos->lock);
      wakeup(pos);
      release(&lock);
      return;
    }
    pos=pos->next;
  }
  mbuffree(m);
  release(&lock);
}
