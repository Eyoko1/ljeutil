--*> draw.lua <*--
--*> re-implements the entire draw library, with all functions being optimised <*--
--*> made by eyoko1 <*--

--> i recommend that you do not use the draw library, and instead batch draw text using surface, although most functions here are a good amount faster than the default ones
--> co-ordinates are not rounded in these drawing functions so if you need that, do that before passing them

local surface_SetFont = surface.SetFont
local surface_GetTextSize = surface.GetTextSize
local surface_SetTextPos = surface.SetTextPos
local surface_SetTextColor = surface.SetTextColor
local surface_DrawText = surface.DrawText
local surface_SetTexture = surface.SetTexture
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_DrawTexturedRectUV = surface.DrawTexturedRectUV
local string_find = string.find
local string_sub = string.sub
local math_ceil = math.ceil
local math_floor = math.floor
local math_max = math.max
local math_min = math.min
local tostring = tostring

local color_strict = lje.util.color_strict

local TEXT_ALIGN_LEFT = 0
local TEXT_ALIGN_CENTER = 1
local TEXT_ALIGN_RIGHT = 2
local TEXT_ALIGN_TOP = 3
local TEXT_ALIGN_BOTTOM = 4

local tabwidth = 50

local white = lje.util.color_strict(255, 255, 255, 255)
local black = lje.util.color_strict(0, 0, 0, 255)

local environment = lje.env.get()
local draw = {
    SimpleText = function(text, font, x, y, color, xalign, yalign) end,
    SimpleTextOutlined = function(text, font, x, y, color, xalign, yalign, outlinewidth, outlinecolor) end,
    DrawText = function(text, font, x, y, color, xalign) end,
    GetFontHeight = function(font) end,
    NoTexture = function() end,
    RoundedBoxEx = function(radius, x, y, width, height, color, topleft, topright, bottomleft, bottomright) end,
    RoundedBox = function(radius, x, y, width, height, color) end,
    Text = function(textdata) end, --> do not use this unless it is absolutely necessary
    TextShadow = function(textdata, distance, alpha) end, --> do not use this unless it is absolutely necessary

    TexturedQuad = function(texturedata) end,
    WordBox = function(bordersize, x, y, text, font, boxcolor, textcolor, xalign, yalign) end
}
environment.draw = draw

function draw.SimpleText(text, font, x, y, colour, xalign, yalign)
    text = tostring(text)
    font = font or "DermaDefault"
    x = x or 0
    y = y or 0

    surface_SetFont(font)

    local width, height = surface_GetTextSize(text)
    if (xalign == TEXT_ALIGN_CENTER) then
        x = x - (width * 0.5)
    elseif (xalign == TEXT_ALIGN_RIGHT) then
        x = x - width
    end
    if (yalign == TEXT_ALIGN_CENTER) then
        y = y - (height * 0.5)
    elseif (yalign == TEXT_ALIGN_BOTTOM) then
        y = y - height
    end

    surface_SetTextPos(x, y)

    if (colour) then
        surface_SetTextColor(colour.r, colour.g, colour.b, colour.a)
    else
        surface_SetTextColor(255, 255, 255, 255)
    end

    surface_DrawText(text)

    return width, height
end

function draw.SimpleTextOutlined(text, font, x, y, colour, xalign, yalign, outlinewidth, outlinecolour)
    text = tostring(text)
    font = font or "DermaDefault"
    x = math_ceil(x or 0)
    y = math_ceil(y or 0)
    colour = colour or white
    xalign = xalign or TEXT_ALIGN_LEFT
    yalign = yalign or TEXT_ALIGN_TOP

    local steps = (outlinewidth * 2) / 3
    if (steps < 1) then
        steps = 1
    end

    surface_SetFont(font)

    local width, height = surface_GetTextSize(text)
    if (xalign == TEXT_ALIGN_CENTER) then
        x = x - (width * 0.5)
    elseif (xalign == TEXT_ALIGN_RIGHT) then
        x = x - width
    end
    if (yalign == TEXT_ALIGN_CENTER) then
        y = y - (height * 0.5)
    elseif (yalign == TEXT_ALIGN_BOTTOM) then
        y = y - height
    end

    surface_SetTextColor(outlinecolour)

    local _x = -outlinewidth
    local _y = -outlinewidth
    ::outlinex::
    ::outliney::
    surface_SetTextPos(x + _x, y + _y)
    surface_DrawText(text)
    if (_y < outlinewidth) then
        _y = _y + steps
        goto outliney
    end
    if (_x < outlinewidth) then
        _x = _x + steps
        _y = -outlinewidth
        goto outlinex
    end

    surface_SetTextPos(x, y)
    surface_SetTextColor(colour)
	surface_DrawText(text)

    return width, height
end

