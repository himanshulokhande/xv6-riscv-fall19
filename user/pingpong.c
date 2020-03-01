#include "kernel/types.h"
#include "user/user.h"

#define SIZE 64

void print(void *buf);

int main(int argc, char *argv[]) {
    int parent_to_child_fd[2];
    int child_to_parent_fd[2];

    pipe(parent_to_child_fd);
    pipe(child_to_parent_fd);

    if (fork()) {
        // Parent
        write(parent_to_child_fd[1], "ping", 4);
        char buf[SIZE];
        read(child_to_parent_fd[0], buf, sizeof(buf));
        print(buf);
    } else {
        // Child
        char buf[SIZE];
        read(parent_to_child_fd[0], buf, sizeof(buf));
        print(buf);
        write(child_to_parent_fd[1], "pong", 4);
    }
    exit(0);
}

void print(void *buf) { printf("%d: received %s \n", getpid(), buf); }
