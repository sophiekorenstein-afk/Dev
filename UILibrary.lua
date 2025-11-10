--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║           RAYFIELD INSPIRED UI LIBRARY - PURPLE THEME         ║
    ║                    jjsploit Compatible                        ║
    ║                                                               ║
    ║  A fully functioning UI library with:                         ║
    ║  • Tabs on the side, UI elements on the other side            ║
    ║  • Purple color scheme                                        ║
    ║  • Hide/Show GUI button                                       ║
    ║  • Delete GUI button                                          ║
    ║  • Dropdown, Sliders, Input, Toggle, Button components       ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

local UILibrary = {}
UILibrary.__index = UILibrary

-- Color Palette (Purple Theme)
local Colors = {
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

-- Create new UI Library instance
function UILibrary.new(title, subtitle)
    local self = setmetatable({}, UILibrary)
    
    self.Title = title or "UI Library"
    self.Subtitle = subtitle or "Rayfield Inspired"
    self.Tabs = {}
    self.CurrentTab = nil
    self.IsVisible = true
    self.MainGui = nil
    self.TabButtons = {}
    self.TabContents = {}
    
    self:CreateMainGui()
    
    return self
end

-- Create the main GUI structure
function UILibrary:CreateMainGui()
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UILibrary"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    if game:GetService("Players"):FindFirstChild("LocalPlayer") then
        screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    else
        screenGui.Parent = game:GetService("CoreGui")
    end
    
    self.MainGui = screenGui
    
    -- Main Container (Horizontal Layout)
    local mainContainer = Instance.new("Frame")
    mainContainer.Name = "MainContainer"
    mainContainer.Size = UDim2.new(1, 0, 1, 0)
    mainContainer.BackgroundColor3 = Colors.Darker
    mainContainer.BorderSizePixel = 0
    mainContainer.Parent = screenGui
    
    -- Left Sidebar (Tabs)
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 250, 1, 0)
    sidebar.BackgroundColor3 = Colors.Dark
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainContainer
    
    -- Sidebar Header
    local sidebarHeader = Instance.new("Frame")
    sidebarHeader.Name = "Header"
    sidebarHeader.Size = UDim2.new(1, 0, 0, 100)
    sidebarHeader.BackgroundColor3 = Colors.Darker
    sidebarHeader.BorderSizePixel = 0
    sidebarHeader.Parent = sidebar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -20, 0, 40)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Colors.Text
    titleLabel.TextSize = 24
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = self.Title
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = sidebarHeader
    
    local subtitleLabel = Instance.new("TextLabel")
    subtitleLabel.Name = "Subtitle"
    subtitleLabel.Size = UDim2.new(1, -20, 0, 30)
    subtitleLabel.Position = UDim2.new(0, 10, 0, 50)
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.TextColor3 = Colors.TextSecondary
    subtitleLabel.TextSize = 14
    subtitleLabel.Font = Enum.Font.Gotham
    subtitleLabel.Text = self.Subtitle
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    subtitleLabel.Parent = sidebarHeader
    
    -- Tab Buttons Container
    local tabButtonsContainer = Instance.new("Frame")
    tabButtonsContainer.Name = "TabButtons"
    tabButtonsContainer.Size = UDim2.new(1, 0, 1, -200)
    tabButtonsContainer.Position = UDim2.new(0, 0, 0, 100)
    tabButtonsContainer.BackgroundTransparency = 1
    tabButtonsContainer.BorderSizePixel = 0
    tabButtonsContainer.Parent = sidebar
    
    local tabButtonsLayout = Instance.new("UIListLayout")
    tabButtonsLayout.Padding = UDim.new(0, 8)
    tabButtonsLayout.Parent = tabButtonsContainer
    
    self.TabButtonsContainer = tabButtonsContainer
    
    -- Control Buttons Container (Bottom)
    local controlButtonsContainer = Instance.new("Frame")
    controlButtonsContainer.Name = "ControlButtons"
    controlButtonsContainer.Size = UDim2.new(1, 0, 0, 100)
    controlButtonsContainer.Position = UDim2.new(0, 0, 1, -100)
    controlButtonsContainer.BackgroundTransparency = 1
    controlButtonsContainer.BorderSizePixel = 0
    controlButtonsContainer.Parent = sidebar
    
    local controlLayout = Instance.new("UIListLayout")
    controlLayout.Padding = UDim.new(0, 8)
    controlLayout.Parent = controlButtonsContainer
    
    -- Hide GUI Button
    local hideButton = self:CreateButton("👁️ Hide GUI", function()
        self:ToggleVisibility()
    end)
    hideButton.Size = UDim2.new(1, -16, 0, 35)
    hideButton.Parent = controlButtonsContainer
    
    -- Delete GUI Button
    local deleteButton = self:CreateButton("🗑️ Delete GUI", function()
        self:Destroy()
    end)
    deleteButton.BackgroundColor3 = Colors.Error
    deleteButton.Size = UDim2.new(1, -16, 0, 35)
    deleteButton.Parent = controlButtonsContainer
    
    -- Right Content Area
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -250, 1, 0)
    contentArea.Position = UDim2.new(0, 250, 0, 0)
    contentArea.BackgroundColor3 = Colors.Darker
    contentArea.BorderSizePixel = 0
    contentArea.Parent = mainContainer
    
    -- Content Padding
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingLeft = UDim.new(0, 20)
    contentPadding.PaddingRight = UDim.new(0, 20)
    contentPadding.PaddingTop = UDim.new(0, 20)
    contentPadding.PaddingBottom = UDim.new(0, 20)
    contentPadding.Parent = contentArea
    
    self.ContentArea = contentArea
    self.Sidebar = sidebar
    self.MainContainer = mainContainer
