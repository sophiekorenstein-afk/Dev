# Complete API Reference

## Table of Contents
1. [Core Functions](#core-functions)
2. [Tab Management](#tab-management)
3. [UI Components](#ui-components)
4. [Advanced Features](#advanced-features)
5. [Events & Callbacks](#events--callbacks)
6. [Color Reference](#color-reference)

---

## Core Functions

### UILibrary.new(title, subtitle)

Creates a new UI Library instance.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| title | string | Yes | Main title displayed in sidebar |
| subtitle | string | No | Subtitle/version text |

**Returns:** UI instance object

**Example:**
```lua
local UI = UILibrary.new("My Script", "v1.0")
local UI2 = UILibrary.new("Another Script")  -- subtitle optional
```

**Properties:**
```lua
UI.Title          -- string: The UI title
UI.Subtitle       -- string: The UI subtitle
UI.Tabs           -- table: Array of all tabs
UI.CurrentTab     -- string: Currently selected tab name
UI.IsVisible      -- boolean: GUI visibility state
UI.MainGui        -- Instance: The ScreenGui object
UI.ContentArea    -- Instance: Content frame
UI.Sidebar        -- Instance: Sidebar frame
```

---

## Tab Management

### UI:CreateTab(name, icon)

Creates a new tab in the sidebar.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| name | string | Yes | Tab name (used as identifier) |
| icon | string | No | Emoji or icon for the tab |

**Returns:** Tab object

**Example:**
```lua
local MainTab = UI:CreateTab("Main", "🏠")
local SettingsTab = UI:CreateTab("Settings", "⚙️")
local PlayerTab = UI:CreateTab("Player", "👤")
```

**Tab Object Properties:**
```lua
tab.Name              -- string: Tab name
tab.Icon              -- string: Tab icon
tab.Elements          -- table: Array of elements in tab
tab.Content           -- Instance: Content frame
tab.ScrollingFrame    -- Instance: Scrolling container
tab.Layout            -- Instance: UIListLayout
tab.Button            -- Instance: Tab button in sidebar
```

### UI:SelectTab(tabName)

Programmatically select a tab.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| tabName | string | Yes | Name of tab to select |

**Example:**
```lua
UI:SelectTab("Main")
UI:SelectTab("Settings")
```

---

## UI Components

### Buttons

#### UI:AddButton(tabName, text, callback)

Adds a clickable button to a tab.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| tabName | string | Yes | Name of tab to add to |
| text | string | Yes | Button text |
| callback | function | Yes | Function called on click |

**Returns:** Button instance

**Example:**
```lua
UI:AddButton(MainTab.Name, "Click Me!", function()
    print("Button clicked!")
end)

UI:AddButton(MainTab.Name, "Teleport", function()
    local player = game:GetService("Players").LocalPlayer
    if player.Character then
        player.Character:MoveTo(Vector3.new(0, 50, 0))
    end
end)
```

**Button Properties:**
```lua
button.Size              -- UDim2: Button size
button.BackgroundColor3  -- Color3: Button color
button.TextColor3        -- Color3: Text color
button.Text              -- string: Button text
```

---

### Input Fields

#### UI:AddInput(tabName, placeholder, callback)

Adds a text input field to a tab.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| tabName | string | Yes | Name of tab to add to |
| placeholder | string | No | Placeholder text |
| callback | function | Yes | Called with (text, enterPressed) |

**Returns:** TextBox instance

**Example:**
```lua
UI:AddInput(MainTab.Name, "Enter your name...", function(text, enterPressed)
    if enterPressed then
        print("Name: " .. text)
    end
end)

UI:AddInput(MainTab.Name, "Enter a number...", function(text, enterPressed)
    local num = tonumber(text)
    if num then
        print("Number: " .. num)
    end
end)
```

**Input Properties:**
```lua
input.Text              -- string: Current input text
input.PlaceholderText   -- string: Placeholder text
input.TextSize          -- number: Font size
input.Font              -- Enum.Font: Font type
```

**Callback Parameters:**
- `text` (string): The input text
- `enterPressed` (boolean): True if Enter was pressed

---

### Sliders

#### UI:AddSlider(tabName, minValue, maxValue, defaultValue, callback)

Adds a draggable slider to a tab.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| tabName | string | Yes | Name of tab to add to |
| minValue | number | No | Minimum value (default: 0) |
| maxValue | number | No | Maximum value (default: 100) |
| defaultValue | number | No | Initial value |
| callback | function | Yes | Called with (value) as user drags |

**Returns:** Slider object with methods

**Example:**
```lua
UI:AddSlider(MainTab.Name, 0, 100, 50, function(value)
    print("Value: " .. value)
end)

UI:AddSlider(MainTab.Name, 1, 10, 5, function(value)
    local player = game:GetService("Players").LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 16 * value
    end
end)
```

**Slider Object Methods:**
```lua
slider:GetValue()  -- Returns current slider value
```

**Slider Properties:**
```lua
slider.Container   -- Instance: Container frame
slider.Slider      -- Instance: Slider background
slider.Fill        -- Instance: Filled portion
slider.Thumb       -- Instance: Draggable thumb
slider.Label       -- Instance: Value label
```

---

### Toggles

#### UI:AddToggle(tabName, text, defaultValue, callback)

Adds an on/off toggle switch to a tab.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| tabName | string | Yes | Name of tab to add to |
| text | string | Yes | Toggle label |
| defaultValue | boolean | No | Initial state (default: false) |
| callback | function | Yes | Called with (enabled) boolean |

**Returns:** Toggle object with methods

**Example:**
```lua
UI:AddToggle(MainTab.Name, "God Mode", false, function(enabled)
    if enabled then
        print("God Mode: ON")
    else
        print("God Mode: OFF")
    end
end)

UI:AddToggle(MainTab.Name, "Auto Farm", false, function(enabled)
    if enabled then
        while enabled do
            print("Farming...")
            wait(1)
        end
    end
end)
```

**Toggle Object Methods:**
```lua
toggle:GetValue()  -- Returns current toggle state (true/false)
```

**Toggle Properties:**
```lua
toggle.Container   -- Instance: Container frame
toggle.Switch      -- Instance: Switch background
toggle.Circle      -- Instance: Toggle circle
```

---

### Dropdowns

#### UI:AddDropdown(tabName, options, defaultIndex, callback)

Adds a dropdown menu to a tab.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| tabName | string | Yes | Name of tab to add to |
| options | table | Yes | Array of option strings |
| defaultIndex | number | No | Default selected index (1-based) |
| callback | function | Yes | Called with (selectedText, selectedIndex) |

**Returns:** Dropdown object with methods

**Example:**
```lua
UI:AddDropdown(MainTab.Name, {"Easy", "Normal", "Hard"}, 2, function(selected, index)
    print("Difficulty: " .. selected .. " (Index: " .. index .. ")")
end)

UI:AddDropdown(MainTab.Name, {"Light", "Dark", "Auto"}, 1, function(selected)
    print("Theme: " .. selected)
end)
```

**Dropdown Object Methods:**
```lua
dropdown:GetValue()   -- Returns selected option text
dropdown:GetIndex()   -- Returns selected option index (1-based)
```

**Dropdown Properties:**
```lua
dropdown.Container   -- Instance: Container frame
dropdown.Button      -- Instance: Dropdown button
dropdown.Menu        -- Instance: Dropdown menu frame
```

---

## Advanced Features

### GUI Visibility Control

#### UI:ToggleVisibility()

Toggles the GUI visibility on/off.

**Example:**
```lua
UI:ToggleVisibility()  -- Hide GUI
UI:ToggleVisibility()  -- Show GUI

-- Check current state
if UI.IsVisible then
    print("GUI is visible")
else
    print("GUI is hidden")
end
```

**Behavior:**
- When hidden, a "Show GUI" button appears in bottom-right corner
- When shown, the full UI appears
- All functionality is preserved when hidden

---

### Destroying the UI

#### UI:Destroy()

Completely removes the UI from the screen.

**Example:**
```lua
UI:Destroy()  -- Remove UI permanently
```

**Note:** After destroying, you cannot recreate the same UI instance. Create a new one instead.

---

## Events & Callbacks

### Button Callbacks

```lua
UI:AddButton(tab.Name, "Test", function()
    -- This function is called when button is clicked
    print("Button clicked!")
end)
```

### Input Callbacks

```lua
UI:AddInput(tab.Name, "Enter text...", function(text, enterPressed)
    -- text: The input text
    -- enterPressed: true if Enter was pressed, false if focus lost
    
    if enterPressed then
        print("User pressed Enter with: " .. text)
    else
        print("User left input with: " .. text)
    end
end)
```

### Slider Callbacks

```lua
UI:AddSlider(tab.Name, 0, 100, 50, function(value)
    -- Called frequently as user drags
    -- value: Current slider value (integer)
    print("Slider value: " .. value)
end)
```

### Toggle Callbacks

```lua
UI:AddToggle(tab.Name, "Feature", false, function(enabled)
    -- enabled: true if toggle is ON, false if OFF
    if enabled then
        print("Feature enabled")
    else
        print("Feature disabled")
    end
end)
```

### Dropdown Callbacks

```lua
UI:AddDropdown(tab.Name, {"A", "B", "C"}, 1, function(selected, index)
    -- selected: The selected option text
    -- index: The selected option index (1-based)
    print("Selected: " .. selected .. " at index " .. index)
end)
```

---

## Color Reference

### Default Color Palette

```lua
Colors = {
    Primary = Color3.fromRGB(147, 51, 234),      -- Purple
    Secondary = Color3.fromRGB(168, 85, 247),    -- Light Purple
    Dark = Color3.fromRGB(88, 28, 135),          -- Dark Purple
    Darker = Color3.fromRGB(59, 18, 90),         -- Darker Purple
    Text = Color3.fromRGB(255, 255, 255),        -- White
    TextSecondary = Color3.fromRGB(200, 200, 200), -- Light Gray
    Accent = Color3.fromRGB(236, 72, 153),       -- Pink Accent
    Success = Color3.fromRGB(34, 197, 94),       -- Green
    Error = Color3.fromRGB(239, 68, 68),         -- Red
}
```

### Using Custom Colors

```lua
-- Modify button color
local button = UI:AddButton(tab.Name, "Custom", function()
    print("Clicked!")
end)
button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- Green
button.TextColor3 = Color3.fromRGB(0, 0, 0)          -- Black
```

---

## Complete Example

```lua
-- Load library
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/lua-ui-library/main/UILibrary.lua"))()

-- Create UI
local UI = UILibrary.new("Complete Example", "v1.0")

-- Create tabs
local MainTab = UI:CreateTab("Main", "🏠")
local SettingsTab = UI:CreateTab("Settings", "⚙️")

-- Main Tab
UI:AddButton(MainTab.Name, "Action 1", function()
    print("Action 1 executed")
end)

local speedSlider = UI:AddSlider(MainTab.Name, 1, 5, 1, function(value)
    print("Speed: " .. value .. "x")
end)

UI:AddToggle(MainTab.Name, "Feature", false, function(enabled)
    print("Feature: " .. (enabled and "ON" or "OFF"))
end)

UI:AddDropdown(MainTab.Name, {"Option 1", "Option 2", "Option 3"}, 1, function(selected)
    print("Selected: " .. selected)
end)

-- Settings Tab
UI:AddInput(SettingsTab.Name, "Enter name...", function(text, enterPressed)
    if enterPressed then
        print("Name: " .. text)
    end
end)

UI:AddToggle(SettingsTab.Name, "Auto-Save", true, function(enabled)
    print("Auto-Save: " .. (enabled and "ON" or "OFF"))
end)

print("✅ UI loaded successfully!")
```

---

## Performance Considerations

### Callback Optimization

```lua
-- Good: Light callback
UI:AddSlider(tab.Name, 0, 100, 50, function(value)
    print(value)  -- Fast
end)

-- Bad: Heavy callback
UI:AddSlider(tab.Name, 0, 100, 50, function(value)
    for i = 1, 1000 do
        local x = math.sqrt(i)  -- Slow, called frequently
    end
end)
```

### Memory Management

```lua
-- Good: Reuse UI instance
local UI = UILibrary.new("Script", "v1.0")
local tab1 = UI:CreateTab("Tab 1", "1️⃣")
local tab2 = UI:CreateTab("Tab 2", "2️⃣")

-- Bad: Create multiple instances
local UI1 = UILibrary.new("Script", "v1.0")
local UI2 = UILibrary.new("Script", "v1.0")
local UI3 = UILibrary.new("Script", "v1.0")
```

---

## Troubleshooting

### Component Not Appearing
- Verify tab name is correct
- Check that tab exists before adding components
- Ensure tab is visible (selected)

### Callback Not Firing
- Verify callback is a valid function
- Check console for errors (F9)
- Ensure component is properly created

### Performance Issues
- Reduce callback complexity
- Avoid heavy operations in callbacks
- Use toggles instead of loops when possible

---

For more examples, see `EXAMPLE_USAGE.lua` and `JJSPLOIT_EXAMPLE.lua`!
