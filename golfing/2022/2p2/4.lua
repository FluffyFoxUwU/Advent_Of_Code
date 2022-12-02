#!/usr/bin/env lua5.4
-- Fox: 96 bytes
a=0 for b in io.lines()do a=a+("fBXCXAXAYBYCYCZAZBZ"):find(b:sub(1,1)..b:sub(-1))/2 end;print(a)

-- Lookup
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