end

-- Create a new Tab
function UILibrary:CreateTab(name, icon)
    icon = icon or "📋"
    
    local tab = {
        Name = name,
        Icon = icon,
        Elements = {},
        Content = nil,
        Button = nil,
    }
    
    -- Create Tab Button
    local tabButton = self:CreateButton(icon .. " " .. name, function()
        self:SelectTab(name)
    end)
    tabButton.Size = UDim2.new(1, -16, 0, 40)
    tabButton.Parent = self.TabButtonsContainer
    
    tab.Button = tabButton
    self.TabButtons[name] = tabButton
    
    -- Create Tab Content Frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = name .. "Content"
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.Visible = false
    contentFrame.Parent = self.ContentArea
    
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Name = "ScrollingFrame"
    scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollBarThickness = 8
    scrollingFrame.ScrollBarImageColor3 = Colors.Primary
    scrollingFrame.Parent = contentFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 15)
    layout.Parent = scrollingFrame
    
    tab.Content = contentFrame
    tab.ScrollingFrame = scrollingFrame
    tab.Layout = layout
    
    self.TabContents[name] = tab
    table.insert(self.Tabs, tab)
    
    -- Select first tab by default
    if self.CurrentTab == nil then
        self:SelectTab(name)
    end
    
    return tab
end

-- Select a tab
function UILibrary:SelectTab(tabName)
    -- Hide all tabs
    for name, tab in pairs(self.TabContents) do
        tab.Content.Visible = false
        tab.Button.BackgroundColor3 = Colors.Secondary
    end
    
    -- Show selected tab
    if self.TabContents[tabName] then
        self.TabContents[tabName].Content.Visible = true
        self.TabContents[tabName].Button.BackgroundColor3 = Colors.Primary
        self.CurrentTab = tabName
    end
end

-- Create a Button element
function UILibrary:CreateButton(text, callback)
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = Colors.Primary
    button.TextColor3 = Colors.Text
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.Text = text
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    
    -- Rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(168, 85, 247)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Colors.Primary
    end)
    
    -- Click callback
    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    
    return button
end

-- Add Button to Tab
function UILibrary:AddButton(tabName, text, callback)
    if not self.TabContents[tabName] then
        warn("Tab '" .. tabName .. "' not found")
        return
    end
    
    local button = self:CreateButton(text, callback)
    button.Size = UDim2.new(1, 0, 0, 40)
    button.Parent = self.TabContents[tabName].ScrollingFrame
    
    return button
end

-- Add Input field to Tab
function UILibrary:AddInput(tabName, placeholder, callback)
    if not self.TabContents[tabName] then
        warn("Tab '" .. tabName .. "' not found")
        return
    end
    
    local container = Instance.new("Frame")
    container.Name = "InputContainer"
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundTransparency = 1
    container.Parent = self.TabContents[tabName].ScrollingFrame
    
    local input = Instance.new("TextBox")
    input.Name = "Input"
    input.Size = UDim2.new(1, 0, 1, 0)
    input.BackgroundColor3 = Colors.Secondary
    input.TextColor3 = Colors.Text
    input.PlaceholderColor3 = Colors.TextSecondary
    input.PlaceholderText = placeholder or "Enter text..."
    input.TextSize = 14
    input.Font = Enum.Font.Gotham
    input.BorderSizePixel = 0
    input.ClearTextOnFocus = false
    input.Parent = container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = input
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 12)
    padding.Parent = input
    
    input.FocusLost:Connect(function(enterPressed)
        if callback then
            callback(input.Text, enterPressed)
        end
    end)
    
    return input
