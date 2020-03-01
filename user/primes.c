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
        // Parent
        redirect(1, fd);
        source();
    } else {
        // Child
        redirect(0, fd);
        sieve();
    }
    exit(0);
}

void sieve() {
    int n;
    read(0, &n, sizeof(n));
    if (n != 0) {
        printf("%d: Prime %d \n", getpid(), n);
        int fd[2];
        int z = pipe(fd);
        if (z < 0) {
            // fprintf(2, "error in creating pipe in sieve %d\n", n);
            return;
        } else {
            // fprintf(2, "sucessfully created pipe in sieve %d\n", n);
        }
        if (fork()) {
            redirect(1, fd);
            for (;;) {
                int p;
                int x = read(0, &p, sizeof(p));
                if (x <= 0) {
                    // fprintf(2, "error reading in sieve %d\n", n);
                    return;
                }
                if (p % n != 0) {
                    // fprintf(2, "writing %d in sieve %d\n", p, n);
                    write(1, &p, sizeof(p));
                }
            }
        } else {
            redirect(0, fd);
            sieve();
        }
    }
}

void source() {
    int n;
    for (n = 2; n < 100; n++) {
        write(1, &n, sizeof(n));
    }
}

void redirect(int new_fd, int pipe[2]) {
    close(new_fd);
    dup(pipe[new_fd]);
    close(pipe[0]);
    close(pipe[1]);
}