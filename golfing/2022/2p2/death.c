main(){char a[3],*b="ffBXCXAXAYBYCYCZAZBZ";int c=0;while(gets(a)){a[1]=a[2];c+=(strstr(b,a)-b)/2;}printf("%d\n",c);}