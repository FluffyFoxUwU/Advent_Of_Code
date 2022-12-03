#if 0
clang -g -fsanitize=address -std=c89 $0
./a.out
exit $?
#endif

main(c){char a[5];while(read(0,a,4))a[2]-=88,*a-=65,c+=1+3*((a[2]-*a+4)%3);printf("%d\n",c-1);}
