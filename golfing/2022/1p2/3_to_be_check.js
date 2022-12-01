// RubenVerg: 107 bytes
// Run in about:blank in browser's console
eval(eval('['+prompt().replaceAll(`

`,',').replaceAll(`
`,'+')+']').sort((a,b)=>b-a).slice(0,3).join('+'))
