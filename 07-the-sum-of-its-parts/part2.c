#include <stdio.h>


#define TOTAL_TASKS 26
#define TOTAL_WORKERS 5

unsigned int tasks[TOTAL_TASKS];
unsigned int deps[TOTAL_TASKS][TOTAL_TASKS];
int workers[TOTAL_WORKERS];

int any(unsigned int col[TOTAL_TASKS]) {
    for(int i=0; i<TOTAL_TASKS; i++) {
        if(col[i] > 0)
            return 1;
    }
    return 0;
}

void init() {
    for (int i=0; i<TOTAL_TASKS; i++) {
        tasks[i] =  i + 60 + 1;
        for(int j=0; j<TOTAL_TASKS; j++) {
            deps[i][j] = 0;
        }
    }

    for (int i=0; i<TOTAL_WORKERS; i++) {
        workers[i] = -1;
    }
}



int is_being_worked_on(int n) {
    for (int i=0; i < TOTAL_WORKERS; i++) {
        if(workers[i] == n) {
            return 1;
        }
    }
    return 0;
}

int what_worker(int n){
    for(int i=0; i<TOTAL_WORKERS; i++) {
        if(workers[i] == n) {
            return i;
        }
    }
    return -1;
}

int next_worker(){
    for(int i=0; i<TOTAL_WORKERS; i++) {
        if(workers[i] == -1) {
            return i;
        }
    }
    return -1;
}

int main() {
    init();
    char *line = NULL;
    size_t size;
    while(getline(&line, &size, stdin) != -1) {
        int A, B;
        A = line[5] - 65;
        B = line[36] - 65;
        deps[B][A] = 1;
    }

    int seconds = 0;

    /* this while loop should represent a second */
    while(any(tasks)) {

        for(int i=0; i<TOTAL_TASKS; i++) {
            if(is_being_worked_on(i)) {
                if(tasks[i])
                    tasks[i]--;
            }
        }

        for(int i=0; i<TOTAL_TASKS; i++) {
            if(is_being_worked_on(i)) {
                /* if there is work to do then do some work! */
                if(!tasks[i])
                    workers[what_worker(i)] = -1;
            }
        }

        for(int i=0; i<TOTAL_TASKS; i++) {
            /* when the task is already finished we can skip it */
            if(!tasks[i]) {
                continue;
            }


            /* get the next available worker */
            int next = next_worker();

            /* when this task is not being worked on already and there are no
             * available workers then skip it */
            if(!is_being_worked_on(i) && next == -1)
                continue;

            /* check if all the tasks dependancies are completed and the task
             * is ready to be worked on */
            int ready = 1;
            for(int j=0; j<TOTAL_TASKS; j++) {
                if(deps[i][j]) {
                    if(tasks[j]) {
                        ready = 0;
                        break;
                    }
                }
            }

            /* if it's not ready then we can skip it */
            if(!ready)
                continue;

            /* if this is not being worked on then we assign a worker */
            if(!is_being_worked_on(i)) {
                workers[next] = i;
            }

        }
        seconds++;
    }
    printf("\nseconds: %d\n", seconds -1);
}
