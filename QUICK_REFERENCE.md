# Quick Reference Guide

## 🚀 30-Second Setup

```lua
-- 1. Load library
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/lua-ui-library/main/UILibrary.lua"))()

-- 2. Create UI
local UI = UILibrary.new("My Script", "v1.0")

-- 3. Create tab
local Tab = UI:CreateTab("Main", "🏠")

-- 4. Add components
UI:AddButton(Tab.Name, "Click Me!", function() print("Clicked!") end)

-- Done! 🎉
```

---

## 📚 All Components

### Button
```lua
UI:AddButton(tabName, "Button Text", function()
    print("Button clicked!")
end)
```

### Input
```lua
UI:AddInput(tabName, "Placeholder...", function(text, enterPressed)
    if enterPressed then
        print("Input: " .. text)
    end
end)
```

### Slider
```lua
UI:AddSlider(tabName, 0, 100, 50, function(value)
    print("Value: " .. value)
end)
```

### Toggle
```lua
UI:AddToggle(tabName, "Feature", false, function(enabled)
    print("Feature: " .. (enabled and "ON" or "OFF"))
end)
```

### Dropdown
```lua
UI:AddDropdown(tabName, {"Option 1", "Option 2", "Option 3"}, 1, function(selected, index)
    print("Selected: " .. selected)
end)
```

---

## 🎨 Colors

```lua
Colors = {
    Primary = Color3.fromRGB(147, 51, 234),      -- Purple
    Secondary = Color3.fromRGB(168, 85, 247),    -- Light Purple
    Dark = Color3.fromRGB(88, 28, 135),          -- Dark Purple
    Darker = Color3.fromRGB(59, 18, 90),         -- Darker Purple
    Text = Color3.fromRGB(255, 255, 255),        -- White
    TextSecondary = Color3.fromRGB(200, 200, 200), -- Light Gray
    Accent = Color3.fromRGB(236, 72, 153),       -- Pink
    Success = Color3.fromRGB(34, 197, 94),       -- Green
    Error = Color3.fromRGB(239, 68, 68),         -- Red
}
```

---

## 🎯 Common Patterns

### Player Speed Control
```lua
UI:AddSlider(tab.Name, 1, 5, 1, function(value)
    local player = game:GetService("Players").LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 16 * value
    end
end)
```

### God Mode Toggle
```lua
UI:AddToggle(tab.Name, "God Mode", false, function(enabled)
    local player = game:GetService("Players").LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        if enabled then
            player.Character.Humanoid.MaxHealth = math.huge
            player.Character.Humanoid.Health = math.huge
        else
            player.Character.Humanoid.MaxHealth = 100
            player.Character.Humanoid.Health = 100
        end
    end
end)
```

### Time of Day Control
```lua
UI:AddDropdown(tab.Name, {"Morning", "Noon", "Evening", "Night"}, 2, function(selected)
    local times = {Morning = 6, Noon = 12, Evening = 18, Night = 0}
    game:GetService("Lighting").ClockTime = times[selected]
end)
```

### Teleport to Player
```lua
UI:AddInput(tab.Name, "Player name...", function(text, enterPressed)
    if enterPressed and text ~= "" then
        local targetPlayer = game:GetService("Players"):FindFirstChild(text)
        if targetPlayer and targetPlayer.Character then
            local player = game:GetService("Players").LocalPlayer
            if player.Character then
                player.Character:MoveTo(targetPlayer.Character.HumanoidRootPart.Position)
            end
        end
    end
end)
```

---

## 🔧 Control Functions

### Hide/Show GUI
```lua
UI:ToggleVisibility()  -- Toggle visibility
```

### Delete GUI
```lua
UI:Destroy()  -- Remove GUI permanently
```

### Select Tab Programmatically
```lua
UI:SelectTab("Main")
```

---

## 📋 Tab Management

### Create Multiple Tabs
```lua
local MainTab = UI:CreateTab("Main", "🏠")
local SettingsTab = UI:CreateTab("Settings", "⚙️")
local PlayerTab = UI:CreateTab("Player", "👤")
local WorldTab = UI:CreateTab("World", "🌍")
local UtilsTab = UI:CreateTab("Utils", "🔧")
```

### Add Components to Tabs
```lua
-- Add to Main tab
UI:AddButton(MainTab.Name, "Action 1", function() end)

-- Add to Settings tab
UI:AddToggle(SettingsTab.Name, "Auto-Save", true, function() end)

-- Add to Player tab
UI:AddSlider(PlayerTab.Name, 0, 100, 50, function() end)
```

