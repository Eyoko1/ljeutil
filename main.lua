--*> main.lua <*--
--*> lje util library containing many optimisations and helpful functions <*--
--*> made by eyoko1 <*--

--> TODO: Add custom config files to avoid having to create fingerprintable gmod config files

local environment = lje.env.get()
if (environment.__ljeutils) then
    return
end

environment.__ljeutils = true

local m_string = lje.include("ljeumodules/string.lua")
local m_math = lje.include("ljeumodules/math.lua")
local m_hook = lje.include("ljeumodules/hook.lua")
local m_util = lje.include("ljeumodules/util.lua")
local m_render = lje.include("ljeumodules/render.lua")
local m_draw = lje.include("ljeumodules/draw.lua")
