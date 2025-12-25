--*> maths.lua <*--
--*> adds some math functions, with them being optimised as per usual <*--
--*> made by eyoko1 <*--

local math_floor = math.floor
local math_random = math.random
local math_min = math.min
local math_max = math.max
local math_abs = math.abs
local math_sqrt = math.sqrt

function math.Round(number, idp)
    local mult = 10 ^ (idp or 0)
    return math_floor(number * mult + 0.5) / mult
end

function math.Clamp(number, low, high)
    return math_min(math_max(number, low), high)
end

function math.Rand(low, high)
    return low + (high - low) * math_random()
end

function math.IsNearlyEqual(a, b, tolerance)
    return math_abs(a - b) <= (tolerance or 1e-8)
end

function math.DistanceSqr(x1, y1, x2, y2)
    return ((x2 - x1) ^ 2) + ((y2 - y1) ^ 2)
end

function math.Distance(x1, y1, x2, y2)
    return math_sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2))
end
math.Dist = math.Distance