local cachednlheights = {}
local function __getcachednlheight(font)
    local _, height = surface_GetTextSize("\n")
    height = height * 0.5
    cachednlheights[font] = height
    return height
end

local function __drawtext(text, x, y, xalign)
    local size = surface_GetTextSize(text)
    if (xalign == TEXT_ALIGN_CENTER) then
        x = x - (size * 0.5)
    elseif (xalign == TEXT_ALIGN_RIGHT) then
        x = x - size
    end

    surface_SetTextPos(x, y)
    surface_DrawText(text)

    return size
end

function draw.DrawText(text, font, x, y, colour, xalign)
    font = font or "DermaDefault"
    text = tostring(text)
    x = x or 0
    y = y or 0
    colour = colour or white
    xalign = xalign or TEXT_ALIGN_LEFT

    surface_SetFont(font)
    local lineheight = cachednlheights[font] or __getcachednlheight(font)

    local currentx = x
    local currenty = y

    surface_SetTextColor(colour)
    
    local length = #text
    local i = 1
    while (true) do
        local nextnewline = string_find(text, "\n", i)
        local substring = string_sub(text, i, nextnewline or length)

        local sslength = #substring
        local j = 1
        while (true) do
            local nexttab = string_find(substring, "\t", j)
            if (nexttab) then
                if (nexttab ~= j) then
                    local substring2 = string_sub(substring, j, nexttab)
                    local size = __drawtext(substring2, currentx, currenty, xalign)
                    currentx = currentx + size
                end

                j = nexttab + 1
                currentx = currentx + tabwidth
            else
                __drawtext(string_sub(substring, j, sslength), currentx, currenty, xalign)
                break
            end
        end

        if (nextnewline) then
            i = nextnewline + 1
            currentx = x
            currenty = currenty + lineheight
        else
            break
        end
    end
end

local cachedheights = {}
function __getcachedheight(font)
    surface_SetFont(font)
    local _, height = surface_GetTextSize("W")
    cachedheights[font] = height

    return height
end

function draw.GetFontHeight(font)
    return cachedheights[font] or __getcachedheight()
end

local blanktexture	= surface.GetTextureID("vgui/white")
function draw.NoTexture()
    surface_SetTexture(blanktexture)
end

local corner8 = surface.GetTextureID("gui/corner8")
local corner16 = surface.GetTextureID("gui/corner16")
local corner32 = surface.GetTextureID("gui/corner32")
local corner64 = surface.GetTextureID("gui/corner64")
local corner512 = surface.GetTextureID("gui/corner512")
function draw.RoundedBoxEx(bordersize, x, y, width, height, topleft, topright, bottomleft, bottomright)
    surface_SetDrawColor(color.r, color.g, color.b, color.a)

    if (bordersize <= 0) then
        surface_DrawRect(x, y, width, height)
        return
    end

    bordersize = math_min(math_floor(bordersize), math_floor(width / 2), math_floor(height / 2))
    surface.DrawRect(x + bordersize, y, width - bordersize * 2, height)
    surface.DrawRect(x, y + bordersize, bordersize, height - bordersize * 2)
    surface.DrawRect(x + w - bordersize, y + bordersize, bordersize, h - bordersize * 2)

    local texture = corner8
    if (bordersize > 64) then
        texture = corner512
    elseif (bordersize > 32) then
        texture = corner64
    elseif (border > 16) then
        texture = corner32
    elseif (border > 8) then
        texture = corner16
    end

    surface_SetTexture(texture)

    if (topleft) then
        surface_DrawTexturedRectUV(x, y, bordersize, bordersize, 0, 0, 1, 1)
    else
        surface_DrawRect(x, y, bordersize, bordersize)
    end

    if (topright) then
        surface_DrawTexturedRectUV(x + width - bordersize, y, bordersize, bordersize, 1, 0, 0, 1)
    else
        surface_DrawRect(x + width - bordersize, y, bordersize, bordersize)
    end

    if (bottomleft) then
        surface_DrawTexturedRectUV(x, y + height - bordersize, bordersize, bordersize, 0, 1, 1, 0)
    else
        surface_DrawRect(x, y + height - bordersize, bordersize, bordersize)
    end

    if (bottomright) then
        surface_DrawTexturedRectUV(x + width - bordersize, y + height - bordersize, bordersize, bordersize, 1, 1, 0, 0)
    else
        surface_DrawRect(x + width - bordersize, y + height - bordersize, bordersize, bordersize)
    end
end

