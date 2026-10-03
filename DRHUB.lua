-- ============================================================
-- DR HUB v1.0  |  Key: MAGABEST
-- ============================================================
local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")
local RunService   = game:GetService("RunService")
local Lighting     = game:GetService("Lighting")
local HttpService  = game:GetService("HttpService")

local LP = Players.LocalPlayer
local WHITE = Color3.new(1, 1, 1)
local ACCENT = Color3.fromRGB(150, 80, 255)
local BG = Color3.fromRGB(18, 16, 26)
local BG2 = Color3.fromRGB(26, 23, 38)
local BG3 = Color3.fromRGB(36, 32, 52)
local GRAY = Color3.fromRGB(160, 155, 180)
local RED = Color3.fromRGB(235, 80, 64)
local BODY_GRAY = Color3.fromRGB(150, 150, 156)
local KEY = "MAGABEST"

local ENV = (typeof(getgenv) == "function" and getgenv()) or _G
local conns = {}
local function track(c) conns[#conns+1] = c; return c end

pcall(function() RunService:UnbindFromRenderStep("NurHubAim") end)

local function new(class, props, parent)
    local o = Instance.new(class)
    if props then for k, v in pairs(props) do o[k] = v end end
    if parent then o.Parent = parent end
    return o
end
local function corner(o, r) return new("UICorner", {CornerRadius = UDim.new(0, r)}, o) end
local function stroke(o, color, th, tr)
    return new("UIStroke", {Color = color, Thickness = th or 1, Transparency = tr or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, o)
end
local function tw(o, t, props, style, dir)
    local a = TweenService:Create(o, TweenInfo.new(t,
        style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
    a:Play(); return a
end

local function mount(gui)
    local ok = pcall(function()
        gui.Parent = (typeof(gethui) == "function" and gethui()) or game:GetService("CoreGui")
    end)
    if not ok or not gui.Parent then gui.Parent = LP:WaitForChild("PlayerGui") end
end

local function cleanOld()
    local roots = {LP:FindFirstChildOfClass("PlayerGui")}
    pcall(function() table.insert(roots, game:GetService("CoreGui")) end)
    pcall(function() if typeof(gethui) == "function" then table.insert(roots, gethui()) end end)
    for _, r in ipairs(roots) do
        for _, n in ipairs({"NurHub_UI","NurHub_ESP","NurHub_HUD","DRHub_UI","DRHub_ESP"}) do
            local o = r and r:FindFirstChild(n)
            if o then pcall(function() o:Destroy() end) end
        end
    end
end
cleanOld()

-- ============================================================
-- KEY SYSTEM (DR HUB / MAGABEST)
-- ============================================================
local keyGui = new("ScreenGui", {Name = "DRHub_Key", ResetOnSpawn = false,
    IgnoreGuiInset = true, DisplayOrder = 5000})
mount(keyGui)

local kbg = new("Frame", {Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.fromRGB(8,6,14),
    BorderSizePixel = 0}, keyGui)

local kp = new("Frame", {AnchorPoint = Vector2.new(.5,.5), Position = UDim2.fromScale(.5,.5),
    Size = UDim2.fromOffset(360, 240), BackgroundColor3 = BG, BorderSizePixel = 0}, kbg)
corner(kp, 14)
stroke(kp, ACCENT, 1.5)

new("TextLabel", {Size = UDim2.new(1,0,0,50), BackgroundTransparency = 1,
    Font = Enum.Font.GothamBlack, TextSize = 30, TextColor3 = WHITE,
    RichText = true, Text = '<b>DR <font color="rgb(150,80,255)">HUB</font></b>'}, kp)
new("TextLabel", {Position = UDim2.fromOffset(0,46), Size = UDim2.new(1,0,0,20),
    BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 12,
    TextColor3 = GRAY, Text = "Enter key to continue"}, kp)

local kbox = new("TextBox", {Position = UDim2.fromOffset(20,90),
    Size = UDim2.new(1,-40,0,42), BackgroundColor3 = BG2, Text = "",
    PlaceholderText = "", Font = Enum.Font.GothamMedium, TextSize = 15,
    TextColor3 = WHITE, ClearTextOnFocus = false,
    TextXAlignment = Enum.TextXAlignment.Center}, kp)
corner(kbox, 8)

local kbtn = new("TextButton", {Position = UDim2.fromOffset(20,144),
    Size = UDim2.new(1,-40,0,42), BackgroundColor3 = ACCENT, Text = "ENTER",
    Font = Enum.Font.GothamBold, TextSize = 15, TextColor3 = WHITE}, kp)
corner(kbtn, 8)

local kerr = new("TextLabel", {Position = UDim2.fromOffset(0,200),
    Size = UDim2.new(1,0,0,20), BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold, TextSize = 12,
    TextColor3 = Color3.fromRGB(255,80,80)}, kp)

local unlocked = false
local function tryKey()
    if kbox.Text == KEY then
        unlocked = true
        kerr.TextColor3 = Color3.fromRGB(80,255,120)
        kerr.Text = "Access granted"
        task.wait(0.4)
        keyGui:Destroy()
    else
        kerr.Text = "Wrong key"
        kbox.Text = ""
    end
end
kbtn.MouseButton1Click:Connect(tryKey)
kbox.FocusLost:Connect(function(e) if e then tryKey() end end)
while not unlocked do task.wait(0.1) end

-- ============================================================
-- FLAGS
-- ============================================================
local S = {
    Chams=false, ChamsRainbow=false,
    ESP=false, Tracers=false,
    Aim=false, Snap=true, WallCheck=false,
    Spin=false, SpinSpeed=6,
    ThirdPerson=false,
    MenuRainbow=false,
    Wings=false, WingsRainbow=false,
    Hat=false, HatRainbow=false,
    Trail=false, TrailRainbow=false,
    Skeleton=false, Halo=false, Aura=false,
}
local chamsColor = Color3.fromRGB(255,60,120)
local chamsTransparency = 0.4
local espColor = Color3.fromRGB(255,255,255)
local tracerColor = Color3.fromRGB(255,200,60)
local aimFov = 200
local aimSmooth = 0.3
local aimPart = "Head"
local themeColor = ACCENT
local wingColor = Color3.fromRGB(255,255,255)
local hatColor = Color3.fromRGB(220,195,140)
local trailColor1 = Color3.fromRGB(140,90,255)
local trailColor2 = Color3.fromRGB(60,230,255)
local skelColor = Color3.fromRGB(255,255,255)
local haloColor = Color3.fromRGB(255,220,120)
local auraColor = Color3.fromRGB(150,80,255)

-- ============================================================
-- COSMETICS
-- ============================================================
local Cos = {}
local hiddenOrig = {}
local function isOwnCosmetic(p)
    return p:FindFirstAncestor("drWings") or p:FindFirstAncestor("drHat")
        or p:FindFirstAncestor("drSkeleton") or p:FindFirstAncestor("drHalo")
        or p:FindFirstAncestor("drAura")
end
local function setBodyHidden(h)
    if h then
        local char = LP.Character; if not char then return end
        for _, p in ipairs(char:GetDescendants()) do
            if (p:IsA("BasePart") or p:IsA("Decal")) and p.Name ~= "HumanoidRootPart" and not isOwnCosmetic(p) then
                if hiddenOrig[p] == nil then hiddenOrig[p] = p.Transparency end
                p.Transparency = 1
            end
        end
    else
        for p, tr in pairs(hiddenOrig) do
            if p.Parent then p.Transparency = tr end
        end
        hiddenOrig = {}
    end
end
local function destroyCos(n)
    if Cos[n] then
        for _, o in ipairs(Cos[n].objs) do pcall(function() o:Destroy() end) end
        Cos[n] = nil
        if n == "skeleton" then setBodyHidden(false) end
    end
end
local function newPart(size, parent)
    local p = Instance.new("Part")
    p.Size = size; p.CanCollide = false; p.CanQuery = false
    p.CanTouch = false; p.Massless = true; p.Anchored = false
    p.Parent = parent
    return p
end

local function buildWings()
    destroyCos("wings")
    local char = LP.Character
    local torso = char and (char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))
    if not torso then return end
    local model = Instance.new("Model"); model.Name = "drWings"
    local feathers = {}
    for _, side in ipairs({-1,1}) do
        for i = 1, 6 do
            local len = 4.2 - i*0.35
            local p = newPart(Vector3.new(len,0.5,0.08), model)
            p.Material = Enum.Material.Neon
            local w = Instance.new("Weld"); w.Part0 = torso; w.Part1 = p; w.Parent = p
            feathers[#feathers+1] = {part=p, weld=w, side=side, i=i, len=len}
        end
    end
    model.Parent = char
    Cos.wings = {objs = {model}, model = model, feathers = feathers}
end

local function buildHat()
    destroyCos("hat")
    local char = LP.Character
    local head = char and char:FindFirstChild("Head"); if not head then return end
    local model = Instance.new("Model"); model.Name = "drHat"
    local slices = {}
    local n = 10
    for i = 1, n do
        local r = 2.0 * (1 - (i-1)/n) + 0.1
        local p = newPart(Vector3.new(0.2, r*2, r*2), model)
        p.Shape = Enum.PartType.Cylinder
        p.Material = Enum.Material.SmoothPlastic
        local w = Instance.new("Weld"); w.Part0 = head; w.Part1 = p
        w.C0 = CFrame.new(0, 0.55 + (i-1)*0.19, 0) * CFrame.Angles(0,0,math.pi/2)
        w.Parent = p; slices[i] = p
    end
    model.Parent = char
    Cos.hat = {objs = {model}, model = model, slices = slices}
end

local function buildTrail()
    destroyCos("trail")
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local a0 = Instance.new("Attachment"); a0.Parent = hrp
    local a1 = Instance.new("Attachment"); a1.Parent = hrp
    local tr = Instance.new("Trail")
    tr.Attachment0 = a0; tr.Attachment1 = a1
    tr.LightEmission = 1; tr.FaceCamera = true
    tr.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.1), NumberSequenceKeypoint.new(1,1)})
    tr.Parent = hrp
    Cos.trail = {objs = {a0,a1,tr}, a0=a0, a1=a1, trail=tr}
end

local function buildSkeleton()
    destroyCos("skeleton")
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local model = Instance.new("Model"); model.Name = "drSkeleton"
    local bones = {}
    local defs = {
        {pos=Vector3.new(0,1.55,0), size=Vector3.new(0.55,0.55,0.55), ball=true},
        {pos=Vector3.new(0,1.15,0), size=Vector3.new(0.35,0.14,0.14), vert=true},
        {pos=Vector3.new(0,0.55,0), size=Vector3.new(1.4,0.14,0.14), vert=true},
        {pos=Vector3.new(0,1.0,0),  size=Vector3.new(1.3,0.12,0.12)},
        {pos=Vector3.new(0,0.05,0), size=Vector3.new(0.5,0.12,0.12)},
        {pos=Vector3.new(-0.65,0.55,0), size=Vector3.new(0.9,0.12,0.12), vert=true},
        {pos=Vector3.new(-0.65,-0.3,0), size=Vector3.new(0.8,0.12,0.12), vert=true},
        {pos=Vector3.new(0.65,0.55,0),  size=Vector3.new(0.9,0.12,0.12), vert=true},
        {pos=Vector3.new(0.65,-0.3,0),  size=Vector3.new(0.8,0.12,0.12), vert=true},
        {pos=Vector3.new(-0.2,-0.65,0), size=Vector3.new(1.0,0.16,0.16), vert=true},
        {pos=Vector3.new(-0.2,-1.55,0), size=Vector3.new(0.9,0.14,0.14), vert=true},
        {pos=Vector3.new(0.2,-0.65,0),  size=Vector3.new(1.0,0.16,0.16), vert=true},
        {pos=Vector3.new(0.2,-1.55,0),  size=Vector3.new(0.9,0.14,0.14), vert=true},
    }
    for i, d in ipairs(defs) do
        local p = newPart(d.size, model)
        p.Material = Enum.Material.SmoothPlastic
        local rot = CFrame.new()
        if d.ball then p.Shape = Enum.PartType.Ball
        else
            p.Shape = Enum.PartType.Cylinder
            if d.vert then rot = CFrame.Angles(0,0,math.pi/2) end
        end
        local w = Instance.new("Weld"); w.Part0 = hrp; w.Part1 = p
        w.C0 = CFrame.new(d.pos) * rot; w.Parent = p
        bones[i] = p
    end
    model.Parent = char
    Cos.skeleton = {objs = {model}, model = model, bones = bones}
    setBodyHidden(true)
end

local function buildHalo()
    destroyCos("halo")
    local char = LP.Character
    local head = char and char:FindFirstChild("Head"); if not head then return end
    local model = Instance.new("Model"); model.Name = "drHalo"
    local ring = newPart(Vector3.new(1.6,0.12,1.6), model)
    ring.Shape = Enum.PartType.Cylinder
    ring.Material = Enum.Material.Neon
    local w = Instance.new("Weld"); w.Part0 = head; w.Part1 = ring
    w.C0 = CFrame.new(0,1.3,0) * CFrame.Angles(0,0,math.pi/2); w.Parent = ring
    model.Parent = char
    Cos.halo = {objs = {model}, model = model, ring = ring, weld = w}
end

local function buildAura()
    destroyCos("aura")
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local model = Instance.new("Model"); model.Name = "drAura"
    local rings, welds = {}, {}
    for i = 1, 3 do
        local r = newPart(Vector3.new(0.08, 3.0+i*0.4, 3.0+i*0.4), model)
        r.Shape = Enum.PartType.Cylinder
        r.Material = Enum.Material.Neon
        r.Transparency = 0.3
        local w = Instance.new("Weld"); w.Part0 = hrp; w.Part1 = r
        w.C0 = CFrame.new(0,-2.9,0) * CFrame.Angles(0,0,math.pi/2); w.Parent = r
        rings[i] = r; welds[i] = w
    end
    model.Parent = char
    Cos.aura = {objs = {model}, model = model, rings = rings, welds = welds}
end

local SKINS = {
    ["Gold"]  = {Color3.fromRGB(255,200,40), Enum.Material.Metal},
    ["Neon"]  = {Color3.fromRGB(255,200,60), Enum.Material.Neon},
    ["Ice"]   = {Color3.fromRGB(150,220,255), Enum.Material.Ice},
    ["Ghost"] = {Color3.fromRGB(230,230,255), Enum.Material.ForceField},
    ["Lava"]  = {Color3.fromRGB(255,80,20), Enum.Material.CrackedLava},
    ["Black"] = {Color3.fromRGB(20,20,20), Enum.Material.Plastic},
}
local SKIN_NAMES = {"Off","Gold","Neon","Ice","Ghost","Lava","Black"}
local skinOrig = {}
local function resetSkin()
    for p, d in pairs(skinOrig) do
        if p.Parent then p.Color = d.c; p.Material = d.m end
    end
    skinOrig = {}
end
local function applySkin(name)
    resetSkin()
    local skin = SKINS[name]
    local char = LP.Character
    if not skin or not char then return end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" and not isOwnCosmetic(p) then
            skinOrig[p] = {c = p.Color, m = p.Material}
            p.Color = skin[1]; p.Material = skin[2]
        end
    end
end

local function getColor(name, t, off)
    if name == "Rainbow" then
        return Color3.fromHSV((((t or 0)*0.2) + (off or 0)) % 1, 0.85, 1)
    end
    return themeColor or ACCENT
end

-- ============================================================
-- COSMETIC TICK
-- ============================================================
track(RunService.Heartbeat:Connect(function()
    local t = os.clock()
    local w = Cos.wings
    if w and w.model.Parent then
        local flap = math.sin(t*3) * 0.2
        for _, f in ipairs(w.feathers) do
            local a = math.rad(10 + f.i*12) + flap*(0.5 + f.i*0.12)
            local theta = (f.side == 1) and a or (math.pi - a)
            f.weld.C0 = CFrame.new(f.side*0.5, 0.45, 0.6)
                * CFrame.Angles(0, f.side*-0.35, 0)
                * CFrame.Angles(0,0,theta)
                * CFrame.new(f.len/2, 0, 0)
            f.part.Color = (S.WingsRainbow and Color3.fromHSV((t*0.4 + f.i*0.05)%1,1,1)) or wingColor
        end
    end
    local h = Cos.hat
    if h and h.model.Parent then
        for i, s in ipairs(h.slices) do
            s.Color = (S.HatRainbow and Color3.fromHSV((t*0.4 + i*0.07)%1,1,1)) or hatColor
        end
    end
    local tr = Cos.trail
    if tr and tr.trail.Parent then
        tr.a0.Position = Vector3.new(0, 0.8, 0)
        tr.a1.Position = Vector3.new(0, -0.8, 0)
        tr.trail.Lifetime = 0.8
        if S.TrailRainbow then
            local c1 = Color3.fromHSV((t*0.4)%1, 1, 1)
            local c2 = Color3.fromHSV((t*0.4+0.3)%1, 1, 1)
            tr.trail.Color = ColorSequence.new(c1, c2)
        else
            tr.trail.Color = ColorSequence.new(trailColor1, trailColor2)
        end
    end
    local sk = Cos.skeleton
    if sk and sk.model.Parent then
        for _, b in ipairs(sk.bones) do b.Color = skelColor end
    end
    local hal = Cos.halo
    if hal and hal.model.Parent then
        hal.ring.Color = haloColor
        hal.weld.C0 = CFrame.new(0, 1.3 + math.sin(t*2)*0.05, 0) * CFrame.Angles(0, t*1.5, math.pi/2)
    end
    local au = Cos.aura
    if au and au.model.Parent then
        for i, w2 in ipairs(au.welds) do
            au.rings[i].Color = auraColor
            w2.C0 = CFrame.new(0,-2.9,0) * CFrame.Angles(0, t*(1 + i*0.3), math.pi/2)
        end
    end
    if S.Spin then
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(S.SpinSpeed), 0)
        end
    end
end))

