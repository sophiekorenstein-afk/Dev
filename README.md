# UILibrary - Rayfield Inspired Lua UI Library

A fully functioning, professional-grade UI library for Roblox exploits inspired by Rayfield. Features a purple theme, side tabs navigation, and all essential UI components.

## Features

✨ **Modern Design**
- Purple color scheme with smooth animations
- Side tabs navigation (tabs on left, content on right)
- Responsive and clean interface
- Rounded corners and hover effects

🎮 **Full Component Support**
- Buttons with callbacks
- Text Input fields
- Sliders with drag functionality
- Toggle switches with animations
- Dropdown menus with smooth transitions

🔧 **Easy to Use**
- Simple API similar to Rayfield
- Chainable methods
- Callback-based interactions
- No dependencies required

✅ **Compatibility**
- jjsploit ✓
- Synapse X ✓
- Script-Ware ✓
- Other Roblox exploits ✓

## Installation

### Method 1: Direct Load (Recommended)
```lua
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/lua-ui-library/main/UILibrary.lua"))()
```

### Method 2: Local File
1. Download `UILibrary.lua`
2. Place in your scripts folder
3. Load with: `local UILibrary = loadstring(readfile("UILibrary.lua"))()`

## Quick Start

```lua
-- Load the library
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/lua-ui-library/main/UILibrary.lua"))()

-- Create UI instance
local UI = UILibrary.new("My Script", "v1.0")

-- Create a tab
local MainTab = UI:CreateTab("Main", "🏠")

-- Add a button
UI:AddButton(MainTab.Name, "Click Me!", function()
    print("Button clicked!")
end)

-- Add a slider
UI:AddSlider(MainTab.Name, 0, 100, 50, function(value)
    print("Value: " .. value)
end)

-- Add a toggle
UI:AddToggle(MainTab.Name, "Enable Feature", false, function(enabled)
    print("Feature: " .. (enabled and "ON" or "OFF"))
end)

-- Add a dropdown
UI:AddDropdown(MainTab.Name, {"Option 1", "Option 2", "Option 3"}, 1, function(selected, index)
    print("Selected: " .. selected)
end)

-- Add an input field
UI:AddInput(MainTab.Name, "Enter text...", function(text, enterPressed)
    if enterPressed then
        print("You entered: " .. text)
    end
end)
```

## API Reference

### Creating UI Instance

```lua
local UI = UILibrary.new(title, subtitle)
```

**Parameters:**
- `title` (string): Main title of the UI
- `subtitle` (string): Subtitle/version text

**Returns:** UI instance

---

### Creating Tabs

```lua
local Tab = UI:CreateTab(name, icon)
```

**Parameters:**
- `name` (string): Tab name
- `icon` (string): Emoji or icon for the tab

**Returns:** Tab object

**Example:**
```lua
local MainTab = UI:CreateTab("Main", "🏠")
local SettingsTab = UI:CreateTab("Settings", "⚙️")
```

---

### Adding Buttons

```lua
UI:AddButton(tabName, text, callback)
```

**Parameters:**
- `tabName` (string): Name of the tab to add button to
- `text` (string): Button text
- `callback` (function): Function to call when clicked

**Example:**
```lua
UI:AddButton(MainTab.Name, "Teleport", function()
    game:GetService("Players").LocalPlayer.Character:MoveTo(Vector3.new(0, 50, 0))
end)
```

---

### Adding Input Fields

```lua
UI:AddInput(tabName, placeholder, callback)
```

**Parameters:**
- `tabName` (string): Name of the tab
- `placeholder` (string): Placeholder text
- `callback` (function): Called with (text, enterPressed)

**Example:**
```lua
UI:AddInput(MainTab.Name, "Enter username...", function(text, enterPressed)
    if enterPressed then
        print("Username: " .. text)
    end
end)
```

---

### Adding Sliders

```lua
UI:AddSlider(tabName, minValue, maxValue, defaultValue, callback)
```

**Parameters:**
- `tabName` (string): Name of the tab
- `minValue` (number): Minimum slider value
- `maxValue` (number): Maximum slider value
- `defaultValue` (number): Initial value
- `callback` (function): Called with (value) as user drags

**Returns:** Slider object with `GetValue()` method

**Example:**
```lua
UI:AddSlider(MainTab.Name, 0, 100, 50, function(value)
    print("Speed: " .. value .. "%")
end)
```

---

### Adding Toggles

```lua
UI:AddToggle(tabName, text, defaultValue, callback)
```

**Parameters:**
- `tabName` (string): Name of the tab
- `text` (string): Toggle label
- `defaultValue` (boolean): Initial state (true/false)
- `callback` (function): Called with (enabled) boolean

**Returns:** Toggle object with `GetValue()` method

**Example:**
```lua
UI:AddToggle(MainTab.Name, "God Mode", false, function(enabled)
    if enabled then
        print("God Mode: ON")
    else
        print("God Mode: OFF")
    end
end)
```

---

### Adding Dropdowns

```lua
UI:AddDropdown(tabName, options, defaultIndex, callback)
```

