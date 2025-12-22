--*> main.lua <*--
--*> lje util library containing many optimisations and helpful functions <*--
--*> made by eyoko1 <*--

--> TODO: Add custom config files to avoid having to create fingerprintable gmod config files

local environment = lje.env.get()
if (environment.__ljeutils) then
    return
end

environment.__ljeutils = true

lje.include("ljeumodules/string.lua")
lje.include("ljeumodules/math.lua")
lje.include("ljeumodules/hook.lua")
lje.include("ljeumodules/util.lua")
lje.include("ljeumodules/render.lua")
lje.include("ljeumodules/draw.lua")
lje.include("ljeumodules/file.lua")
lje.include("ljeumodules/media.lua")