// RubenVerg: 121 bytes
prompt(prompt().split`
`.reduce((s,w)=>s+{'A X':3,'A Y':4,'A Z':8,'B X':1,'B Y':5,'B Z':9,'C X':2,'C Y':6,'C Z':7}[w],0)) 