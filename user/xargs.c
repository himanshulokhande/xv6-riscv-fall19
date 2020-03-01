#include "kernel/types.h"
#include "kernel/param.h"
#include "user/user.h"

int update_args(int argc, char* argv[]);
void execute(int count, char* args[]);

int main(int argc, char* argv[]) {
    while (update_args(argc, argv))
        ;
    exit(0);
}

int update_args(int argc, char* argv[]) {
    char* args[MAXARG];
    int i;
    int len = 0;
    for (i = 1; i < argc; i++, len++) {
        args[len] = argv[i];
    }
    char c;
    char buf[512];
    char* arg = buf;
    int ret_val;
    while ((ret_val = read(0, &c, sizeof(c))) == sizeof(c)) {
        if (c == '\n') {
            *arg++ = '\0';
            args[len] = (char*)malloc(sizeof(buf));
            strcpy(args[len], buf);
            len++;
            execute(len, args);
            break;
        }
        if (c == ' ') {
            *arg++ = '\0';
            args[len] = (char*)malloc(sizeof(buf));
            strcpy(args[len], buf);
            len++;
            arg = buf;
            continue;
        }
        *arg++ = c;
    }
    return ret_val;
}

void execute(int count, char* args[]) {
    if (fork()) {
        wait(0);
    } else {
        exec(args[0], args);
    }
}
