--*> render.lua <*--
--*> adds some cam functions that aren't normally present in the lje environment, also creates a safe render target to draw onto <*--
--*> made by eyoko1 <*--

local screenshot = false
local safertname = string.Replace(lje.util.random_string(), ".", "_")
local safert = GetRenderTargetEx(safertname, ScrW(), ScrH(), RT_SIZE_DEFAULT, MATERIAL_RT_DEPTH_SHARED, bit.bor(16, 256, 32768), 0, IMAGE_FORMAT_BGRA8888)
local safertmaterial = CreateMaterial( 
    lje.util.random_string(),
    "UnlitGeneric",
    {
        ["$basetexture"] = safertname,
        ["$translucent"] = 1
    } 
)

lje.util.rendertarget = safert
lje.util.rt = safert

local cam2dtable = {type = "2D"}
local cam3dtable = {
    type = "3D",
    origin = Vector(0, 0, 0),
    angles = Angle(0, 0, 0),
    fov = 120,
    x = 0,
    y = 0,
    w = 0,
    h = 0,
    aspect = 0
}

local cam_Start = cam.Start
function cam.Start2D()
    cam_Start(cam2dtable)
end

function cam.Start3D(pos, ang, fov, x, y, w, h, znear, zfar)
	cam3dtable.origin = pos
	cam3dtable.angles = ang
    cam3dtable.fov = fov or nil

    if (x and y and w and h) then
		tab.x = x
		tab.y = y
		tab.w = w
		tab.h = h
		tab.aspect = w / h
    elseif (cam3dtable.x) then
        cam3dtable.x = nil
        cam3dtable.y = nil
        cam3dtable.w = nil
        cam3dtable.h = nil
        cam3dtable.aspect = nil
	end

	if (znear and zfar) then
		cam3dtable.znear = znear
		cam3dtable.zfar	= zfar
	end

	return cam_Start(cam3dtable)
end

hook.post("PostRender", "__safert", function()
	screenshot = render.IsTakingScreenshot()
    if screenshot then return end
    cam.Start2D()
        hook.callpre("ljeutil/render")

        local rt = render.GetRenderTarget()
        render.SetRenderTarget(nil)
            render.SetMaterial(safertmaterial)
            render.DrawScreenQuad(0, 0, ScrW(), ScrH())
        render.SetRenderTarget(rt)

        hook.callpost("ljeutil/render")

        render.PushRenderTarget(safert)
            render.Clear(0, 0, 0, 0, true, true)
        render.PopRenderTarget()
    cam.End2D()
end)

render.PushRenderTarget()
    render.Clear(0, 0, 0, 0, true, true)
render.PopRenderTarget()
