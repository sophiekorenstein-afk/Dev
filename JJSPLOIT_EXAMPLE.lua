--[[
    JJSPLOIT SPECIFIC EXAMPLE
    
    This example is optimized for jjsploit and demonstrates
    common use cases for the UILibrary in jjsploit scripts.
]]

-- Load the library
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/lua-ui-library/main/UILibrary.lua"))()

-- Create UI
local UI = UILibrary.new("jjsploit Script", "v1.0")

-- ============================================
-- PLAYER TAB
-- ============================================

local PlayerTab = UI:CreateTab("Player", "👤")

-- Speed Control
UI:AddSlider(PlayerTab.Name, 0, 100, 16, function(value)
    local player = game:GetService("Players").LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = value
    end
end)

-- Jump Power
UI:AddSlider(PlayerTab.Name, 0, 100, 50, function(value)
    local player = game:GetService("Players").LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = value
    end
end)

-- God Mode
local godModeEnabled = false
UI:AddToggle(PlayerTab.Name, "God Mode", false, function(enabled)
    godModeEnabled = enabled
    local player = game:GetService("Players").LocalPlayer
    
    if enabled then
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.MaxHealth = math.huge
            player.Character.Humanoid.Health = math.huge
        end
    else
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.MaxHealth = 100
            player.Character.Humanoid.Health = 100
        end
    end
end)

-- Infinite Stamina
UI:AddToggle(PlayerTab.Name, "Infinite Stamina", false, function(enabled)
    local player = game:GetService("Players").LocalPlayer
    if enabled then
        while enabled do
            if player.Character and player.Character:FindFirstChild("Stamina") then
                player.Character.Stamina.Value = 100
            end
            wait(0.1)
        end
    end
end)

-- Teleport to Player
UI:AddInput(PlayerTab.Name, "Player name...", function(text, enterPressed)
    if enterPressed and text ~= "" then
        local targetPlayer = game:GetService("Players"):FindFirstChild(text)
        if targetPlayer and targetPlayer.Character then
            local player = game:GetService("Players").LocalPlayer
            if player.Character then
                player.Character:MoveTo(targetPlayer.Character.HumanoidRootPart.Position)
            end
        else
            print("Player not found: " .. text)
        end
    end
end)

-- ============================================
-- WORLD TAB
-- ============================================

local WorldTab = UI:CreateTab("World", "🌍")

-- Time of Day
UI:AddDropdown(WorldTab.Name, {"Morning", "Noon", "Evening", "Night"}, 2, function(selected, index)
    local times = {Morning = 6, Noon = 12, Evening = 18, Night = 0}
    game:GetService("Lighting").ClockTime = times[selected]
end)

-- Brightness
UI:AddSlider(WorldTab.Name, 0, 2, 1, function(value)
    game:GetService("Lighting").Brightness = value
end)

-- Ambient Light
UI:AddSlider(WorldTab.Name, 0, 1, 0.5, function(value)
    game:GetService("Lighting").Ambient = Color3.fromRGB(value * 255, value * 255, value * 255)
end)

-- Remove Fog
UI:AddToggle(WorldTab.Name, "Remove Fog", false, function(enabled)
    if enabled then
        game:GetService("Lighting").FogEnd = math.huge
    else
        game:GetService("Lighting").FogEnd = 100000
    end
end)

-- Spawn Items
UI:AddButton(WorldTab.Name, "Spawn Part", function()
    local part = Instance.new("Part")
    part.Shape = Enum.PartType.Ball
    part.Size = Vector3.new(2, 2, 2)
    part.BrickColor = BrickColor.new("Bright purple")
    part.CanCollide = true
    part.CFrame = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
    part.Parent = workspace
end)

-- ============================================
-- CAMERA TAB
-- ============================================

local CameraTab = UI:CreateTab("Camera", "📷")

-- FOV Control
UI:AddSlider(CameraTab.Name, 1, 120, 70, function(value)
    game:GetService("Players").LocalPlayer.PlayerGui.CurrentCamera.FieldOfView = value
end)

-- Third Person Distance
UI:AddSlider(CameraTab.Name, 0, 50, 15, function(value)
    local camera = workspace.CurrentCamera
    local player = game:GetService("Players").LocalPlayer
    if player.Character then
        camera.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, value)
    end
end)

-- Free Camera
local freeCameraEnabled = false
UI:AddToggle(CameraTab.Name, "Free Camera", false, function(enabled)
    freeCameraEnabled = enabled
    local camera = workspace.CurrentCamera
    
    if enabled then
        camera.CameraType = Enum.CameraType.Scriptable
    else
        camera.CameraType = Enum.CameraType.Custom
    end
end)

-- ============================================
-- SETTINGS TAB
-- ============================================

local SettingsTab = UI:CreateTab("Settings", "⚙️")

-- Script Name
UI:AddInput(SettingsTab.Name, "Script name...", function(text, enterPressed)
    if enterPressed then
        print("Script name: " .. text)
    end
end)

-- Auto-Execute
UI:AddToggle(SettingsTab.Name, "Auto-Execute on Join", false, function(enabled)
    print("Auto-Execute: " .. (enabled and "ON" or "OFF"))
end)

-- Notifications
UI:AddToggle(SettingsTab.Name, "Show Notifications", true, function(enabled)
    print("Notifications: " .. (enabled and "ON" or "OFF"))
end)

-- Theme
UI:AddDropdown(SettingsTab.Name, {"Purple", "Blue", "Green", "Red"}, 1, function(selected)
    print("Theme: " .. selected)
end)

-- Reset Settings
UI:AddButton(SettingsTab.Name, "Reset to Default", function()
    print("Settings reset!")
end)

-- ============================================
-- UTILITIES TAB
-- ============================================

local UtilitiesTab = UI:CreateTab("Utilities", "🔧")

-- Get Player Info
UI:AddButton(UtilitiesTab.Name, "Print Player Info", function()
    local player = game:GetService("Players").LocalPlayer
    print("=== PLAYER INFO ===")
    print("Name: " .. player.Name)
    print("UserId: " .. player.UserId)
    if player.Character then
        print("Position: " .. tostring(player.Character.HumanoidRootPart.Position))
        print("Health: " .. player.Character.Humanoid.Health)
    end
end)

-- List Players
UI:AddButton(UtilitiesTab.Name, "List All Players", function()
    print("=== PLAYERS ===")
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        print("- " .. player.Name)
    end
end)

-- Get Game Info
UI:AddButton(UtilitiesTab.Name, "Print Game Info", function()
    print("=== GAME INFO ===")
    print("Game ID: " .. game.GameId)
    print("Place ID: " .. game.PlaceId)
    print("Players: " .. #game:GetService("Players"):GetPlayers())
end)

-- Clear Console
UI:AddButton(UtilitiesTab.Name, "Clear Console", function()
    print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
end)

print("✅ jjsploit Script Loaded!")
print("📋 Check the UI for available options")