local function applyCosmetics()
    if S.Wings then buildWings() else destroyCos("wings") end
    if S.Hat then buildHat() else destroyCos("hat") end
    if S.Trail then buildTrail() else destroyCos("trail") end
    if S.Skeleton then buildSkeleton() else destroyCos("skeleton") end
    if S.Halo then buildHalo() else destroyCos("halo") end
    if S.Aura then buildAura() else destroyCos("aura") end
end
track(LP.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart", 10); char:WaitForChild("Head", 10)
    task.wait(0.3); applyCosmetics()
end))
track(LP.CharacterRemoving:Connect(function()
    resetSkin(); setBodyHidden(false); Cos = {}
end))

-- ============================================================
-- ESP (без Drawing)
-- ============================================================
local espGui = new("ScreenGui", {Name = "DRHub_ESP", ResetOnSpawn = false,
    IgnoreGuiInset = true, DisplayOrder = 50, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
mount(espGui)

local store = {}
local function newLine()
    return new("Frame", {AnchorPoint = Vector2.new(.5,.5), BorderSizePixel = 0,
        BackgroundColor3 = WHITE, Visible = false, Size = UDim2.fromOffset(0,1)}, espGui)
end
local function drawLine(f, a, b, col, th)
    local d = b - a
    f.Size = UDim2.fromOffset(d.Magnitude, th)
    f.Position = UDim2.fromOffset((a.X + b.X)/2, (a.Y + b.Y)/2)
    f.Rotation = math.deg(math.atan2(d.Y, d.X))
    f.BackgroundColor3 = col; f.Visible = true
end

connect(RunService.RenderStepped, function()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local vs = cam.ViewportSize
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            local d = store[plr]
            if not d then d = {}; store[plr] = d end
            local char = plr.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 then
                -- Chams
                if S.Chams then
                    if not d.hl then
                        d.hl = new("Highlight", {DepthMode = Enum.HighlightDepthMode.AlwaysOnTop}, espGui)
                    end
                    d.hl.Adornee = char
                    d.hl.FillColor = chamsColor
                    d.hl.OutlineColor = chamsColor
                    d.hl.FillTransparency = chamsTransparency
                    d.hl.OutlineTransparency = 0
                    d.hl.Enabled = true
                elseif d.hl then d.hl.Enabled = false end

                -- ESP nick + dist
                if S.ESP then
                    if not d.name then
                        d.name = new("TextLabel", {BackgroundTransparency = 1,
                            Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = espColor,
                            TextStrokeTransparency = 0}, espGui)
                    end
                    if not d.dist then
                        d.dist = new("TextLabel", {BackgroundTransparency = 1,
                            Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = espColor,
                            TextStrokeTransparency = 0}, espGui)
                    end
                    local hp = char:FindFirstChild("Head") or hrp
                    local sp, on = cam:WorldToViewportPoint(hp.Position)
                    if on then
                        d.name.Text = plr.Name
                        d.name.Position = UDim2.fromOffset(sp.X - d.name.AbsoluteSize.X/2, sp.Y - 40)
                        d.name.Visible = true
                        local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                        local dist = myRoot and (myRoot.Position - hrp.Position).Magnitude or 0
                        d.dist.Text = string.format("[%d m]", math.floor(dist))
                        d.dist.Position = UDim2.fromOffset(sp.X - d.dist.AbsoluteSize.X/2, sp.Y - 22)
                        d.dist.Visible = true
                    else
                        if d.name then d.name.Visible = false end
                        if d.dist then d.dist.Visible = false end
                    end
                else
                    if d.name then d.name.Visible = false end
                    if d.dist then d.dist.Visible = false end
                end

                -- Tracers
                if S.Tracers then
                    if not d.tr then d.tr = newLine() end
                    local rp = cam:WorldToViewportPoint(hrp.Position)
                    if rp.Z > 0 then
                        drawLine(d.tr, Vector2.new(vs.X/2, vs.Y), Vector2.new(rp.X, rp.Y), tracerColor, 2)
                    else
                        d.tr.Visible = false
                    end
                elseif d.tr then d.tr.Visible = false end
            else
                if d.hl then d.hl.Enabled = false end
                if d.name then d.name.Visible = false end
                if d.dist then d.dist.Visible = false end
                if d.tr then d.tr.Visible = false end
            end
        end
    end
end)

track(Players.PlayerRemoving, function(p)
    local d = store[p]
    if d then
        for _, v in pairs(d) do pcall(function() v:Destroy() end) end
        store[p] = nil
    end
end)

-- ============================================================
-- AIMBOT
-- ============================================================
local aimCircle = new("Frame", {AnchorPoint = Vector2.new(.5,.5),
    BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false}, espGui)
new("UICorner", {CornerRadius = UDim.new(1,0)}, aimCircle)
local aimStroke = new("UIStroke", {Thickness = 1.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    Color = ACCENT}, aimCircle)

local AIM_PARTS = {
    ["Head"] = {"Head"},
    ["Torso"] = {"UpperTorso", "Torso"},
    ["Left arm"] = {"LeftUpperArm", "Left Arm"},
    ["Right arm"] = {"RightUpperArm", "Right Arm"},
    ["Left leg"] = {"LeftUpperLeg", "Left Leg"},
    ["Right leg"] = {"RightUpperLeg", "Right Leg"},
}
local function aimPartOf(char)
    for _, n in ipairs(AIM_PARTS[aimPart] or AIM_PARTS.Head) do
        local p = char:FindFirstChild(n); if p then return p end
    end
    return char:FindFirstChild("HumanoidRootPart")
end

local aiming, aimKeyDown = false, false
track(UIS.InputBegan:Connect(function(i, gp)
    if i.UserInputType == Enum.UserInputType.MouseButton2 then aiming = true end
    if not gp and i.UserInputType == Enum.UserInputType.Keyboard and i.KeyCode == Enum.KeyCode.E then
        aimKeyDown = true
    end
end))
track(UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton2 then aiming = false end
    if i.UserInputType == Enum.UserInputType.Keyboard and i.KeyCode == Enum.KeyCode.E then
        aimKeyDown = false
    end
end))

local function visibleFrom(cam, part, char)
    if not S.WallCheck then return true end
    local ignore = {char}
    if LP.Character then table.insert(ignore, LP.Character) end
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.FilterDescendantsInstances = ignore
    local o = cam.CFrame.Position
    return workspace:Raycast(o, part.Position - o, rp) == nil
end

RunService:BindToRenderStep("NurHubAim", Enum.RenderPriority.Camera.Value + 1, function(dt)
    pcall(function()
        local cam = workspace.CurrentCamera; if not cam then return end
        local vs = cam.ViewportSize
        local ap = (UIS.TouchEnabled and not UIS.MouseEnabled) and (vs/2) or UIS:GetMouseLocation()
        aimCircle.Visible = S.Aim
        if S.Aim then
            aimCircle.Size = UDim2.fromOffset(aimFov*2, aimFov*2)
            aimCircle.Position = UDim2.fromOffset(ap.X, ap.Y)
            aimStroke.Color = themeColor
        end
        if not S.Aim then return end
        if UIS.MouseEnabled then
            if not (aiming or aimKeyDown) then return end
        end
        local best, bd = nil, aimFov
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                local part = aimPartOf(plr.Character)
                if hum and hum.Health > 0 and part then
                    local sp, on = cam:WorldToViewportPoint(part.Position)
                    if on then
                        local dd = (Vector2.new(sp.X, sp.Y) - ap).Magnitude
                        if dd < bd and visibleFrom(cam, part, plr.Character) then
                            best, bd = part, dd
                        end
                    end
                end
            end
        end
        if best then
            local cur = cam.CFrame
            local a = 1 - (1 - aimSmooth) ^ (math.clamp(dt, 0, 0.1) * 60)
            if S.Snap then
                cam.CFrame = CFrame.new(cur.Position, best.Position)
            else
                cam.CFrame = cur:Lerp(CFrame.new(cur.Position, best.Position), a)
            end
        end
    end)
end)

-- ============================================================
-- UI
-- ============================================================
local gui = new("ScreenGui", {Name = "DRHub_UI", ResetOnSpawn = false,
    IgnoreGuiInset = true, DisplayOrder = 100, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
mount(gui)

local Root = new("Frame", {AnchorPoint = Vector2.new(.5,.5), Position = UDim2.fromScale(.5,.5),
    Size = UDim2.fromOffset(720, 440), BackgroundTransparency = 1}, gui)
local animScale = new("UIScale", {Scale = 1}, Root)
local Main = new("CanvasGroup", {Size = UDim2.fromScale(1,1),
    BackgroundColor3 = BG, BorderSizePixel = 0}, Root)
corner(Main, 12)
local mainStroke = stroke(Main, ACCENT, 1.5, 0)

-- Top bar
local top = new("Frame", {Size = UDim2.new(1,0,0,44), BackgroundColor3 = BG2,
    BorderSizePixel = 0}, Main)
corner(top, 12)
new("TextLabel", {Position = UDim2.fromOffset(16,0), Size = UDim2.new(0,200,1,0),
    BackgroundTransparency = 1, RichText = true, Font = Enum.Font.GothamBold, TextSize = 22,
    Text = '<b>DR <font color="rgb(150,80,255)">HUB</font></b>', TextColor3 = WHITE,
    TextXAlignment = Enum.TextXAlignment.Left}, top)
new("TextLabel", {AnchorPoint = Vector2.new(1,.5), Position = UDim2.new(1,-16,.5,0),
    Size = UDim2.fromOffset(120,20), BackgroundTransparency = 1,
    Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = GRAY,
    Text = "v1.0", TextXAlignment = Enum.TextXAlignment.Right}, top)

-- Tab bar
local tabBar = new("Frame", {Position = UDim2.fromOffset(0,44), Size = UDim2.new(0,130,1,-44),
    BackgroundColor3 = BG2, BorderSizePixel = 0}, Main)
local tabLayout = new("UIListLayout", {Padding = UDim.new(0,4),
    SortOrder = Enum.SortOrder.LayoutOrder}, tabBar)
new("UIPadding", {PaddingTop = UDim.new(0,8), PaddingLeft = UDim.new(0,8),
    PaddingRight = UDim.new(0,8)}, tabBar)

-- Content
local content = new("Frame", {Position = UDim2.fromOffset(130,44),
    Size = UDim2.new(1,-400,1,-44), BackgroundTransparency = 1}, Main)

-- Preview panel
local previewPanel = new("Frame", {Position = UDim2.new(1,-270,0,44),
    Size = UDim2.new(0,270,1,-44), BackgroundColor3 = Color3.fromRGB(15,12,24),
    BorderSizePixel = 0}, Main)

-- ====== Tabs ======
local pages, tabButtons = {}, {}
local function selectTab(name)
    for n, p in pairs(pages) do
        p.Visible = (n == name)
        tabButtons[n].BackgroundColor3 = (n == name) and themeColor or BG3
        tabButtons[n].TextColor3 = (n == name) and WHITE or GRAY
    end
end
local function createTab(name, order)
    local b = new("TextButton", {Size = UDim2.new(1,0,0,32), BackgroundColor3 = BG3,
        Text = name, Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = GRAY,
        AutoButtonColor = false, LayoutOrder = order}, tabBar)
    corner(b, 6)
    local page = new("ScrollingFrame", {Size = UDim2.new(1,-10,1,-10),
        Position = UDim2.fromOffset(5,5), BackgroundTransparency = 1,
        BorderSizePixel = 0, ScrollBarThickness = 4, ScrollBarImageColor3 = ACCENT,
        CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false}, content)
    local pl = new("UIListLayout", {Padding = UDim.new(0,6),
        SortOrder = Enum.SortOrder.LayoutOrder}, page)
    new("UIPadding", {PaddingRight = UDim.new(0,6), PaddingTop = UDim.new(0,2)}, page)
    pages[name], tabButtons[name] = page, b
    b.MouseButton1Click:Connect(function() selectTab(name) end)
    return page
end

-- Components
local function createToggle(page, text, key, cb)
    local row = new("TextButton", {Size = UDim2.new(1,-6,0,32), BackgroundColor3 = BG3,
        AutoButtonColor = false, Text = ""}, page)
    corner(row, 6)
    new("TextLabel", {Size = UDim2.new(1,-60,1,0), Position = UDim2.fromOffset(10,0),
        BackgroundTransparency = 1, Text = text, Font = Enum.Font.Gotham,
        TextSize = 12, TextColor3 = WHITE, TextXAlignment = Enum.TextXAlignment.Left}, row)
    local pill = new("Frame", {Size = UDim2.fromOffset(36,18),
        Position = UDim2.new(1,-46,.5,-9),
        BackgroundColor3 = S[key] and themeColor or Color3.fromRGB(70,70,88)}, row)
    corner(pill, 9)
    local knob = new("Frame", {Size = UDim2.fromOffset(14,14),
        Position = S[key] and UDim2.fromOffset(20,2) or UDim2.fromOffset(2,2),
        BackgroundColor3 = WHITE}, pill)
    corner(knob, 7)
    row.MouseButton1Click:Connect(function()
        S[key] = not S[key]
        local on = S[key]
        pill.BackgroundColor3 = on and themeColor or Color3.fromRGB(70,70,88)
        knob.Position = on and UDim2.fromOffset(20,2) or UDim2.fromOffset(2,2)
        if cb then cb(on) end
    end)
end

local function createSlider(page, text, mn, mx, init, fmt, cb)
    local row = new("Frame", {Size = UDim2.new(1,-6,0,46),
        BackgroundColor3 = BG3}, page)
    corner(row, 6)
    new("TextLabel", {Size = UDim2.new(1,-70,0,18), Position = UDim2.fromOffset(10,3),
        BackgroundTransparency = 1, Text = text, Font = Enum.Font.Gotham,
        TextSize = 12, TextColor3 = WHITE, TextXAlignment = Enum.TextXAlignment.Left}, row)
    local val = new("TextLabel", {Size = UDim2.fromOffset(60,18),
        Position = UDim2.new(1,-68,0,3), BackgroundTransparency = 1,
        Text = string.format(fmt, init), Font = Enum.Font.GothamBold,
        TextSize = 11, TextColor3 = ACCENT, TextXAlignment = Enum.TextXAlignment.Right}, row)
    local bar = new("Frame", {Size = UDim2.new(1,-20,0,6),
        Position = UDim2.new(0,10,0,32),
        BackgroundColor3 = Color3.fromRGB(60,60,76)}, row)
    corner(bar, 3)
    local fill = new("Frame", {Size = UDim2.new((init-mn)/(mx-mn),0,1,0),
        BackgroundColor3 = ACCENT}, bar)
    corner(fill, 3)
    local drag = false
    local function upd(x)
        local rel = math.clamp((x - bar.AbsolutePosition.X)/bar.AbsoluteSize.X, 0, 1)
        local v = mn + (mx-mn)*rel
        fill.Size = UDim2.new(rel,0,1,0)
        val.Text = string.format(fmt, v)
        cb(v)
    end
    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = true; upd(i.Position.X)
        end
    end)
    track(UIS.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            upd(i.Position.X)
        end
    end))
    track(UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = false
        end
    end))
