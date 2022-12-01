#!/usr/bin/env lua5.4
-- Fox: 130 bytes
f=tonumber a={}b=io.lines()for c in b do d=f(c)while c do d=d+f(c)c=b()end a[#a+1]=d end table.sort(a)print(a[#a]+a[#a-1]+a[#a-2])
