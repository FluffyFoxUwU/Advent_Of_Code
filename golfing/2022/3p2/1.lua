#!/usr/bin/env lua5.4

a="abcdefghijklmnopqrstuvwxyz"a=a..a:upper()b={}
for c in io.lines()do
  d={c,io.read(),io.read()}
  a:gsub(".",load"b[d[1]:match(d[2]:match(d[3]:match(...)))or 0]=(b[c] or 0 )+1")
end

e=0 for t,f in pairs(b)do e=e+a:find(t)*f end print(e)