function draw.RoundedBox(bordersize, x, y, width, height, color)
    surface_SetDrawColor(color.r, color.g, color.b, color.a)

    if (bordersize <= 0) then
        surface_DrawRect(x, y, width, height)
        return
    end

    bordersize = math_min(math_floor(bordersize), math_floor(width / 2), math_floor(height / 2))
    surface.DrawRect(x + bordersize, y, width - bordersize * 2, height)
    surface.DrawRect(x, y + bordersize, bordersize, height - bordersize * 2)
    surface.DrawRect(x + w - bordersize, y + bordersize, bordersize, h - bordersize * 2)

    local texture = corner8
    if (bordersize > 64) then
        texture = corner512
    elseif (bordersize > 32) then
        texture = corner64
    elseif (border > 16) then
        texture = corner32
    elseif (border > 8) then
        texture = corner16
    end

    surface_SetTexture(texture)

    surface_DrawTexturedRectUV(x, y, bordersize, bordersize, 0, 0, 1, 1)
    surface_DrawTexturedRectUV(x + width - bordersize, y, bordersize, bordersize, 1, 0, 0, 1)
    surface_DrawTexturedRectUV(x, y + height - bordersize, bordersize, bordersize, 0, 1, 1, 0)
    surface_DrawTexturedRectUV(x + width - bordersize, y + height - bordersize, bordersize, bordersize, 1, 1, 0, 0)
end

local SimpleText = draw.SimpleText
function draw.Text(textdata)
    local pos = textdata.pos
    return SimpleText(textdata.text, textdata.font, pos[1], pos[2], textdata.color, textdata.xalign, textdata.yalign)
end

local Text = draw.Text
function draw.TextShadow(textdata, distance, alpha) --> i haven't really optimised this function since you shouldn't be using it
    local color = textdata.color
    local pos = textdata.pos
    textdata.color = color_strict(0, 0, 0, alpha or 200)
    textdata.pos = {pos[1] + distance, pos[2] + distance}

    Text(textdata)

    textdata.color = color
    textdata.pos = pos

    return Text(textdata)
end

function draw.TexturedQuad(texturedata)
    local color = texturedata.color or white
    surface_SetTexture(texturedata.texture)
    surface_SetDrawColor(color.r, color.g, color.b, color.a)
    surface_DrawTexturedRect(texturedata.x, texturedata.y, texturedata.w, texturedata.h)
end

local RoundedBox = draw.RoundedBox
function draw.WordBox(bordersize, x, y, text, font, color, fontcolor, xalign, yalign)
    surface_SetFont(font)
    local width, height = surface_GetTextSize(text)

    if (xalign == TEXT_ALIGN_CENTER) then
		x = x - (bordersize + width / 2)
	elseif (xalign == TEXT_ALIGN_RIGHT) then
		x = x - (bordersize * 2 + width)
	end

	if (yalign == TEXT_ALIGN_CENTER) then
		y = y - (bordersize + height / 2)
	elseif (yalign == TEXT_ALIGN_BOTTOM) then
		y = y - (bordersize * 2 + height)
	end

    RoundedBox(bordersize, x, y, width + bordersize * 2, height + bordersize * 2, color)

    surface_SetTextColor(fontcolor.r, fontcolor.g, fontcolor.b, fontcolor.a)
    surface_SetTextPos(x + bordersize, y + bordersize)
    surface_DrawText(text)

    return width + bordersize * 2, height + bordersize * 2
end

local globalstart = 0
local globalend = 0

local faststart = 0
local fastend = 0

hook.pre("PostRender", "Test", function()
    cam.Start2D()
    render.PushRenderTarget(lje.util.rt)
    if (FrameNumber() % 200 == 0) then
        if (FrameNumber() % 400 == 0) then
            faststart = SysTime()
            for i = 1, 100000 do
                --draw.SimpleTextOutlined("SimpleTextOutlined", "CreditsText", ScrW() / 2, ScrH() / 2, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, black)
                draw.SimpleText("SimpleText", "CreditsText", ScrW() / 2, ScrH() / 2, white)
                --draw.DrawText("The quick brown fox\tjumped over\t\tthe lazy dog\nnewline\n\nnewnewline", "CreditsText", ScrW() / 2, ScrH() / 2 + 150, white, TEXT_ALIGN_LEFT)
            end
            fastend = SysTime()

            print(string.format("_G function: %s", globalend - globalstart))
            print(string.format("Fast function: %s, being %sx faster\n", fastend - faststart, (globalend - globalstart) / (fastend - faststart)))
        else
            globalstart = SysTime()
            for i = 1, 100000 do
                --_G.draw.SimpleTextOutlined("SimpleTextOutlined", "CreditsText", ScrW() / 2, ScrH() / 2, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, black)
                _G.draw.SimpleText("SimpleText", "CreditsText", ScrW() / 2, ScrH() / 2, white)
                --_G.draw.DrawText("The quick brown fox\tjumped over\t\tthe lazy dog\nnewline\n\nnewnewline", "CreditsText", ScrW() / 2, ScrH() / 2, white, TEXT_ALIGN_LEFT)
            end
            globalend = SysTime()
        end
    end
    render.PopRenderTarget()
    cam.End2D()
end)