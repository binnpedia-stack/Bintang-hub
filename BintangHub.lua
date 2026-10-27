-- BINTANGHUB V2 | Violence District
-- Premium UI | Silent Aim (Auto-Lock) | Custom Colors

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Config = {
    ESP_Survivor = false,
    ESP_Killer = false,
    ESP_Gen = false,
    ESP_Pumpkin = false,
    ESP_Trap = false,
    Fullbright = false,
    NoShadow = false,
    NoClip = false,
    AutoSkillcheck = false,
    SilentAim = false
}

-- ==========================================
-- PREMIUM UI CREATION
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BINTANGHUB_V2"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 360)
MainFrame.Position = UDim2.new(0, 20, 0, 20)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "BINTANGHUB | V2"
Title.TextColor3 = Color3.fromRGB(255, 60, 60)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -45)
ScrollFrame.Position = UDim2.new(0, 10, 0, 40)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 2
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollFrame

local function CreateToggle(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.Parent = ScrollFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
        btn.BackgroundColor3 = state and Color3.fromRGB(60, 20, 20) or Color3.fromRGB(25, 25, 28)
        callback(state)
    end)
end

CreateToggle("ESP Survivor (Green)", function(s) Config.ESP_Survivor = s end)
CreateToggle("ESP Killer (Red)", function(s) Config.ESP_Killer = s end)
CreateToggle("ESP Generator", function(s) Config.ESP_Gen = s end)
CreateToggle("ESP Pumpkin", function(s) Config.ESP_Pumpkin = s end)
CreateToggle("ESP Trap", function(s) Config.ESP_Trap = s end)
CreateToggle("Silent Aim (Auto Lock)", function(s) Config.SilentAim = s end)
CreateToggle("Fullbright", function(s) Config.Fullbright = s end)
CreateToggle("No Shadow", function(s) Config.NoShadow = s end)
CreateToggle("No Clip", function(s) Config.NoClip = s end)
CreateToggle("Auto Skillcheck", function(s) Config.AutoSkillcheck = s end)

-- ==========================================
-- ESP SYSTEM (Custom Colors)
-- ==========================================
local espObjects = {}

local function CreateESPObject()
    local box = Drawing.new("Square")
    box.Thickness = 1.5
    box.Filled = false
    box.Visible = false
    
    local text = Drawing.new("Text")
    text.Size = 13
    text.Center = true
    text.Outline = true
    text.Font = 2 -- Gotham
    text.Visible = false
    
    return {box = box, text = text}
end

local function CleanupESP()
    for _, obj in pairs(espObjects) do
        if obj.box then obj.box:Remove() end
        if obj.text then obj.text:Remove() end
    end
    espObjects = {}
end

local function UpdateESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChild("Humanoid")
                
                if hrp and hum and hum.Health > 0 then
                    if not espObjects[plr] then
                        espObjects[plr] = CreateESPObject()
                    end
                    local esp = espObjects[plr]
                    
                    local isKiller = char:FindFirstChildOfClass("Tool") ~= nil
                    
                    if (isKiller and Config.ESP_Killer) or (not isKiller and Config.ESP_Survivor) then
                        local vec, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                        if onScreen then
                            local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
                            local height = 1000 / dist
                            local width = height / 2
                            
                            esp.box.Size = Vector2.new(width, height)
                            esp.box.Position = Vector2.new(vec.X - width/2, vec.Y - height/2)
                            
                            -- Warna: Survivor Hijau, Killer Merah
                            esp.box.Color = isKiller and Color3.fromRGB(255, 40, 40) or Color3.fromRGB(40, 255, 40)
                            esp.box.Visible = true
                            
                            esp.text.Text = plr.Name .. " [" .. math.floor(dist) .. "m]"
                            esp.text.Position = Vector2.new(vec.X, vec.Y - height/2 - 16)
                            esp.text.Color = isKiller and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 255, 100)
                            esp.text.Visible = true
                        else
                            esp.box.Visible = false
                            esp.text.Visible = false
                        end
                    else
                        esp.box.Visible = false
                        esp.text.Visible = false
                    end
                end
            end
        end
    end

    for _, obj in pairs(workspace:GetDescendants()) do
        local isGen = Config.ESP_Gen and (obj.Name:lower():find("generator") or obj.Name:lower():find("gen"))
        local isPumpkin = Config.ESP_Pumpkin and (obj.Name:lower():find("pumpkin") or obj.Name:lower():find("labu") or obj.Name:lower():find("halloween"))
        local isTrap = Config.ESP_Trap and (obj.Name:lower():find("trap") or obj.Name:lower():find("beartrap"))
        
        if isGen or isPumpkin or isTrap then
            if not espObjects[obj] then espObjects[obj] = CreateESPObject() end
            local esp = espObjects[obj]
            
            if obj:IsA("BasePart") or obj:IsA("Model") then
                local pos = obj:IsA("Model") and (obj:FindFirstChild("HumanoidRootPart") and obj.HumanoidRootPart.Position or obj:GetPivot().Position) or obj.Position
                local vec, onScreen = Camera:WorldToViewportPoint(pos)
                
                if onScreen then
                    esp.text.Text = isGen and "[ GEN ]" or (isPumpkin and "[ LABU ]" or "[ TRAP ]")
                    esp.text.Position = Vector2.new(vec.X, vec.Y)
                    
                    if isGen then esp.text.Color = Color3.fromRGB(0, 255, 0)
                    elseif isPumpkin then esp.text.Color = Color3.fromRGB(255, 165, 0)
                    else esp.text.Color = Color3.fromRGB(255, 50, 50) end
                    
                    esp.text.Visible = true
                    esp.box.Visible = false
                else
                    esp.text.Visible = false
                end
            end
        else
            if espObjects[obj] then
                espObjects[obj].text.Visible = false
                espObjects[obj].box.Visible = false
            end
        end
    end
