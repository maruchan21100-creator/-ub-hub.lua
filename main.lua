-- Ulstar UB Hub - Versión FINAL corregida y optimizada 2026
-- Mobile: Doble tap para abrir menú | Ultimate Battlegrounds
-- Veracruz 🌴 - Ejecuta con loadstring(game:HttpGet("RAW_LINK"))()

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player    = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root      = character:WaitForChild("HumanoidRootPart")
local humanoid  = character:WaitForChild("Humanoid")

-- Configuración
local config = {
    toggles = {
        KillAura         = false,
        InfiniteUltimate = false,
        GodMode          = false,
        HitboxExpander   = false,
        AntiLag          = true
    },
    values = {
        AuraRange   = 500,
        HitboxSize  = 80
    }
}

-- GUI mobile-friendly
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UlstarUB"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size               = UDim2.new(0.7, 0, 0.6, 0)
frame.Position           = UDim2.new(0.15, 0, 0.2, 0)
frame.BackgroundColor3   = Color3.fromRGB(15, 15, 20)
frame.BackgroundTransparency = 0.45
frame.BorderSizePixel    = 0
frame.Visible            = false
frame.Active             = true
frame.Draggable          = true
frame.Parent             = screenGui

local title = Instance.new("TextLabel")
title.Size               = UDim2.new(1, 0, 0.12, 0)
title.BackgroundTransparency = 1
title.Text               = "Ulstar UB Hub"
title.TextColor3         = Color3.fromRGB(0, 255, 180)
title.Font               = Enum.Font.SourceSansBold
title.TextScaled         = true
title.Parent             = frame

-- Toggle creator
local function createToggle(nombre, yPos, callback)
    local label = Instance.new("TextLabel")
    label.Size               = UDim2.new(0.6, 0, 0.1, 0)
    label.Position           = UDim2.new(0.05, 0, yPos, 0)
    label.BackgroundTransparency = 1
    label.Text               = nombre
    label.TextColor3         = Color3.new(1,1,1)
    label.TextScaled         = true
    label.Parent             = frame

    local boton = Instance.new("TextButton")
    boton.Size              = UDim2.new(0.3, 0, 0.1, 0)
    boton.Position          = UDim2.new(0.65, 0, yPos, 0)
    boton.Text              = "OFF"
    boton.BackgroundColor3  = Color3.fromRGB(180, 0, 0)
    boton.TextColor3        = Color3.new(1)
    boton.TextScaled        = true
    boton.Parent            = frame

    local estado = false
    local function alternar()
        estado = not estado
        boton.Text = estado and "ON" or "OFF"
        boton.BackgroundColor3 = estado and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
        callback(estado)
    end

    boton.TouchTap:Connect(alternar)
    boton.MouseButton1Click:Connect(alternar)
end

-- Toggles
createToggle("Kill Aura",            0.18, function(v) config.toggles.KillAura         = v end)
createToggle("Ultimate Infinito",    0.32, function(v) config.toggles.InfiniteUltimate = v end)
createToggle("Modo Dios",            0.46, function(v) config.toggles.GodMode          = v end)
createToggle("Hitbox Expander",      0.60, function(v) config.toggles.HitboxExpander   = v end)
createToggle("Anti Lag",             0.74, function(v) config.toggles.AntiLag          = v end)

-- Toggle menú
local function alternarGUI()
    frame.Visible = not frame.Visible
    local trans = frame.Visible and 0.45 or 1
    TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = trans}):Play()
end

UserInputService.TouchTap:Connect(function(_, proc) if not proc then alternarGUI() end end)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then alternarGUI() end
end)

-- Lógica principal
local ultimo = 0
RunService.Heartbeat:Connect(function()
    if tick() - ultimo < 0.2 then return end
    ultimo = tick()

    if config.toggles.InfiniteUltimate then
        pcall(function()
            local rem = ReplicatedStorage:FindFirstChild("AwakeningRemote") or ReplicatedStorage.Remotes:FindFirstChild("Ultimate")
            if rem then rem:FireServer() end
        end)
    end

    if config.toggles.GodMode then
        humanoid.Health = humanoid.MaxHealth
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    end

    if config.toggles.KillAura then
        for _, otro in ipairs(Players:GetPlayers()) do
            if otro \~= player and otro.Character and otro.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (root.Position - otro.Character.HumanoidRootPart.Position).Magnitude
                if dist <= config.values.AuraRange then
                    otro.Character.Humanoid.Health = 0
                end
            end
        end
    end

    if config.toggles.HitboxExpander then
        for _, otro in ipairs(Players:GetPlayers()) do
            if otro \~= player and otro.Character and otro.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = otro.Character.HumanoidRootPart
                hrp.Size = Vector3.new(config.values.HitboxSize, config.values.HitboxSize, config.values.HitboxSize)
                hrp.Transparency = 0.7
                hrp.CanCollide = false
            end
        end
    end

    if config.toggles.AntiLag then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                obj.Enabled = false
            end
        end
    end
end)

player.CharacterAdded:Connect(function(nc)
    character = nc
    root = nc:WaitForChild("HumanoidRootPart")
    humanoid = nc:WaitForChild("Humanoid")
end)

print("Ulstar UB Hub cargado - Doble tap para abrir menú. ¡A romper en UB! 🌴")