end

-- Add Slider to Tab
function UILibrary:AddSlider(tabName, minValue, maxValue, defaultValue, callback)
    if not self.TabContents[tabName] then
        warn("Tab '" .. tabName .. "' not found")
        return
    end
    
    minValue = minValue or 0
    maxValue = maxValue or 100
    defaultValue = defaultValue or (minValue + maxValue) / 2
    
    local container = Instance.new("Frame")
    container.Name = "SliderContainer"
    container.Size = UDim2.new(1, 0, 0, 60)
    container.BackgroundTransparency = 1
    container.Parent = self.TabContents[tabName].ScrollingFrame
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Colors.Text
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold
    label.Text = "Value: " .. tostring(math.floor(defaultValue))
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    -- Slider Background
    local sliderBg = Instance.new("Frame")
    sliderBg.Name = "SliderBg"
    sliderBg.Size = UDim2.new(1, 0, 0, 8)
    sliderBg.Position = UDim2.new(0, 0, 0, 30)
    sliderBg.BackgroundColor3 = Colors.Dark
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = container
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 4)
    sliderCorner.Parent = sliderBg
    
    -- Slider Fill
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0)
    sliderFill.BackgroundColor3 = Colors.Primary
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = sliderFill
    
    -- Slider Thumb
    local thumb = Instance.new("Frame")
    thumb.Name = "Thumb"
    thumb.Size = UDim2.new(0, 16, 0, 16)
    thumb.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -8, 0.5, -8)
    thumb.BackgroundColor3 = Colors.Primary
    thumb.BorderSizePixel = 0
    thumb.Parent = sliderBg
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(0, 8)
    thumbCorner.Parent = thumb
    
    local currentValue = defaultValue
    
    -- Mouse drag functionality
    local dragging = false
    thumb.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if dragging then
            local mouse = game:GetService("Mouse")
            local sliderSize = sliderBg.AbsoluteSize.X
            local sliderPos = sliderBg.AbsolutePosition.X
            local mouseX = mouse.X
            
            local percentage = math.clamp((mouseX - sliderPos) / sliderSize, 0, 1)
            currentValue = minValue + (maxValue - minValue) * percentage
            
            sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            thumb.Position = UDim2.new(percentage, -8, 0.5, -8)
            label.Text = "Value: " .. tostring(math.floor(currentValue))
            
            if callback then
                callback(math.floor(currentValue))
            end
        end
    end)
    
    return {
        Container = container,
        Slider = sliderBg,
        Fill = sliderFill,
        Thumb = thumb,
        Label = label,
        GetValue = function() return currentValue end,
    }
end

-- Add Toggle to Tab
function UILibrary:AddToggle(tabName, text, defaultValue, callback)
    if not self.TabContents[tabName] then
        warn("Tab '" .. tabName .. "' not found")
        return
    end
    
    defaultValue = defaultValue or false
    
    local container = Instance.new("Frame")
    container.Name = "ToggleContainer"
    container.Size = UDim2.new(1, 0, 0, 45)
    container.BackgroundColor3 = Colors.Secondary
    container.BorderSizePixel = 0
    container.Parent = self.TabContents[tabName].ScrollingFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = container
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -60, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Colors.Text
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.Text = text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local labelPadding = Instance.new("UIPadding")
    labelPadding.PaddingLeft = UDim.new(0, 12)
    labelPadding.PaddingRight = UDim.new(0, 12)
    labelPadding.Parent = label
    
    -- Toggle Switch
    local toggleSwitch = Instance.new("Frame")
    toggleSwitch.Name = "ToggleSwitch"
    toggleSwitch.Size = UDim2.new(0, 50, 0, 24)
    toggleSwitch.Position = UDim2.new(1, -60, 0.5, -12)
    toggleSwitch.BackgroundColor3 = defaultValue and Colors.Success or Colors.Dark
    toggleSwitch.BorderSizePixel = 0
    toggleSwitch.Parent = container
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(0, 12)
    switchCorner.Parent = toggleSwitch
    
    -- Toggle Circle
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Name = "Circle"
    toggleCircle.Size = UDim2.new(0, 20, 0, 20)
    toggleCircle.Position = defaultValue and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    toggleCircle.BackgroundColor3 = Colors.Text
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Parent = toggleSwitch
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(0, 10)
    circleCorner.Parent = toggleCircle
    
    local isToggled = defaultValue
    
    -- Toggle functionality
    toggleSwitch.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        
        -- Animate
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = game:GetService("TweenService"):Create(toggleCircle, tweenInfo, {
            Position = isToggled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        })
        tween:Play()
        
        local colorTween = game:GetService("TweenService"):Create(toggleSwitch, tweenInfo, {
            BackgroundColor3 = isToggled and Colors.Success or Colors.Dark
        })
        colorTween:Play()
        
        if callback then
            callback(isToggled)
        end
    end)
    
    return {
        Container = container,
        Switch = toggleSwitch,
        Circle = toggleCircle,
        GetValue = function() return isToggled end,
    }
