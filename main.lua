-- [[ FISH IT AUTO-FISH - VIRTUALUSER MODE ]]
-- Author: CJ
-- No remote, no injection — cuma simulasi input

local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Config = {
    AutoCast = false,
    AutoReel = false,
    ClickDelay = 0.15,
    HoldDuration = 0.05,
    TapX = 0.5,     -- posisi tap (0-1, 0.5 = tengah)
    TapY = 0.5,
}

-- Fungsi tap
local function tap()
    local viewport = workspace.CurrentCamera.ViewportSize
    local pos = Vector2.new(viewport.X * Config.TapX, viewport.Y * Config.TapY)

    pcall(function()
        VirtualUser:Button1Down(pos)
        task.wait(Config.HoldDuration)
        VirtualUser:Button1Up(pos)
    end)
end

-- Auto cast loop
task.spawn(function()
    while task.wait() do
        if Config.AutoCast then
            tap()
            task.wait(Config.ClickDelay)
        end
    end
end)

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0))
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0))
end)

-- UI sederhana
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CJ_FishIt_VU"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 160)
Frame.Position = UDim2.new(0, 20, 0, 80)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 32)
Title.Text = "🎣 FISH IT | VIRTUALUSER"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Title.BorderSizePixel = 0
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.Parent = Frame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

local function makeToggle(text, key, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 32)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Config[key] and Color3.fromRGB(40, 90, 60) or Color3.fromRGB(30, 30, 40)
    btn.Text = "  " .. text .. " : " .. tostring(Config[key])
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 0
    btn.Parent = Frame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn

    btn.MouseButton1Click:Connect(function()
        Config[key] = not Config[key]
        btn.Text = "  " .. text .. " : " .. tostring(Config[key])
        btn.BackgroundColor3 = Config[key] and Color3.fromRGB(40, 90, 60) or Color3.fromRGB(30, 30, 40)
    end)
end

makeToggle("Auto Cast", "AutoCast", 45)
makeToggle("Anti AFK", "AntiAFK", 82)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Fish It! VU Mode",
    Text = "Loaded. Auto cast via VirtualUser.",
    Duration = 4,
})