end

local palette = {
    Color3.fromRGB(150,80,255), Color3.fromRGB(255,60,60),
    Color3.fromRGB(255,150,40), Color3.fromRGB(255,225,60),
    Color3.fromRGB(70,230,110), Color3.fromRGB(70,200,255),
    Color3.fromRGB(70,100,255), Color3.fromRGB(255,110,200),
    Color3.fromRGB(255,255,255), Color3.fromRGB(255,200,80),
}

local function createColorRow(page, text, getFn, onSel)
    local row = new("Frame", {Size = UDim2.new(1,-6,0,34),
        BackgroundColor3 = BG3}, page)
    corner(row, 6)
    new("TextLabel", {Size = UDim2.new(1,-70,1,0), Position = UDim2.fromOffset(10,0),
        BackgroundTransparency = 1, Text = text, Font = Enum.Font.Gotham,
        TextSize = 12, TextColor3 = WHITE, TextXAlignment = Enum.TextXAlignment.Left}, row)
    local sw = new("Frame", {Size = UDim2.fromOffset(40,22),
        Position = UDim2.new(1,-50,.5,-11),
        BackgroundColor3 = getFn()}, row)
    corner(sw, 5)
    stroke(sw, WHITE, 2)

    local grid = new("Frame", {Size = UDim2.new(1,-6,0,0), BackgroundColor3 = BG3,
        Visible = false, AutomaticSize = Enum.AutomaticSize.Y}, page)
    corner(grid, 6)
    new("UIGridLayout", {CellSize = UDim2.fromOffset(50,34),
        CellPadding = UDim2.fromOffset(4,4)}, grid)
    new("UIPadding", {PaddingLeft = UDim.new(0,6), PaddingTop = UDim.new(0,6),
        PaddingBottom = UDim.new(0,6)}, grid)
    local strokes = {}
    for _, c in ipairs(palette) do
        local holder = new("Frame", {BackgroundColor3 = c}, grid)
        corner(holder, 5)
        local hs = stroke(holder, WHITE, 0, 1)
        local cl = new("TextButton", {Size = UDim2.fromScale(1,1),
            BackgroundTransparency = 1, Text = ""}, holder)
        strokes[#strokes+1] = {color = c, stroke = hs}
        cl.MouseButton1Click:Connect(function()
            onSel(c)
            for _, s in ipairs(strokes) do
                if s.color.R == c.R and s.color.G == c.G and s.color.B == c.B then
                    s.stroke.Thickness = 3; s.stroke.Transparency = 0
                else
                    s.stroke.Thickness = 0; s.stroke.Transparency = 1
                end
            end
            sw.BackgroundColor3 = c
        end)
    end
    sw.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            grid.Visible = not grid.Visible
        end
    end)
