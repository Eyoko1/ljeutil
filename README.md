# ljeutil
A utility library for LJE re-adding many GLua functions, and optimising them, as well as adding additional functions which are useful.
List of functions which are added:
```lua
{ --> draw
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

{ --> string
    ToTable = function(str) end,
    Explode = function(separator, str, withpattern) end,
    Split = function(str, separator) end,
    StartsWith = function(str, start) end,
    EndsWith = function(str, endstr) end,
    Replace = function(str, tofind, toreplace) end
}

{ --> math
    Round = function(number, idp) end,
    Clamp = function(number, low, high) end,
    Rand = function(low, high) end,
    IsNearlyEqual = function(a, b, tolerance) end,
    DistanceSqr = function(x1, y1, x2, y2) end,
    Distance = function(x1, y1, x2, y2) end,
    Dist = function(x1, y1, x2, y2) end
}

{ --> hook
    list = {}, --> event table
    disabled = false,

    pre = function(event, identifier, callback) end, --> adds an event to be run before normal gmod callbacks are ran for an event
                                                     --> if an identifier is not passed, one will be generated and returned
    post = function(event, identifier, callback) end, --> adds an event to be run after normal gmod callbacks are ran for an event
                                                     --> if an identifier is not passed, one will be generated and returned
    
    before = function(event, identifier, callback) end, --> alias for hook.pre
    after = function(event, identifier, callback) end, --> alias for hook.post

    --> these removal functions can be quite expensive with large hook tables as they use table.remove on the sequential table section
    removepre = function(event, identifier) end, --> removes an event that is run before normal gmod callbacks are ran for an event
    removepost = function(event, identifier) end, --> removes an event that is run after normal gmod callbacks are ran for an event

    removebefore = function(event, identifier) end, --> alias for hook.removepre
    removeafter = function(event, identifier) end, --> alias for hook.removepost

    callpre = function(event, ...) end, --> executes lje callbacks for the given pre hook event
    callpost = function(event, ...) end, --> executes lje callbacks for the given post hook event

    disable = function() end, --> stops hooks from running - useful when re-rendering the scene, or using DrawModel
    enable = function() end --> re-enables hooks
}

{ --> cam
    cam.Start2D = function() end,
    cam.Start3D = function(pos, ang, fov, x, y, w, h, znear, zfar) end
}

{ --> _G
    Color = function(r, g, b, a) end
}

{ --> lje.util
    rendertarget = GetRenderTargetEx(...), --> a render target which is safe to render to - this cannot be screengrabbed
    rt = GetRenderTargetEx(...), --> alias for lje.util.rendertarget - these are exactly the same
    iterate_players = function(callback) end, --> iterates over all players and calls the given callback with each player, excluding the local player
    random_string = function(length) end, --> generates a random string with either the given length, or 32 characters if not specified
    color_strict = function(r, g, b, a) end --> very fast implementation of color - all arguments must be specified and must be numbers - values are still clamped
}
```

To use ljeutil, add it as a dependency in your info.toml script.
