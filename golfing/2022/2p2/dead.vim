
i1 <Esc>h"cdw
:%s/ /<CR>
qa
h2x
:%s/<C-R>"/<C-R>c<CR>
i<C-R>=<C-R>+1<CR> <Esc>
h"cdw
q
iBX<Esc>@a
iCX<Esc>@a
iAX<Esc>@a
iAY<Esc>@a
iBY<Esc>@a
iCY<Esc>@a
iCZ<Esc>@a
iAZ<Esc>@a
iBZ<Esc>@a
:%s/\n/+<CR>
Di<C-R>=<C-R>"<CR>

i1 _h"cdw:%s/ /_qah2x:%s/_"/_c_i_=_+1_ _h"cdwqiBX_@aiCX_@aiAX_@aiAY_@aiBY_@aiCY_@aiCZ_@aiAZ_@aiBZ_@a:%s/\n/+_Di<C-R>=<C-R>"_

local state = {
  ["BX"] = 1,
  ["CX"] = 2,
  ["AX"] = 3,
  ["AY"] = 4,
  ["BY"] = 5,
  ["CY"] = 6,
  ["CZ"] = 7,
  ["AZ"] = 8,
  ["BZ"] = 9
}