---

## 🎮 Real-World Examples

### Complete Script Template
```lua
-- Load library
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/lua-ui-library/main/UILibrary.lua"))()

-- Create UI
local UI = UILibrary.new("My Script", "v1.0")

-- Create tabs
local MainTab = UI:CreateTab("Main", "🏠")
local SettingsTab = UI:CreateTab("Settings", "⚙️")

-- Main Tab
UI:AddButton(MainTab.Name, "Action 1", function()
    print("Action 1")
end)

UI:AddSlider(MainTab.Name, 0, 100, 50, function(value)
    print("Value: " .. value)
end)

UI:AddToggle(MainTab.Name, "Feature", false, function(enabled)
    print("Feature: " .. (enabled and "ON" or "OFF"))
end)

-- Settings Tab
UI:AddInput(SettingsTab.Name, "Enter name...", function(text, enterPressed)
    if enterPressed then
        print("Name: " .. text)
    end
end)

UI:AddDropdown(SettingsTab.Name, {"Option 1", "Option 2"}, 1, function(selected)
    print("Selected: " .. selected)
end)

print("✅ Script loaded!")
```

---

## ⚡ Performance Tips

### ✅ Good
```lua
-- Load once, reuse
local UILibrary = loadstring(game:HttpGet("..."))()
local UI = UILibrary.new("Script", "v1.0")

-- Light callbacks
UI:AddSlider(tab.Name, 0, 100, 50, function(value)
    print(value)  -- Fast
end)
```

### ❌ Bad
```lua
-- Load multiple times
for i = 1, 10 do
    local UILibrary = loadstring(game:HttpGet("..."))()
end

-- Heavy callbacks
UI:AddSlider(tab.Name, 0, 100, 50, function(value)
    for i = 1, 1000 do
        local x = math.sqrt(i)  -- Slow
    end
end)
```

---

## 🐛 Troubleshooting

### "HttpGet is not allowed"
**Solution:** Enable HttpGet in exploit settings

### "Failed to load library"
**Solution:** Check internet connection and URL

### "Component not appearing"
**Solution:** Verify tab name is correct

### "Callback not firing"
**Solution:** Check callback is a valid function

---

## 📞 Quick Links

- **README.md** - Quick start guide
- **INSTALLATION.md** - Setup instructions
- **API_REFERENCE.md** - Complete API docs
- **FEATURES.md** - Feature overview
- **EXAMPLE_USAGE.lua** - Basic examples
- **JJSPLOIT_EXAMPLE.lua** - Real-world examples

---

## 🎯 Common Tasks

### Change Button Color
```lua
local button = UI:AddButton(tab.Name, "Button", function() end)
button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- Green
```

### Get Slider Value
```lua
local slider = UI:AddSlider(tab.Name, 0, 100, 50, function() end)
local value = slider:GetValue()
```

### Get Toggle State
```lua
local toggle = UI:AddToggle(tab.Name, "Feature", false, function() end)
local enabled = toggle:GetValue()
```

### Get Dropdown Selection
```lua
local dropdown = UI:AddDropdown(tab.Name, {"A", "B", "C"}, 1, function() end)
local selected = dropdown:GetValue()
local index = dropdown:GetIndex()
```

---

## 📊 Component Comparison

| Component | Use Case | Example |
|-----------|----------|---------|
| Button | Trigger actions | "Teleport", "Spawn Item" |
| Input | Get text input | "Player name", "Command" |
| Slider | Numeric values | Speed, Volume, Brightness |
| Toggle | On/Off features | "God Mode", "Auto Farm" |
| Dropdown | Select from options | "Theme", "Difficulty" |

---

## 🚀 Getting Started

1. **Copy the load code** from Quick Start section
2. **Paste into your exploit** script executor
3. **Create your UI** with `UILibrary.new()`
4. **Add tabs** with `UI:CreateTab()`
5. **Add components** with `UI:Add*()`
6. **Execute the script** and enjoy!

---

## 📝 Notes

- All callbacks are optional (except for buttons)
- Tab names are case-sensitive
- Component values update in real-time
- GUI persists until destroyed
- All components are fully customizable

---

## 🎉 You're Ready!

Start building amazing scripts with UILibrary! 

For more help, check the full documentation in README.md or API_REFERENCE.md.

**Happy scripting! 🚀**
