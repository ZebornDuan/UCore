#include <defs.h>
#include <list.h>
#include <proc.h>
#include <assert.h>
#include <cfs_sched.h>

#define USE_SKEW_HEAP 1

static int proc_cfs_comp_f(void *a, void *b) {
     struct proc_struct *p = le2proc(a, fair_run_pool);
     struct proc_struct *q = le2proc(b, fair_run_pool);
     int32_t c = p->fair_run_time - q->fair_run_time;
     if (c > 0)
    	 return 1;
     else if (c == 0)
    	 return 0;
     else
    	 return -1;
}

static void cfs_init(struct run_queue *rq) {
    rq->fair_run_pool = NULL;
    rq->proc_num = 0;
}

static void cfs_enqueue(struct run_queue *rq, struct proc_struct *proc) {
    rq->fair_run_pool = skew_heap_insert(rq->fair_run_pool, &(proc->fair_run_pool), proc_cfs_comp_f);
    if (proc->time_slice == 0 || proc->time_slice > rq->max_time_slice)
        proc->time_slice = rq->max_time_slice;
    proc->rq = rq;
    rq->proc_num++;
}

static void cfs_dequeue(struct run_queue *rq, struct proc_struct *proc) {
    rq->fair_run_pool = skew_heap_remove(rq->fair_run_pool, &(proc->fair_run_pool), proc_cfs_comp_f);
    rq->proc_num--;
}

static struct proc_struct *cfs_pick_next(struct run_queue *rq) {
    if (rq->fair_run_pool == NULL)
        return NULL;
    skew_heap_entry_t *le = rq->fair_run_pool;
    struct proc_struct * p = le2proc(le, fair_run_pool);
    return p;
}

static void cfs_proc_tick(struct run_queue *rq, struct proc_struct *proc) {
    if (proc->time_slice > 0) {
        proc->time_slice--;
        proc->fair_run_time += proc->fair_priority;
    }
    if (proc->time_slice == 0)
        proc->need_resched = 1;
}

struct sched_class cfs_sched_class = {
     .name = "completely_fair_scheduler",
     .init = cfs_init,
     .enqueue = cfs_enqueue,
     .dequeue = cfs_dequeue,
     .pick_next = cfs_pick_next,
     .proc_tick = cfs_proc_tick,
};
