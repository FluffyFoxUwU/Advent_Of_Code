--Fox: 85 bytes
a=0 for b in io.lines()do a=a+("ffB XC XA XA YB YC YC ZA ZB Z"):find(b)end;print(a/3)
a=0 for b in io.lines()do a=a+b.find("ffB XC XA XA YB YC YC ZA ZB Z",b)end;print(a/3)

--[[
0b000 = ' '
0b001 = 'B'
0b010 = 'X'
0b011 = 'C'
0b100 = 'A'
0b101 = 'Y'
0b110 = 'Z'
0b111 = 'f'
0b111111001001000010011000010100000010100000101001000101011000101011000110100000110001000110
]]
