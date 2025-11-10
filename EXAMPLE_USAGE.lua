--[[
    EXAMPLE USAGE - UILibrary
    
    This file demonstrates how to use the UILibrary in your scripts.
    Compatible with: jjsploit, Synapse X, Script-Ware, and other Roblox exploits
]]

-- Load the library
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/lua-ui-library/main/UILibrary.lua"))()

-- Create a new UI instance
local UI = UILibrary.new("My Script", "v1.0")

-- ============================================
-- CREATE TABS
-- ============================================

local ButtonsTab = UI:CreateTab("Buttons", "🔘")
local InputsTab = UI:CreateTab("Inputs", "📝")
local SlidersTab = UI:CreateTab("Sliders", "🎚️")
local TogglesTab = UI:CreateTab("Toggles", "⚙️")
local DropdownsTab = UI:CreateTab("Dropdowns", "📋")

-- ============================================
-- BUTTONS TAB
-- ============================================

UI:AddButton(ButtonsTab.Name, "Click Me!", function()
    print("Button clicked!")
end)

UI:AddButton(ButtonsTab.Name, "Print Player Name", function()
    local player = game:GetService("Players").LocalPlayer
    print("Player: " .. player.Name)
end)

UI:AddButton(ButtonsTab.Name, "Teleport to Spawn", function()
    local player = game:GetService("Players").LocalPlayer
    if player.Character then
        player.Character:MoveTo(Vector3.new(0, 50, 0))
    end
end)

-- ============================================
-- INPUTS TAB
-- ============================================

UI:AddInput(InputsTab.Name, "Enter your name...", function(text, enterPressed)
    if enterPressed then
        print("You entered: " .. text)
    end
end)

UI:AddInput(InputsTab.Name, "Enter a number...", function(text, enterPressed)
    if enterPressed then
        local num = tonumber(text)
        if num then
            print("Number: " .. num)
        else
            print("Invalid number!")
        end
    end
end)

-- ============================================
-- SLIDERS TAB
-- ============================================

UI:AddSlider(SlidersTab.Name, 0, 100, 50, function(value)
    print("Slider value: " .. value)
end)

UI:AddSlider(SlidersTab.Name, 1, 10, 5, function(value)
    print("Speed multiplier: " .. value .. "x")
end)

UI:AddSlider(SlidersTab.Name, 0, 255, 128, function(value)
    print("Opacity: " .. value)
end)

-- ============================================
-- TOGGLES TAB
-- ============================================

UI:AddToggle(TogglesTab.Name, "Enable God Mode", false, function(enabled)
    if enabled then
        print("God Mode: ENABLED")
    else
        print("God Mode: DISABLED")
    end
end)

UI:AddToggle(TogglesTab.Name, "Auto Farm", false, function(enabled)
    if enabled then
        print("Auto Farm: ENABLED")
    else
        print("Auto Farm: DISABLED")
    end
end)

UI:AddToggle(TogglesTab.Name, "Show Hitboxes", false, function(enabled)
    if enabled then
        print("Hitboxes: VISIBLE")
    else
        print("Hitboxes: HIDDEN")
    end
end)

-- ============================================
-- DROPDOWNS TAB
-- ============================================

UI:AddDropdown(DropdownsTab.Name, {"Option 1", "Option 2", "Option 3", "Option 4"}, 1, function(selected, index)
    print("Selected: " .. selected .. " (Index: " .. index .. ")")
end)

UI:AddDropdown(DropdownsTab.Name, {"Light", "Dark", "Auto"}, 2, function(selected, index)
    print("Theme changed to: " .. selected)
end)

UI:AddDropdown(DropdownsTab.Name, {"Easy", "Normal", "Hard", "Impossible"}, 2, function(selected, index)
    print("Difficulty set to: " .. selected)
end)

print("UI Library loaded successfully!")
