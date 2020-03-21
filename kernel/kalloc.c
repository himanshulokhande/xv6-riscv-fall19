// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
}kmem[NCPU];

void
kinit()
{
  for(int i=0;i<NCPU;i++){
    initlock(&kmem[i].lock,"kmem"+i);  
  }
  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
}

// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;
  push_off();           //disable interrupts
  int i=cpuid();        //get cpuid
  pop_off();            //enable interrupts
  acquire(&kmem[i].lock);
  r->next = kmem[i].freelist;
  kmem[i].freelist = r;
  release(&kmem[i].lock);
  
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;
  push_off();     //disable interupts
  int i=cpuid();  //obtain cpuid
  pop_off();      //enable interrupts
  acquire(&kmem[i].lock); //acquire corresponding lock
  r = kmem[i].freelist;   //get address of top of freelist
  if(r){
    kmem[i].freelist = r->next;
  }else{
    //steal
    r=steal(i);
  }

  if(r){
    kmem[i].freelist = r->next;
  }
   
  release(&kmem[i].lock);
  
  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
  return (void*)r;
}

//Steal pages from other CPU freelist
//id is CPUID of the cpu that initiates stealing
void * steal(int id){
  struct run *p;
  int flag=0;     //checks if stealing occurred or not

  for(int i=0; i<NCPU; i++){
    
    if(kmem[i].freelist){
      flag=1;
      acquire(&kmem[i].lock);
      p = kmem[i].freelist;
      kmem[id].freelist=p;
      for(int x=0;x < 100 && p->next;x++){
        p = p->next;
      }
      kmem[i].freelist=p->next;
      p->next=0;
      release(&kmem[i].lock);
      break;
    }

  }
  if(!flag){
    return 0;
  }

  return (void *)kmem[id].freelist;
} 
