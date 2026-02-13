-- Ulstar Ultimate Battlegrounds Hub - FIX 2026 (Sintaxis corregida)
-- Error fix: Quité las barras `\` en `\~=`
-- Mobile: Doble tap para menú | Veracruz 🌴

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local config = {
    toggles = {
        KillAura = false,
        InfiniteUltimate = false,
        GodMode = false,
        HitboxExpander = false,
        AntiLag = true
    },
    values = {
        AuraRange = 500,
        HitboxSize = 60
    }
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UlstarHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.7, 0, 0.6, 0)
frame.Position = UDim2.new(0.15, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
frame.BackgroundTransparency = 0.45
frame.BorderSizePixel = 0
frame.Visible = false
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.12, 0)
title.BackgroundTransparency = 1
title.Text = "Ulstar UB Hub"
title.TextColor3 = Color3.fromRGB(0, 255, 180)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.Parent = frame

local function createToggle(name, yPos, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(
