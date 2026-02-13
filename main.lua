-- Ulstar Ultimate Battlegrounds Hub vFinal - Mobile Ready 2026
-- Para Veracruz con amor 🌴 - Doble tap para menú
-- Sube a GitHub y usa: loadstring(game:HttpGet("TU_RAW_LINK"))()

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player    = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root      = character:WaitForChild("HumanoidRootPart")
local humanoid  = character:WaitForChild("Humanoid")

-- Configuración (ajusta lo que quieras)
local config = {
    toggles = {
        KillAura          = false,  -- Mata en rango
        InfiniteUltimate  = false,  -- Ultimate infinito
        GodMode           = false,  -- Inmortal + no stun
        HitboxExpander    = false,  -- Hitbox gigante
        AntiLag           = true    -- Reduce lag
    },
    values = {
        AuraRange    = 500,
        HitboxSize   = 80
    }
}

-- GUI simple y grande para móvil
local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.Name = "UlstarUB"
sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0.75, 0, 0.65, 0)
frame.Position = UDim2.new(0.125, 0, 0.175, 0)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
frame.BackgroundTransparency = 0.4
frame.Visible = false
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0.1, 0)
title.BackgroundTransparency = 1
title.Text = "Ulstar UB Hub"
title.TextColor3 = Color3.fromRGB(0, 255, 150)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true

-- Toggle creator
local function toggleBtn(name, y, callback)
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.55, 0, 0.09, 0)
    lbl.Position = UDim2.new(0.05, 0, y, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.TextScaled = true

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.35, 0, 0.09, 0)
    btn.Position = UDim2.new(0.6, 0, y, 0)
    btn.Text = "OFF"
    btn.BackgroundColor3 = Color3.fromRGB(180,0,0)
    btn.TextColor3 = Color3.new(1)
    btn.TextScaled = true

    local state = false
    local function tog()
        state = not state
        btn.Text = state and "ON" or "OFF"
        btn.BackgroundColor3 = state and Color3.fromRGB(0,180,0) or Color3.fromRGB(180,0,0)
        callback(state)
    end
    btn.TouchTap:Connect(tog)
    btn.MouseButton1Click:Connect(tog)
end

-- Toggles
toggleBtn("Kill Aura", 0.15, function(v) config.toggles.KillAura = v end)
toggleBtn("Ultimate Infinito", 0.28, function(v) config.toggles.InfiniteUltimate = v end)
toggleBtn("Modo Dios", 0.41, function(v) config.toggles.GodMode = v end)
toggleBtn("Hitbox Expander", 0.54, function(v) config.toggles.HitboxExpander = v end)
toggleBtn("Anti Lag", 0.67, function(v) config.toggles.AntiLag = v end)

-- Toggle menú con doble tap
UserInputService.TouchTap:Connect(function(_, proc) if not proc then frame.Visible = not frame.Visible end end)
UserInputService.InputBegan:Connect(function(i) if i.KeyCode == Enum.KeyCode.RightShift then frame.Visible = not frame.Visible end end)

-- Loop principal
local last = 0
RunService.Heartbeat:Connect(function()
    if tick() - last < 0.2 then return end
    last = tick()

    if config.toggles.InfiniteUltimate then
        pcall(function()
            local rem = ReplicatedStorage:FindFirstChild("AwakeningRemote") or ReplicatedStorage.Remotes:FindFirstChild("Ultimate")
            if rem then rem:FireServer() end
        end)
    end

    if config.toggles.GodMode then
        humanoid.Health = humanoid.MaxHealth
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    end

    if config.toggles.KillAura then
        for _, pl in Players:GetPlayers() do
            if pl \~= player and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                local d = (root.Position - pl.Character.HumanoidRootPart.Position).Magnitude
                if d <= config.values.AuraRange then
                    pl.Character.Humanoid.Health = 0
                end
            end
        end
    end

    if config.toggles.HitboxExpander then
        for _, pl in Players:GetPlayers() do
            if pl \~= player and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                pl.Character.HumanoidRootPart.Size = Vector3.new(config.values.HitboxSize, config.values.HitboxSize, config.values.HitboxSize)
            end
        end
    end

    if config.toggles.AntiLag then
        for _, o in workspace:GetDescendants() do
            if o:IsA("ParticleEmitter") or o:IsA("Trail") then o.Enabled = false end
        end
    end
end)

player.CharacterAdded:Connect(function(nc)
    character = nc
    root = nc:WaitForChild("HumanoidRootPart")
    humanoid = nc:WaitForChild("Humanoid")
end)

print("Ulstar UB Hub cargado - Doble tap para menú. ¡A ganar en UB! 🌴")
