#include "kernel/param.h"
#include "kernel/types.h"
#include "user/user.h"

void execute(char *s[]);
int main(int argc, char* argv[]){
    int status=1;
    while(status){
        char *s[MAXARG];
        int count=0;
        char c,buf[512],*p;
        p= buf;

        for(int i=1; i<argc ; i++){
            s[i-1]=argv[i];
            count++;
        }

        while((status =read(0,&c,sizeof(c)))){
            
            if(c=='\n'){
                *p++='\0';
                s[count] = (char *)malloc(sizeof(buf));
                memcpy(s[count],&buf,sizeof(buf));
                count++;
                execute(s);
                break;
            }
            if(c==' '){
                *p++='\0';
                s[count] = (char *)malloc(sizeof(buf));
                memcpy(s[count],&buf,sizeof(buf));
                count++;
                p=buf;
                continue;
            }
            *p++=c;
        }
    }
    
    
    exit(0);
}

void execute(char *s[]){
    if(fork()){
        wait(0);
    }else{
        exec(s[0],s);
    }
}