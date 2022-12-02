// RubenVerg: 102 bytes
prompt(prompt().split`
`.reduce((s,w)=>s+{AX:3,AY:4,AZ:8,BX:1,BY:5,BZ:9,CX:2,CY:6,CZ:7}[w[0]+w[2]],0))