end

-- ============================================================
-- PREVIEW (2D манекен с кликом по частям)
-- ============================================================
previewPanel.BackgroundColor3 = Color3.fromRGB(15,12,24)
corner(previewPanel, 0)
stroke(previewPanel, ACCENT, 1)

new("TextLabel", {Size = UDim2.new(1,0,0,20), Position = UDim2.fromOffset(0,6),
    BackgroundTransparency = 1, Text = "PREVIEW", Font = Enum.Font.GothamBold,
    TextSize = 11, TextColor3 = ACCENT}, previewPanel)

local bodyFrame = new("Frame", {AnchorPoint = Vector2.new(.5,.5),
    Position = UDim2.new(.5,0,.5,10), Size = UDim2.fromOffset(150, 280),
    BackgroundTransparency = 1}, previewPanel)

local parts = {}
local function makePart(name, x, y, w, h, r)
    local p = new("TextButton", {Name = name, Position = UDim2.fromOffset(x,y),
        Size = UDim2.fromOffset(w,h), BackgroundColor3 = BODY_GRAY,
        BorderSizePixel = 0, Text = "", AutoButtonColor = false}, bodyFrame)
    corner(p, r or 6)
    parts[name] = p
    return p
end

makePart("Head", 53, 10, 44, 44, 22)
makePart("UpperTorso", 47, 60, 56, 60, 8)
makePart("LowerTorso", 49, 122, 52, 40, 8)
makePart("LeftArm", 23, 62, 20, 88, 10)
makePart("RightArm", 107, 62, 20, 88, 10)
makePart("LeftLeg", 51, 166, 22, 88, 10)
makePart("RightLeg", 77, 166, 22, 88, 10)

