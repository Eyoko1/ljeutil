# ljeutil
A utility library for LJE re-adding many GLua functions, and optimising them, as well as adding additional functions which are useful.
    
To use ljeutil, do the following:
```lua
local ljeutilpath = "path/to/ljeutil/"
local m_ljeutil = lje.include(ljeutilpath .. "main.lua").init(ljeutilpath) 
```