**Parameters:**
- `tabName` (string): Name of the tab
- `options` (table): Array of option strings
- `defaultIndex` (number): Default selected index (1-based)
- `callback` (function): Called with (selectedText, selectedIndex)

**Returns:** Dropdown object with `GetValue()` and `GetIndex()` methods

**Example:**
```lua
UI:AddDropdown(MainTab.Name, {"Easy", "Normal", "Hard"}, 2, function(selected, index)
    print("Difficulty: " .. selected)
end)
```

---

### Controlling Visibility

```lua
UI:ToggleVisibility()
```

Toggles the GUI visibility on/off. A "Show GUI" button appears when hidden.

---

### Destroying the UI

```lua
UI:Destroy()
```

Completely removes the UI from the screen.

---

## Color Palette

The library uses a professional purple theme:

| Color | RGB | Usage |
|-------|-----|-------|
| Primary | (147, 51, 234) | Main buttons, active states |
| Secondary | (168, 85, 247) | Input fields, secondary elements |
| Dark | (88, 28, 135) | Sidebar background |
| Darker | (59, 18, 90) | Main background |
| Text | (255, 255, 255) | Primary text |
| TextSecondary | (200, 200, 200) | Secondary text |
| Accent | (236, 72, 153) | Highlights, accents |
| Success | (34, 197, 94) | Toggle ON state |
| Error | (239, 68, 68) | Delete button, errors |

---

## Advanced Usage

### Multiple Tabs with Different Content

```lua
local UI = UILibrary.new("Advanced Script", "v2.0")

-- Create multiple tabs
local PlayerTab = UI:CreateTab("Player", "👤")
local WorldTab = UI:CreateTab("World", "🌍")
local SettingsTab = UI:CreateTab("Settings", "⚙️")

-- Player Tab
UI:AddButton(PlayerTab.Name, "Heal", function()
    print("Healing player...")
end)

UI:AddSlider(PlayerTab.Name, 1, 100, 50, function(value)
    print("Health: " .. value)
end)

-- World Tab
UI:AddToggle(WorldTab.Name, "Infinite Stamina", false, function(enabled)
    print("Stamina: " .. (enabled and "Infinite" or "Normal"))
end)

UI:AddDropdown(WorldTab.Name, {"Day", "Night", "Sunset"}, 1, function(selected)
    print("Time: " .. selected)
end)

-- Settings Tab
UI:AddInput(SettingsTab.Name, "Script name...", function(text)
    print("Name: " .. text)
end)

UI:AddToggle(SettingsTab.Name, "Auto-Save", true, function(enabled)
    print("Auto-Save: " .. (enabled and "ON" or "OFF"))
end)
```

### Creating Interactive Features

```lua
local UI = UILibrary.new("Interactive Script", "v1.0")
local MainTab = UI:CreateTab("Main", "🎮")

-- Speed multiplier
local speedSlider = UI:AddSlider(MainTab.Name, 1, 5, 1, function(value)
    -- Update player speed
    local player = game:GetService("Players").LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 16 * value
    end
end)

-- Auto-farm toggle
local autoFarmEnabled = false
UI:AddToggle(MainTab.Name, "Auto Farm", false, function(enabled)
    autoFarmEnabled = enabled
    if enabled then
        -- Start farming loop
        while autoFarmEnabled do
            print("Farming...")
            wait(1)
        end
    end
end)

-- Teleport to location
UI:AddDropdown(MainTab.Name, {"Spawn", "Boss", "Treasure", "Safe Zone"}, 1, function(selected)
    local locations = {
        Spawn = Vector3.new(0, 50, 0),
        Boss = Vector3.new(100, 50, 100),
        Treasure = Vector3.new(-100, 50, -100),
        ["Safe Zone"] = Vector3.new(0, 50, 0),
    }
    
    local player = game:GetService("Players").LocalPlayer
    if player.Character then
        player.Character:MoveTo(locations[selected])
    end
end)
```

---

## Troubleshooting

### UI Not Appearing
- Make sure you're in a game
- Check that the exploit supports `Instance.new()`
- Try reloading the script

### Buttons Not Working
- Ensure callbacks are valid functions
- Check console for errors (F9)
- Verify the tab name is correct

### Sliders Not Dragging
- Make sure mouse input is enabled
- Try clicking and dragging more deliberately
- Check that the exploit supports mouse input

### Dropdowns Not Opening
- Verify the options table is not empty
- Check that you're clicking the dropdown button
- Ensure the exploit supports TweenService

---

## Performance Tips

1. **Minimize callbacks**: Avoid heavy operations in callbacks
2. **Use toggles wisely**: Don't run infinite loops in toggle callbacks
3. **Optimize sliders**: Slider callbacks fire frequently, keep them light
4. **Clean up**: Call `UI:Destroy()` when done to free resources

---

## License

This library is free to use and modify. Feel free to customize it for your needs!

---

## Support

For issues, questions, or suggestions, please open an issue on GitHub.

---

## Credits

Inspired by Rayfield UI Library
Created for the Roblox exploit community

---

**Happy scripting! 🚀**
