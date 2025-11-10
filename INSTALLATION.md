# Installation Guide

## Quick Start (Recommended)

### Step 1: Copy the Load Code
```lua
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/lua-ui-library/main/UILibrary.lua"))()
```

### Step 2: Paste into Your Script
Open your exploit's script executor and paste the code above at the beginning of your script.

### Step 3: Create Your UI
```lua
local UI = UILibrary.new("My Script", "v1.0")
local MainTab = UI:CreateTab("Main", "🏠")
UI:AddButton(MainTab.Name, "Click Me!", function()
    print("Hello!")
end)
```

---

## Installation Methods

### Method 1: Direct Load (Best for Updates)
```lua
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/lua-ui-library/main/UILibrary.lua"))()
```

**Pros:**
- Always loads the latest version
- No file management needed
- Easy to share scripts

**Cons:**
- Requires internet connection
- Slightly slower load time

---

### Method 2: Local File (Fastest)
1. Download `UILibrary.lua` from GitHub
2. Save to your exploit's scripts folder
3. Load with:
```lua
local UILibrary = loadstring(readfile("UILibrary.lua"))()
```

**Pros:**
- Fastest loading
- Works offline
- No internet required

**Cons:**
- Manual updates needed
- File management required

---

### Method 3: Pastebin (Legacy)
1. Upload `UILibrary.lua` to Pastebin
2. Get the raw paste ID
3. Load with:
```lua
local UILibrary = loadstring(game:HttpGet("https://pastebin.com/raw/PASTE_ID"))()
```

---

## Exploit-Specific Setup

### jjsploit
1. Open jjsploit
2. Click "Script Executor"
3. Paste the load code
4. Click "Execute"

```lua
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/lua-ui-library/main/UILibrary.lua"))()
local UI = UILibrary.new("jjsploit Script", "v1.0")
-- Your code here
```

---

### Synapse X
1. Open Synapse X
2. Go to "Script Executor"
3. Paste the load code
4. Press F9 to execute

```lua
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/lua-ui-library/main/UILibrary.lua"))()
local UI = UILibrary.new("Synapse Script", "v1.0")
-- Your code here
```

---

### Script-Ware
1. Open Script-Ware
2. Click "Script Executor"
3. Paste the load code
4. Click "Execute"

```lua
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/lua-ui-library/main/UILibrary.lua"))()
local UI = UILibrary.new("Script-Ware Script", "v1.0")
-- Your code here
```

---

### Other Exploits
Most exploits support the same basic syntax:

```lua
-- Load the library
local UILibrary = loadstring(game:HttpGet("URL_TO_UILIB"))()

-- Create UI
local UI = UILibrary.new("Title", "Subtitle")

-- Add content
local Tab = UI:CreateTab("Tab Name", "Icon")
UI:AddButton(Tab.Name, "Button", function()
    print("Clicked!")
end)
```

---

## Troubleshooting Installation

### "HttpGet is not allowed"
**Solution:** Enable HttpGet in your exploit settings
- jjsploit: Settings → Enable HttpGet
- Synapse X: Settings → Execution → Allow HttpGet
- Script-Ware: Settings → Security → Allow HttpGet

### "Failed to load library"
**Solution:** Check your internet connection and try again
```lua
-- Add error handling
local success, UILibrary = pcall(function()
    return loadstring(game:HttpGet("URL"))()
end)

if not success then
    print("Failed to load UILibrary!")
    return
end
```

### "readfile is not allowed"
**Solution:** Use direct load instead of local file
```lua
-- Instead of:
-- local UILibrary = loadstring(readfile("UILibrary.lua"))()

-- Use:
local UILibrary = loadstring(game:HttpGet("https://..."))()
```

### "game:HttpGet is not available"
**Solution:** Your exploit doesn't support HttpGet. Use local file method instead.

---

## Verifying Installation

After loading, check if the library is working:

```lua
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/lua-ui-library/main/UILibrary.lua"))()

-- Test: Create UI
local UI = UILibrary.new("Test", "v1.0")
print("✅ UILibrary loaded successfully!")

-- Test: Create tab
local TestTab = UI:CreateTab("Test", "✅")
print("✅ Tab created successfully!")

-- Test: Add button
UI:AddButton(TestTab.Name, "Test Button", function()
    print("✅ Button works!")
end)
print("✅ All tests passed!")
```

---

## Performance Tips

### Optimize Load Time
```lua
-- Load library once, reuse it
local UILibrary = loadstring(game:HttpGet("..."))()

-- Create multiple UIs from same library
local UI1 = UILibrary.new("Script 1", "v1.0")
local UI2 = UILibrary.new("Script 2", "v1.0")
```

### Minimize Network Calls
```lua
-- Good: Load once
local UILibrary = loadstring(game:HttpGet("..."))()

-- Bad: Load multiple times
for i = 1, 10 do
    local UILibrary = loadstring(game:HttpGet("..."))()
end
```

---

## Next Steps

1. **Read the README**: Full API documentation
2. **Check Examples**: See `EXAMPLE_USAGE.lua` and `JJSPLOIT_EXAMPLE.lua`
3. **Start Building**: Create your first script!

---

## Support

Having issues? Check:
1. Your exploit supports the required functions
2. HttpGet is enabled in your exploit settings
3. You have internet connection
4. The GitHub URL is correct

For more help, open an issue on GitHub!
