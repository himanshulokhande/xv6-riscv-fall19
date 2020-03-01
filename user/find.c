#include "kernel/types.h"
#include "kernel/fs.h"
#include "kernel/stat.h"
#include "user/user.h"

#define BUF_SIZE 512

int find_in_dir(char* dir, char* search);

int main(int argc, char* argv[]) {
    if (argc != 3) {
        fprintf(2, "usage is find <directory> <search>\n");
        exit(1);
    }

    int status = find_in_dir(argv[1], argv[2]);
    exit(status);
}

int find_in_dir(char* dir, char* search) {
    int fd;
    struct stat status;
    struct dirent entry;

    if ((fd = open(dir, 0)) < 0) {
        fprintf(2, "Cannot open the Directory %s\n", dir);
        return 1;
    }

    if (fstat(fd, &status) < 0) {
        fprintf(2, "Cannot get the status of %s", dir);
        close(fd);
        return 1;
    }

    if (status.type != T_DIR) {
        fprintf(2, "Invalid directory");
        close(fd);
        return 1;
    }

    // reading the entries in the directory
    char path[BUF_SIZE], *p;
    strcpy(path, dir);
    p = path + strlen(path);
    *p++ = '/';
    while (read(fd, &entry, sizeof(entry)) == sizeof(entry)) {
        if (entry.inum == 0) continue;
        if (strcmp(entry.name, ".") == 0 || strcmp(entry.name, "..") == 0)
            continue;
        memmove(p, entry.name, DIRSIZ);
        if (stat(path, &status) < 0) {
            fprintf(2, "cannot get the status of %s\n", entry.name);
            continue;
        }
        switch (status.type) {
            case T_FILE: {
                if (strcmp(entry.name, search) == 0) {
                    printf("%s\n", path);
                }
                break;
            }
            case T_DIR: {
                find_in_dir(path, search);
                break;
            }
        }
    }
    close(fd);
    return 0;
}