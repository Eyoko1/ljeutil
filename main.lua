--*> main.lua <*--
--*> lje util library containing many optimisations and helpful functions <*--
--*> made by eyoko1 <*--

--> TODO: Add custom config files to avoid having to create fingerprintable gmod config files

local environment = lje.env.get()
if (environment.__ljeutils) then
    return
end

environment.__ljeutils = true

return {
    init = function(path)
        if (string.sub(path, -1, -1) ~= "/") then
            path = path .. "/"
        end

        local m_hook = lje.include(path .. "ljeumodules/hook.lua")
        local m_util = lje.include(path .. "ljeumodules/util.lua")
        local m_render = lje.include(path .. "ljeumodules/render.lua")
        local m_draw = lje.include(path .. "ljeumodules/draw.lua")
        local m_string = lje.include(path .. "ljeumodules/string.lua")
        local m_string = lje.include(path .. "ljeumodules/math.lua")
    end
}