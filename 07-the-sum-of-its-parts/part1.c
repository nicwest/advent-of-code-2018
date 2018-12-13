#include <stdio.h>


#define TOTAL_NODES 26

unsigned int nodes[TOTAL_NODES];
unsigned int deps[TOTAL_NODES][TOTAL_NODES];

int all(unsigned int col[TOTAL_NODES]) {
    for(int i=0; i<TOTAL_NODES; i++) {
        if(!col[i])
            return 0;
    }
    return 1;
}

void init() {
    for (int i=0; i<TOTAL_NODES; i++) {
        nodes[i] = 0;
        for(int j=0; j<TOTAL_NODES; j++) {
            deps[i][j] = 0;
        }
    }
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

    int a = 0;
    int b = 1/a;

    while(!all(nodes)) {
        for(int i=0; i<TOTAL_NODES; i++) {
            if(nodes[i])
                continue;

            int ready = 1;
            for(int j=0; j<TOTAL_NODES; j++) {
                if(deps[i][j]) {
                    if(!nodes[j]) {
                        ready = 0;
                        break;
                    }
                }
            }
            if(ready) {
                nodes[i] = 1;
                printf("%c", (char)(i + 65));
                break;
            }
        }
    }
    printf("\n");
}