-- Wing preview
local wingPrev = new("Frame", {AnchorPoint = Vector2.new(.5,.5),
    Position = UDim2.fromOffset(75, 100), Size = UDim2.fromOffset(140, 40),
    BackgroundTransparency = 1, Visible = false}, bodyFrame)
new("TextLabel", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
    RichText = true, Font = Enum.Font.GothamBold, TextSize = 40, TextColor3 = WHITE,
    Text = "🕊" }, wingPrev)

local hatPrev = new("Frame", {Position = UDim2.fromOffset(45, 0),
    Size = UDim2.fromOffset(60, 8), BackgroundColor3 = hatColor,
    Visible = false}, bodyFrame)
corner(hatPrev, 4)

local skeletonOverlay = new("Frame", {Size = UDim2.fromScale(1,1),
    BackgroundTransparency = 1, Visible = false}, bodyFrame)
for _, p in pairs(parts) do
    local ghost = new("Frame", {Size = UDim2.fromScale(1,1),
        BackgroundTransparency = 1, Position = UDim2.fromOffset(0,0)}, p)
    stroke(ghost, WHITE, 2)
end

local redDot = new("Frame", {Size = UDim2.fromOffset(16,16),
    BackgroundColor3 = RED, BorderSizePixel = 0, AnchorPoint = Vector2.new(.5,.5),
    ZIndex = 10}, bodyFrame)
