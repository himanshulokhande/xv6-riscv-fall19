#include <stddef.h>
#include "kernel/types.h"
#include "user/user.h"

void sieve(void);
void source(void);
void redirect(int new_fd, int pipe[2]);

int main(int argc, char* argv[]) {
    int fd[2];
    pipe(fd);
    if (fork()) {
        redirect(1, fd);
        source();
        close(1);
        wait(NULL);
    } else {
        redirect(0, fd);
        sieve();
    }
    exit(0);
}

// sieve is used to filter out the numbers which are divisible by the current
// number and create a new process for each prime number
void sieve() {
    int n;
    read(0, &n, sizeof(n));
    if (n != 0) {
        printf("Prime %d \n", n);
        int fd[2];
        if (pipe(fd) < 0) {
            return;
        }
        int id = fork();
        if (id < 0) {
            fprintf(2, "failed to create a new process in sieve %d \n", n);
            return;
        }
        if (id > 0) {
            redirect(1, fd);
            for (;;) {
                int p;
                if (read(0, &p, sizeof(p)) <= 0) {
                    break;
                }
                if (p % n != 0) {
                    write(1, &p, sizeof(p));
                }
            }
        } else {
            redirect(0, fd);
            sieve();
        }
    }
}

// generates numbers from 2 to 35 and writes it to stdout
void source() {
    int n;
    for (n = 2; n <= 35; n++) {
        write(1, &n, sizeof(n));
    }
}

// replaces the file descriptor in the pipe with the new file descriptor(which
// is either 0 or 1) and closes the old file descriptors
void redirect(int new_fd, int pipe[2]) {
    close(new_fd);
    dup(pipe[new_fd]);
    close(pipe[0]);
    close(pipe[1]);
}