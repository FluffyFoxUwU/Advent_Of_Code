# Vim macro solution
# Fox: 61 keystrokes

qa:%s/\n/+<CR>$r q:%s/++/\r/g<CR>qbDi<C-R>=<C-R>"<CR><Esc>-@bq@b:sor n<CR>G3kdgg@a0@b

paste -sd+ | sed s/++/\\n/g | bc | sort -n | tail -3 | paste -sd+ | bc
qa:%s/\n/+_$r q:%s/++/\r/g_qbDi_=_"__-@bq@b:sor n_G3kdgg@a0@b