end

-- Add Dropdown to Tab
function UILibrary:AddDropdown(tabName, options, defaultIndex, callback)
    if not self.TabContents[tabName] then
        warn("Tab '" .. tabName .. "' not found")
        return
    end
    
    defaultIndex = defaultIndex or 1
    local isOpen = false
    local selectedIndex = defaultIndex
    
    local container = Instance.new("Frame")
    container.Name = "DropdownContainer"
    container.Size = UDim2.new(1, 0, 0, 40)
    container.BackgroundTransparency = 1
    container.Parent = self.TabContents[tabName].ScrollingFrame
    
    -- Dropdown Button
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Name = "DropdownButton"
    dropdownButton.Size = UDim2.new(1, 0, 0, 40)
    dropdownButton.BackgroundColor3 = Colors.Secondary
    dropdownButton.TextColor3 = Colors.Text
    dropdownButton.TextSize = 14
    dropdownButton.Font = Enum.Font.Gotham
    dropdownButton.Text = options[selectedIndex] or "Select..."
    dropdownButton.BorderSizePixel = 0
    dropdownButton.AutoButtonColor = false
    dropdownButton.Parent = container
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = dropdownButton
    
    -- Dropdown Menu
    local dropdownMenu = Instance.new("Frame")
    dropdownMenu.Name = "DropdownMenu"
    dropdownMenu.Size = UDim2.new(1, 0, 0, 0)
    dropdownMenu.Position = UDim2.new(0, 0, 1, 5)
    dropdownMenu.BackgroundColor3 = Colors.Secondary
    dropdownMenu.BorderSizePixel = 0
    dropdownMenu.Visible = false
    dropdownMenu.ClipsDescendants = true
    dropdownMenu.Parent = container
    
    local menuCorner = Instance.new("UICorner")
    menuCorner.CornerRadius = UDim.new(0, 8)
    menuCorner.Parent = dropdownMenu
    
    local menuLayout = Instance.new("UIListLayout")
    menuLayout.Padding = UDim.new(0, 0)
    menuLayout.Parent = dropdownMenu
    
    -- Create menu items
    for i, option in ipairs(options) do
        local menuItem = Instance.new("TextButton")
        menuItem.Name = "MenuItem"
        menuItem.Size = UDim2.new(1, 0, 0, 35)
        menuItem.BackgroundColor3 = Colors.Secondary
        menuItem.TextColor3 = Colors.Text
        menuItem.TextSize = 12
        menuItem.Font = Enum.Font.Gotham
        menuItem.Text = option
        menuItem.BorderSizePixel = 0
        menuItem.AutoButtonColor = false
        menuItem.Parent = dropdownMenu
        
        menuItem.MouseEnter:Connect(function()
            menuItem.BackgroundColor3 = Colors.Primary
        end)
        
        menuItem.MouseLeave:Connect(function()
            menuItem.BackgroundColor3 = Colors.Secondary
        end)
        
        menuItem.MouseButton1Click:Connect(function()
            selectedIndex = i
            dropdownButton.Text = option
            isOpen = false
            
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = game:GetService("TweenService"):Create(dropdownMenu, tweenInfo, {
                Size = UDim2.new(1, 0, 0, 0)
            })
            tween:Play()
            
            if callback then
                callback(option, i)
            end
        end)
    end
    
    -- Toggle dropdown
    dropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local targetSize = isOpen and UDim2.new(1, 0, 0, #options * 35) or UDim2.new(1, 0, 0, 0)
        
        local tween = game:GetService("TweenService"):Create(dropdownMenu, tweenInfo, {
            Size = targetSize
        })
        tween:Play()
        
        dropdownMenu.Visible = isOpen
    end)
    
    return {
        Container = container,
        Button = dropdownButton,
        Menu = dropdownMenu,
        GetValue = function() return options[selectedIndex] end,
        GetIndex = function() return selectedIndex end,
    }
end

-- Toggle GUI visibility
function UILibrary:ToggleVisibility()
    self.IsVisible = not self.IsVisible
    self.MainContainer.Visible = self.IsVisible
end

-- Destroy GUI
function UILibrary:Destroy()
    if self.MainGui then
        self.MainGui:Destroy()
    end
end

return UILibrary