corner(redDot, 8)
stroke(redDot, WHITE, 2)

local aimTargetLbl

local function getPartCenter(name)
    local p = parts[name]
    if not p then return UDim2.new(.5,0,.5,0) end
    return UDim2.new(0, p.Position.X.Offset + p.Size.X.Offset/2,
                     0, p.Position.Y.Offset + p.Size.Y.Offset/2)
end

local function choosePart(name)
    aimPart = name
    for n, p in pairs(parts) do
        if n == name then p.BackgroundColor3 = RED
        else p.BackgroundColor3 = BODY_GRAY end
    end
    tw(redDot, 0.4, {Position = getPartCenter(name)},
        Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    if aimTargetLbl then aimTargetLbl.Text = "Target: " .. name end
end

for name, p in pairs(parts) do
    p.MouseButton1Click:Connect(function() choosePart(name) end)
end

redDot.Position = getPartCenter("Head")
choosePart("Head")

-- ============================================================
-- TABS CONTENT
-- ============================================================
local combatTab = createTab("Combat", 1)
new("TextLabel", {Size = UDim2.new(1,-6,0,18), BackgroundTransparency = 1,
    Text = "AIMBOT", Font = Enum.Font.GothamBold, TextSize = 11,
    TextColor3 = ACCENT, TextXAlignment = Enum.TextXAlignment.Left}, combatTab)
createToggle(combatTab, "Aim Assist (RMB or E)", "Aim")
createToggle(combatTab, "Snap Aim", "Snap")
createToggle(combatTab, "Wall Check", "WallCheck")
createSlider(combatTab, "FOV", 50, 500, aimFov, "%.0f", function(v) aimFov = v end)
createSlider(combatTab, "Smoothness", 0.05, 1, aimSmooth, "%.2f", function(v) aimSmooth = v end)

aimTargetLbl = new("TextLabel", {Size = UDim2.new(1,-6,0,22), BackgroundColor3 = BG3,
    Text = "   Target: Head (click preview)", Font = Enum.Font.Gotham, TextSize = 11,
    TextColor3 = GRAY, TextXAlignment = Enum.TextXAlignment.Left}, combatTab)
corner(aimTargetLbl, 6)

new("TextLabel", {Size = UDim2.new(1,-6,0,18), BackgroundTransparency = 1,
    Text = "VISUALS", Font = Enum.Font.GothamBold, TextSize = 11,
    TextColor3 = ACCENT, TextXAlignment = Enum.TextXAlignment.Left}, combatTab)
createToggle(combatTab, "ESP (nick + dist)", "ESP")
createToggle(combatTab, "Tracers", "Tracers")
createToggle(combatTab, "Chams", "Chams")
createToggle(combatTab, "Rainbow Chams", "ChamsRainbow")
createSlider(combatTab, "Chams Transparency", 0, 0.9, chamsTransparency, "%.2f",
    function(v) chamsTransparency = v end)
createColorRow(combatTab, "Chams Color", function() return chamsColor end,
    function(c) chamsColor = c end)
createColorRow(combatTab, "ESP Color", function() return espColor end,
    function(c) espColor = c end)
createColorRow(combatTab, "Tracer Color", function() return tracerColor end,
    function(c) tracerColor = c end)

-- Visuals
local visTab = createTab("Visuals", 2)
new("TextLabel", {Size = UDim2.new(1,-6,0,18), BackgroundTransparency = 1,
    Text = "COSMETICS", Font = Enum.Font.GothamBold, TextSize = 11,
    TextColor3 = ACCENT, TextXAlignment = Enum.TextXAlignment.Left}, visTab)
createToggle(visTab, "Angel Wings", "Wings", function(on)
    if on then buildWings() else destroyCos("wings") end
    wingPrev.Visible = on
end)
createToggle(visTab, "Rainbow Wings", "WingsRainbow")
createColorRow(visTab, "Wing Color", function() return wingColor end,
    function(c) wingColor = c end)

createToggle(visTab, "Chinese Hat", "Hat", function(on)
    if on then buildHat() else destroyCos("hat") end
    hatPrev.Visible = on
end)
createToggle(visTab, "Rainbow Hat", "HatRainbow")
createColorRow(visTab, "Hat Color", function() return hatColor end,
    function(c) hatColor = c end)

createToggle(visTab, "Trail", "Trail", function(on)
    if on then buildTrail() else destroyCos("trail") end
end)
createToggle(visTab, "Rainbow Trail", "TrailRainbow")
createColorRow(visTab, "Trail Color 1", function() return trailColor1 end,
    function(c) trailColor1 = c end)
createColorRow(visTab, "Trail Color 2", function() return trailColor2 end,
    function(c) trailColor2 = c end)

createToggle(visTab, "Skeleton", "Skeleton", function(on)
    if on then buildSkeleton() else destroyCos("skeleton") end
    skeletonOverlay.Visible = on
end)
createColorRow(visTab, "Skeleton Color", function() return skelColor end,
    function(c) skelColor = c end)

createToggle(visTab, "Halo", "Halo", function(on)
    if on then buildHalo() else destroyCos("halo") end
end)
createColorRow(visTab, "Halo Color", function() return haloColor end,
    function(c) haloColor = c end)

createToggle(visTab, "Aura", "Aura", function(on)
    if on then buildAura() else destroyCos("aura") end
end)
createColorRow(visTab, "Aura Color", function() return auraColor end,
    function(c) auraColor = c end)

-- Skins
local skTab = createTab("Skins", 3)
new("TextLabel", {Size = UDim2.new(1,-6,0,18), BackgroundTransparency = 1,
    Text = "SKINS", Font = Enum.Font.GothamBold, TextSize = 11,
    TextColor3 = ACCENT, TextXAlignment = Enum.TextXAlignment.Left}, skTab)
for _, name in ipairs(SKIN_NAMES) do
    local b = new("TextButton", {Size = UDim2.new(1,-6,0,32),
        BackgroundColor3 = BG3, Text = name, Font = Enum.Font.GothamMedium,
        TextSize = 12, TextColor3 = WHITE, AutoButtonColor = false}, skTab)
    corner(b, 6)
    b.MouseButton1Click:Connect(function()
        if name == "Off" then resetSkin() else applySkin(name) end
    end)
end

-- Character
local charTab = createTab("Character", 4)
new("TextLabel", {Size = UDim2.new(1,-6,0,18), BackgroundTransparency = 1,
    Text = "CHARACTER", Font = Enum.Font.GothamBold, TextSize = 11,
    TextColor3 = ACCENT, TextXAlignment = Enum.TextXAlignment.Left}, charTab)
local origZoom = {LP.CameraMinZoomDistance, LP.CameraMaxZoomDistance}
createToggle(charTab, "Third Person", "ThirdPerson", function(on)
    if not LP.Character then return end
    if on then
        LP.CameraMode = Enum.CameraMode.Classic
        LP.CameraMinZoomDistance = 8
        LP.CameraMaxZoomDistance = 20
    else
        LP.CameraMinZoomDistance = origZoom[1]
        LP.CameraMaxZoomDistance = origZoom[2]
        LP.CameraMode = Enum.CameraMode.LockFirstPerson
    end
end)
createToggle(charTab, "Spin", "Spin")
createSlider(charTab, "Spin Speed", 1, 100, 6, "%.0f", function(v) S.SpinSpeed = v end)
createSlider(charTab, "Camera FOV", 50, 110, 70, "%.0f", function(v)
    workspace.CurrentCamera.FieldOfView = v
end)

-- Menu
local menuTab = createTab("Menu", 5)
new("TextLabel", {Size = UDim2.new(1,-6,0,18), BackgroundTransparency = 1,
    Text = "MENU SETTINGS", Font = Enum.Font.GothamBold, TextSize = 11,
    TextColor3 = ACCENT, TextXAlignment = Enum.TextXAlignment.Left}, menuTab)
createToggle(menuTab, "Rainbow Menu", "MenuRainbow")
createColorRow(menuTab, "Menu Color", function() return themeColor end, function(c)
    themeColor = c
    mainStroke.Color = c
    S.MenuRainbow = false
end)
local menuScaleMult = 1
createSlider(menuTab, "Menu Scale", 0.6, 1.4, 1, "%.2f", function(v)
    menuScaleMult = v
    local vp = workspace.CurrentCamera.ViewportSize
    local base = math.clamp(math.min(vp.X/(720+20), vp.Y/(440+20)), 0.4, 1)
    animScale.Scale = base * v
end)

local closeBtn = new("TextButton", {Size = UDim2.new(1,-6,0,34),
    BackgroundColor3 = ACCENT, Text = "Close Menu", Font = Enum.Font.GothamBold,
    TextSize = 13, TextColor3 = WHITE}, menuTab)
corner(closeBtn, 6)
closeBtn.MouseButton1Click:Connect(function() Root.Visible = false end)

-- Menu scale
local function fitScale()
    local vp = workspace.CurrentCamera.ViewportSize
    local base = math.clamp(math.min(vp.X/(720+20), vp.Y/(440+20)), 0.4, 1)
    animScale.Scale = base * menuScaleMult
end
fitScale()
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fitScale)

