-- Fox: 109 bytes
a={load("return "..io.read("a"):gsub("\n\n", ","):gsub("\n","+"))()}table.sort(a)print(a[#a]+a[#a-1]+a[#a-2])