end

-- ==========================================
-- CHARACTER & LIGHTING LOGIC
-- ==========================================
local function CharacterLoop()
    local char = LocalPlayer.Character
    if char then
        if Config.NoClip then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end

    if Config.Fullbright then
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end

    if Config.NoShadow then
        Lighting.GlobalShadows = false
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then v.CastShadow = false end
        end
    end
end

-- ==========================================
-- SILENT AIM (AUTO-LOCK / CFrame)
-- ==========================================
local function GetClosestTarget()
    local closest, minDist = nil, math.huge
    local char = LocalPlayer.Character
    if not char then return nil end
    local myHrp = char:FindFirstChild("HumanoidRootPart")
    if not myHrp then return nil end

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChild("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local isKiller = plr.Character:FindFirstChildOfClass("Tool") ~= nil
                -- Target prioritas killer, kalo ga ada target survivor terdekat
                local dist = (myHrp.Position - hrp.Position).Magnitude
                
                -- FOV Check (Layar)
                local vec, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    if dist < minDist and dist < 150 then -- max range 150
                        minDist = dist
                        closest = hrp
                    end
                end
            end
        end
    end
    return closest
end

-- Hook Mouse (Silent Aim Logic)
local oldIndex, oldNewIndex
local mt = getrawmetatable(game)
local namecall = mt.__namecall
local oldNamecall = namecall

setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "FindPartOnRayWithIgnoreList" or method == "Raycast" or method == "FindPartOnRay" then
        if Config.SilentAim then
            local target = GetClosestTarget()
            if target then
                -- Ganti origin/direction agar mengenai Head target
                local args = {...}
                local ray = args[1]
                if typeof(ray) == "Ray" then
                    args[1] = Ray.new(ray.Origin, (target.Position - ray.Origin).Unit * (ray.Origin - target.Position).Magnitude)
                end
                return oldNamecall(self, unpack(args))
            end
        end
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- ==========================================
-- AUTO SKILLCHECK (Normal Timing)
-- ==========================================
local function InitAutoSkillcheck()
    local vim = game:GetService("VirtualInputManager")
    
    for _, remote in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            pcall(function()
                remote.OnClientEvent:Connect(function(...)
                    if not Config.AutoSkillcheck then return end
                    local args = {...}
                    for _, arg in pairs(args) do
                        if type(arg) == "string" and (arg:lower():find("skill") or arg:lower():find("hit")) then
                            task.wait(0.15) 
                            vim:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                            task.wait(0.08)
                            vim:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                        end
                    end
                end)
            end)
        end
    end
end

-- ==========================================
-- MAIN LOOPS
-- ==========================================
RunService.RenderStepped:Connect(UpdateESP)

task.spawn(function()
    while task.wait(0.1) do
        CharacterLoop()
    end
end)

InitAutoSkillcheck()
LocalPlayer.CharacterAdded:Connect(function()
    CleanupESP()
    task.wait(1)
    InitAutoSkillcheck()
end)

print("[BINTANGHUB V2] Loaded. Premium UI Active.")
