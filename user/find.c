#include "kernel/types.h"
#include "kernel/fs.h"
#include "user/user.h"
#include "kernel/stat.h"

int find_file(char *dir, char *fname);

int main(int argc, char *argv[]){
	int status=-1;
	if(argc!=3){
		printf("usage: <directory> <filename>\n");
		exit(status);
	}else{
		find_file(argv[1],argv[2]);
	}
	exit(status);
}

int find_file(char *dir, char *fname){
	char buf[512],*p;
	int fd;
	struct dirent de;
	struct stat fst;

	fd=open(dir,0);
	//error checking for reading 
	if(fd < 0){
		fprintf(2, "Error opening path\n");
		return 1;
	}
		
	strcpy(buf,dir);
	p = buf+strlen(buf);
    *p++ = '/';
	while(read(fd,&de,sizeof(de))==sizeof(de)){
			
		if(de.inum==0){
			continue;
		}
		if(!strcmp(de.name,".") || !strcmp(de.name,"..")){
			continue;
		}
		memmove(p,de.name,sizeof(de.name));
		
		//error checking on checking stats
		if(stat(buf,&fst)<0){
			fprintf(2, "Error retrieving file status");
			close(fd);
			return 1;
		}
		switch (fst.type)
		{
		case T_FILE:
			if(strcmp(de.name,fname)==0){
				printf("%s \n",buf);
			}
			break;
		
		case T_DIR:
			find_file(buf,fname);
			break;
		}
		
		
	}
	close(fd);

	return 0;
}