-- Rainbow
local hue = 0
track(RunService.RenderStepped:Connect(function(dt)
    workspace.CurrentCamera = workspace.CurrentCamera
    if S.MenuRainbow then
        hue = (hue + dt*0.3) % 1
        themeColor = Color3.fromHSV(hue, 0.8, 1)
        mainStroke.Color = themeColor
    end
    if S.ChamsRainbow then
        chamsColor = Color3.fromHSV((tick()*0.4)%1, 1, 1)
    end
end))

-- Logo / Open button
local logoBtn = new("TextButton", {Size = UDim2.fromOffset(50,50),
    Position = UDim2.new(0,12,.5,-25), BackgroundColor3 = BG,
    Text = "", AutoButtonColor = false, ZIndex = 5}, gui)
corner(logoBtn, 25)
local lbs = stroke(logoBtn, ACCENT, 2)
new("TextLabel", {Size = UDim2.fromScale(1,1), BackgroundTransparency = 1,
    RichText = true, Text = '<b>D<font color="rgb(150,80,255)">H</font></b>',
    Font = Enum.Font.GothamBlack, TextSize = 20, TextColor3 = WHITE}, logoBtn)

logoBtn.MouseButton1Click:Connect(function()
    Root.Visible = not Root.Visible
end)

-- Drag by top
local dragging, dragStart, startPos = false, nil, nil
top.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = i.Position; startPos = Root.Position
    end
end)
track(UIS.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - dragStart
        Root.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end))
track(UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end))

-- RightShift toggle
track(UIS.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then
        Root.Visible = not Root.Visible
    end
end))

selectTab("Combat")
applyCosmetics()
print("[DR HUB] v1.0 loaded — Key: MAGABEST")
