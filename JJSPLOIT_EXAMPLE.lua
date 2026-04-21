local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

-- PERSISTENCE
local SETTINGS_FILE = "mm2_hub_settings.json"

local function safeReadSettings()
	if not isfile or not readfile or not isfile(SETTINGS_FILE) then
		return {}
	end
	local ok, data = pcall(function()
		return HttpService:JSONDecode(readfile(SETTINGS_FILE))
	end)
	if ok and type(data) == "table" then
		return data
	end
	return {}
end

local function safeWriteSettings(tbl)
	if not writefile then return end
	pcall(function()
		local json = HttpService:JSONEncode(tbl)
		writefile(SETTINGS_FILE, json)
	end)
end

local saved = safeReadSettings()

-- USER SETTINGS
local HotkeyKey = Enum.KeyCode[saved.HotkeyKey or "RightShift"]
local WaitingForKey = false

local XrayKey = Enum.KeyCode[saved.XrayKey or "X"]
local WaitingForXrayKey = false

-- TOGGLES
local ChamsESPEnabled = saved.ChamsESPEnabled ~= false
local RoleESPEnabled = saved.RoleESPEnabled ~= false
local GunESPEnabled = saved.GunESPEnabled ~= false
local XrayEnabled = saved.XrayEnabled == true

local function SaveAllSettings()
	safeWriteSettings({
		HotkeyKey = HotkeyKey.Name,
		XrayKey = XrayKey.Name,
		ChamsESPEnabled = ChamsESPEnabled,
		RoleESPEnabled = RoleESPEnabled,
		GunESPEnabled = GunESPEnabled,
		XrayEnabled = XrayEnabled,
	})
end

-- ROLE CACHE (local role via GUI + others via items fallback)
local RoleCache = {}

-- REMOVE FUNCTIONS
local function RemoveChamsESP()
	for _,player in pairs(Players:GetPlayers()) do
		if player.Character then
			local esp = player.Character:FindFirstChild("ChamsESP")
			if esp then esp:Destroy() end
		end
	end
end

local function RemoveGunESP()
	for _,v in pairs(workspace:GetDescendants()) do
		if v.Name == "GunESP" then
			v:Destroy()
		end
	end
end

-- XRAY (one-time apply + new parts only)
local xrayCache = {}
local xrayConn

local function IsPlayerPart(part)
	for _,p in pairs(Players:GetPlayers()) do
		if p.Character and part:IsDescendantOf(p.Character) then
			return true
		end
	end
	return false
end

local function ApplyXrayToPart(part)
	if not part:IsA("BasePart") then return end
	if IsPlayerPart(part) then return end
	if xrayCache[part] == nil then
		xrayCache[part] = part.LocalTransparencyModifier
	end
	part.LocalTransparencyModifier = 0.65
end

local function EnableXray()
	for _,v in pairs(workspace:GetDescendants()) do
		ApplyXrayToPart(v)
	end
	if xrayConn then xrayConn:Disconnect() end
	xrayConn = workspace.DescendantAdded:Connect(function(v)
		ApplyXrayToPart(v)
	end)
end

local function DisableXray()
	if xrayConn then xrayConn:Disconnect() end
	xrayConn = nil
	for part,old in pairs(xrayCache) do
		if part and part.Parent then
			part.LocalTransparencyModifier = old
		end
	end
	xrayCache = {}
end

-- ROLE DETECTION (local via GUI, others via items)
local function ParseRoleText(t)
	t = (t or ""):lower()
	if t:find("murder") then return "Murderer" end
	if t:find("sheriff") then return "Sheriff" end
	if t:find("innocent") then return "Innocent" end
	return nil
end

local function SetLocalRole(role)
	if role then
		RoleCache[LocalPlayer] = role
	end
end

local function HookRoleLabel(lbl)
	if not lbl or not lbl:IsA("TextLabel") then return end
	local role = ParseRoleText(lbl.Text)
	if role then SetLocalRole(role) end
	lbl:GetPropertyChangedSignal("Text"):Connect(function()
		local r = ParseRoleText(lbl.Text)
		if r then SetLocalRole(r) end
	end)
end

local function ScanRoleLabel()
	local pg = LocalPlayer:FindFirstChild("PlayerGui")
	if not pg then return end
	for _,d in ipairs(pg:GetDescendants()) do
		if d.Name == "Role" and d:IsA("TextLabel") then
			HookRoleLabel(d)
		end
	end
end

local function HookPlayerGui()
	local pg = LocalPlayer:WaitForChild("PlayerGui", 10)
	if not pg then return end

	pg.DescendantAdded:Connect(function(d)
		if d.Name == "Role" and d:IsA("TextLabel") then
			HookRoleLabel(d)
		end
	end)

	ScanRoleLabel()
end

HookPlayerGui()
LocalPlayer.CharacterAdded:Connect(function()
	task.wait(0.5)
	ScanRoleLabel()
end)

local function GetMurdererV1()
	for _,v in pairs(Players:GetPlayers()) do
		if v.Character and (v.Character:FindFirstChild("Knife") or v.Backpack:FindFirstChild("Knife")) then
			return v.Character
		end
	end
end

local function GetSheriffV1()
	for _,v in pairs(Players:GetPlayers()) do
		if v.Character and (v.Character:FindFirstChild("Gun") or v.Backpack:FindFirstChild("Gun")) then
			return v.Character
		end
	end
end

local function ResolveRoleFromCache(char)
	for plr,role in pairs(RoleCache) do
		if plr.Character == char then
			return role
		end
	end
	return nil
end

local function GetRoleColor(char)
	if RoleESPEnabled then
		local cached = ResolveRoleFromCache(char)
		if cached == "Murderer" then
			return Color3.fromRGB(255,60,60)
		elseif cached == "Sheriff" then
			return Color3.fromRGB(80,150,255)
		end

		local murderer = GetMurdererV1()
		local sheriff = GetSheriffV1()
		if char == murderer then
			return Color3.fromRGB(255,60,60)
		elseif char == sheriff then
			return Color3.fromRGB(80,150,255)
		end
	end
	return Color3.fromRGB(0,255,0)
end

-- CHAMS
local function ApplyChams(char,color)
	if not char then return end

	local existing = char:FindFirstChild("ChamsESP")
	if existing then
		existing.FillColor = color
		existing.OutlineColor = color
		return
	end

	local h = Instance.new("Highlight")
	h.Name = "ChamsESP"
	h.FillTransparency = 0.75
	h.OutlineTransparency = 0.25
	h.FillColor = color
	h.OutlineColor = color
	h.Parent = char
end

-- GUN ESP
local function CreateGunESP(gun)
	if not GunESPEnabled then return end
	if gun:FindFirstChild("GunESP") then return end

	local highlight = Instance.new("Highlight")
	highlight.Name = "GunESP"
	highlight.FillColor = Color3.fromRGB(170,120,255)
	highlight.FillTransparency = 0.7
	highlight.OutlineTransparency = 0.2
	highlight.Parent = gun

	local billboard = Instance.new("BillboardGui",gun)
	billboard.Name = "GunESP"
	billboard.Size = UDim2.new(0,120,0,20)
	billboard.StudsOffset = Vector3.new(0,2,0)
	billboard.AlwaysOnTop = true

	local text = Instance.new("TextLabel",billboard)
	text.Size = UDim2.new(1,0,1,0)
	text.BackgroundTransparency = 1
	text.Text = "Gun Dropped"
	text.TextColor3 = Color3.fromRGB(210,190,255)
	text.Font = Enum.Font.GothamBold
	text.TextScaled = true
	text.TextStrokeTransparency = 0
end

workspace.DescendantAdded:Connect(function(obj)
	if obj.Name == "GunDrop" and obj:IsA("BasePart") and GunESPEnabled then
		CreateGunESP(obj)
	end
end)

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "MM2Hub"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local main = Instance.new("Frame",gui)
main.Size = UDim2.new(0,560,0,320)
main.Position = UDim2.new(0.5,-280,0.5,-160)
main.BackgroundColor3 = Color3.fromRGB(18,18,20)
main.Active = true
main.Draggable = true
Instance.new("UICorner",main).CornerRadius = UDim.new(0,10)

-- TOP BAR
local titleBar = Instance.new("Frame",main)
titleBar.Size = UDim2.new(1,0,0,36)
titleBar.BackgroundColor3 = Color3.fromRGB(24,24,26)
Instance.new("UICorner",titleBar)

local minimizeBtn = Instance.new("TextButton",titleBar)
minimizeBtn.Size = UDim2.new(0,28,0,22)
minimizeBtn.Position = UDim2.new(0,8,0.5,-11)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(40,40,44)
minimizeBtn.TextColor3 = Color3.fromRGB(220,220,230)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 14
minimizeBtn.Text = "-"
Instance.new("UICorner",minimizeBtn).CornerRadius = UDim.new(0,6)

local title = Instance.new("TextLabel",titleBar)
title.Size = UDim2.new(1,-120,1,0)
title.Position = UDim2.new(0,44,0,0)
title.BackgroundTransparency = 1
title.Text = "MM2 Hub | Murder Mystery 2"
title.TextColor3 = Color3.fromRGB(220,220,230)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left

local subTitle = Instance.new("TextLabel",titleBar)
subTitle.Size = UDim2.new(0,140,1,0)
subTitle.Position = UDim2.new(1,-150,0,0)
subTitle.BackgroundTransparency = 1
subTitle.Text = "https://discord.gg/bdQCxfEfPX"
subTitle.TextColor3 = Color3.fromRGB(140,140,150)
subTitle.Font = Enum.Font.Gotham
subTitle.TextSize = 12
subTitle.TextXAlignment = Enum.TextXAlignment.Right

-- SIDEBAR
local sidebar = Instance.new("Frame",main)
sidebar.Size = UDim2.new(0,70,1,-36)
sidebar.Position = UDim2.new(0,0,0,36)
sidebar.BackgroundColor3 = Color3.fromRGB(21,21,23)
Instance.new("UICorner",sidebar).CornerRadius = UDim.new(0,10)

local topButtons = Instance.new("Frame",sidebar)
topButtons.Size = UDim2.new(1,0,1,-60)
topButtons.BackgroundTransparency = 1

local sideLayout = Instance.new("UIListLayout",topButtons)
sideLayout.FillDirection = Enum.FillDirection.Vertical
sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
sideLayout.Padding = UDim.new(0,8)

local sidePadding = Instance.new("UIPadding",topButtons)
sidePadding.PaddingTop = UDim.new(0,12)

local function SideButton(text,active,parent)
	local btn = Instance.new("TextButton",parent)
	btn.Size = UDim2.new(0,54,0,34)
	btn.BackgroundColor3 = active and Color3.fromRGB(40,40,44) or Color3.fromRGB(28,28,30)
	btn.TextColor3 = active and Color3.fromRGB(230,230,240) or Color3.fromRGB(150,150,160)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 12
	btn.Text = text
	Instance.new("UICorner",btn).CornerRadius = UDim.new(0,8)
	return btn
end

local espBtn = SideButton("ESP",true,topButtons)
local teleportBtn = SideButton("Teleport",false,topButtons)
local miscBtn = SideButton("Misc",false,topButtons)

local settingsBtn = Instance.new("TextButton",sidebar)
settingsBtn.Size = UDim2.new(0,54,0,34)
settingsBtn.Position = UDim2.new(0.5,-27,1,-44)
settingsBtn.BackgroundColor3 = Color3.fromRGB(28,28,30)
settingsBtn.TextColor3 = Color3.fromRGB(150,150,160)
settingsBtn.Font = Enum.Font.GothamBold
settingsBtn.TextSize = 14
settingsBtn.Text = "⚙"
Instance.new("UICorner",settingsBtn).CornerRadius = UDim.new(0,8)

-- CONTENT ROOT
local contentRoot = Instance.new("Frame",main)
contentRoot.Position = UDim2.new(0,80,0,46)
contentRoot.Size = UDim2.new(1,-90,1,-56)
contentRoot.BackgroundTransparency = 1

local sectionTitle = Instance.new("TextLabel",contentRoot)
sectionTitle.Size = UDim2.new(1,0,0,20)
sectionTitle.BackgroundTransparency = 1
sectionTitle.Text = "ESP"
sectionTitle.TextColor3 = Color3.fromRGB(220,220,230)
sectionTitle.Font = Enum.Font.GothamBold
sectionTitle.TextSize = 14
sectionTitle.TextXAlignment = Enum.TextXAlignment.Left

-- PAGES
local espPage = Instance.new("ScrollingFrame",contentRoot)
espPage.Position = UDim2.new(0,0,0,22)
espPage.Size = UDim2.new(1,0,1,-22)
espPage.BackgroundTransparency = 1
espPage.ScrollBarThickness = 4
espPage.CanvasSize = UDim2.new(0,0,0,0)
espPage.AutomaticCanvasSize = Enum.AutomaticSize.Y

local teleportPage = Instance.new("Frame",contentRoot)
teleportPage.Position = UDim2.new(0,0,0,22)
teleportPage.Size = UDim2.new(1,0,1,-22)
teleportPage.BackgroundTransparency = 1
teleportPage.Visible = false

local settingsPage = Instance.new("Frame",contentRoot)
settingsPage.Position = UDim2.new(0,0,0,22)
settingsPage.Size = UDim2.new(1,0,1,-22)
settingsPage.BackgroundTransparency = 1
settingsPage.Visible = false

local miscPage = Instance.new("Frame",contentRoot)
miscPage.Position = UDim2.new(0,0,0,22)
miscPage.Size = UDim2.new(1,0,1,-22)
miscPage.BackgroundTransparency = 1
miscPage.Visible = false

local function AddListLayout(parent)
	local list = Instance.new("UIListLayout",parent)
	list.FillDirection = Enum.FillDirection.Vertical
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Padding = UDim.new(0,8)

	local pad = Instance.new("UIPadding",parent)
	pad.PaddingTop = UDim.new(0,8)
end

AddListLayout(espPage)
AddListLayout(teleportPage)
AddListLayout(settingsPage)
AddListLayout(miscPage)

-- MINIMIZE LOGIC
local minimized = false
local function SetMinimized(state)
	minimized = state
	if minimized then
		contentRoot.Visible = false
		sidebar.Visible = false
		main.Size = UDim2.new(0,560,0,36)
		minimizeBtn.Text = "+"
	else
		contentRoot.Visible = true
		sidebar.Visible = true
		main.Size = UDim2.new(0,560,0,320)
		minimizeBtn.Text = "-"
	end
end

minimizeBtn.MouseButton1Click:Connect(function()
	SetMinimized(not minimized)
end)

-- TOGGLE ROW CREATOR
local function CreateRow(parent,titleText,descText,default,callback,isButton)
	local row = Instance.new("Frame",parent)
	row.Size = UDim2.new(1,0,0,48)
	row.BackgroundColor3 = Color3.fromRGB(28,28,32)
	Instance.new("UICorner",row).CornerRadius = UDim.new(0,8)

	local titleLbl = Instance.new("TextLabel",row)
	titleLbl.Size = UDim2.new(0.6,0,0,20)
	titleLbl.Position = UDim2.new(0,12,0,6)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = titleText
	titleLbl.TextColor3 = Color3.fromRGB(220,220,230)
	titleLbl.Font = Enum.Font.GothamBold
	titleLbl.TextSize = 13
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left

	local descLbl = Instance.new("TextLabel",row)
	descLbl.Size = UDim2.new(0.7,0,0,18)
	descLbl.Position = UDim2.new(0,12,0,24)
	descLbl.BackgroundTransparency = 1
	descLbl.Text = descText
	descLbl.TextColor3 = Color3.fromRGB(140,140,150)
	descLbl.Font = Enum.Font.Gotham
	descLbl.TextSize = 11
	descLbl.TextXAlignment = Enum.TextXAlignment.Left

	if isButton then
		local btn = Instance.new("TextButton",row)
		btn.Size = UDim2.new(0,120,0,24)
		btn.Position = UDim2.new(1,-132,0.5,-12)
		btn.BackgroundColor3 = Color3.fromRGB(40,40,44)
		btn.TextColor3 = Color3.fromRGB(220,220,230)
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 12
		btn.Text = tostring(HotkeyKey.Name)
		Instance.new("UICorner",btn).CornerRadius = UDim.new(0,6)
		btn.MouseButton1Click:Connect(function()
			WaitingForKey = true
			btn.Text = "Press key..."
		end)
		return btn
	end

	local toggle = Instance.new("Frame",row)
	toggle.Size = UDim2.new(0,40,0,20)
	toggle.Position = UDim2.new(1,-52,0.5,-10)
	toggle.BackgroundColor3 = default and Color3.fromRGB(70,130,90) or Color3.fromRGB(60,60,70)
	Instance.new("UICorner",toggle).CornerRadius = UDim.new(1,0)

	local knob = Instance.new("Frame",toggle)
	knob.Size = UDim2.new(0,18,0,18)
	knob.Position = default and UDim2.new(1,-19,0,1) or UDim2.new(0,1,0,1)
	knob.BackgroundColor3 = Color3.fromRGB(210,210,220)
	Instance.new("UICorner",knob).CornerRadius = UDim.new(1,0)

	local state = default
	row.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			state = not state
			if state then
				knob:TweenPosition(UDim2.new(1,-19,0,1),"Out","Quad",0.15,true)
				toggle.BackgroundColor3 = Color3.fromRGB(70,130,90)
			else
				knob:TweenPosition(UDim2.new(0,1,0,1),"Out","Quad",0.15,true)
				toggle.BackgroundColor3 = Color3.fromRGB(60,60,70)
			end
			callback(state)
		end
	end)

	return {
		set = function(v)
			state = v
			if state then
				knob:TweenPosition(UDim2.new(1,-19,0,1),"Out","Quad",0.15,true)
				toggle.BackgroundColor3 = Color3.fromRGB(70,130,90)
			else
				knob:TweenPosition(UDim2.new(0,1,0,1),"Out","Quad",0.15,true)
				toggle.BackgroundColor3 = Color3.fromRGB(60,60,70)
			end
		end
	}
end

local function CreateActionRow(parent,titleText,descText,buttonText,callback)
	local row = Instance.new("Frame",parent)
	row.Size = UDim2.new(1,0,0,48)
	row.BackgroundColor3 = Color3.fromRGB(28,28,32)
	Instance.new("UICorner",row).CornerRadius = UDim.new(0,8)

	local titleLbl = Instance.new("TextLabel",row)
	titleLbl.Size = UDim2.new(0.6,0,0,20)
	titleLbl.Position = UDim2.new(0,12,0,6)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = titleText
	titleLbl.TextColor3 = Color3.fromRGB(220,220,230)
	titleLbl.Font = Enum.Font.GothamBold
	titleLbl.TextSize = 13
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left

	local descLbl = Instance.new("TextLabel",row)
	descLbl.Size = UDim2.new(0.7,0,0,18)
	descLbl.Position = UDim2.new(0,12,0,24)
	descLbl.BackgroundTransparency = 1
	descLbl.Text = descText
	descLbl.TextColor3 = Color3.fromRGB(140,140,150)
	descLbl.Font = Enum.Font.Gotham
	descLbl.TextSize = 11
	descLbl.TextXAlignment = Enum.TextXAlignment.Left

	local btn = Instance.new("TextButton",row)
	btn.Size = UDim2.new(0,120,0,24)
	btn.Position = UDim2.new(1,-132,0.5,-12)
	btn.BackgroundColor3 = Color3.fromRGB(40,40,44)
	btn.TextColor3 = Color3.fromRGB(220,220,230)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 12
	btn.Text = buttonText
	Instance.new("UICorner",btn).CornerRadius = UDim.new(0,6)

	btn.MouseButton1Click:Connect(function()
		callback()
	end)
end

-- ESP PAGE ROWS
CreateRow(espPage,"Chams ESP","Highlight all players",ChamsESPEnabled,function(v)
	ChamsESPEnabled = v
	if not v then RemoveChamsESP() end
	SaveAllSettings()
end)

CreateRow(espPage,"Role Detection","Color murderer and sheriff",RoleESPEnabled,function(v)
	RoleESPEnabled = v
	SaveAllSettings()
end)

CreateRow(espPage,"Gun ESP","Highlight dropped gun",GunESPEnabled,function(v)
	GunESPEnabled = v
	if not v then RemoveGunESP() end
	SaveAllSettings()
end)

local xrayToggle = CreateRow(espPage,"Xray","See through walls (murderer-style)",XrayEnabled,function(v)
	XrayEnabled = v
	if XrayEnabled then EnableXray() else DisableXray() end
	SaveAllSettings()
end)

local xrayKeyButton = Instance.new("TextButton",espPage)
xrayKeyButton.Size = UDim2.new(1,0,0,40)
xrayKeyButton.BackgroundColor3 = Color3.fromRGB(28,28,32)
xrayKeyButton.TextColor3 = Color3.fromRGB(220,220,230)
xrayKeyButton.Font = Enum.Font.GothamBold
xrayKeyButton.TextSize = 12
xrayKeyButton.Text = "Xray Hotkey: "..tostring(XrayKey.Name)
Instance.new("UICorner",xrayKeyButton).CornerRadius = UDim.new(0,8)

xrayKeyButton.MouseButton1Click:Connect(function()
	WaitingForXrayKey = true
	xrayKeyButton.Text = "Press key..."
end)

-- TELEPORT PAGE
CreateActionRow(teleportPage,"Grab Gun","Teleport to dropped gun briefly","Grab Gun",function()
	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local gun = workspace:FindFirstChild("GunDrop", true)
	if not gun then return end

	local originalCFrame = hrp.CFrame
	local target = gun:IsA("BasePart") and gun or gun:FindFirstChildWhichIsA("BasePart")
	if not target then return end

	hrp.CFrame = target.CFrame + Vector3.new(0,2,0)
	task.wait(0.15)
	hrp.CFrame = originalCFrame
end)

-- SETTINGS PAGE ROWS
local hotkeyButton = CreateRow(settingsPage,"GUI Hotkey","Select key to show/hide GUI",false,function() end,true)

-- MISC PAGE ROWS
CreateActionRow(miscPage,"Rejoin Server","Reconnect to the current server","Rejoin",function()
	TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

-- PAGE SWITCHING
local function SetPage(name)
	espPage.Visible = false
	teleportPage.Visible = false
	settingsPage.Visible = false
	miscPage.Visible = false

	espBtn.BackgroundColor3 = Color3.fromRGB(28,28,30)
	espBtn.TextColor3 = Color3.fromRGB(150,150,160)
	teleportBtn.BackgroundColor3 = Color3.fromRGB(28,28,30)
	teleportBtn.TextColor3 = Color3.fromRGB(150,150,160)
	miscBtn.BackgroundColor3 = Color3.fromRGB(28,28,30)
	miscBtn.TextColor3 = Color3.fromRGB(150,150,160)
	settingsBtn.BackgroundColor3 = Color3.fromRGB(28,28,30)
	settingsBtn.TextColor3 = Color3.fromRGB(150,150,160)

	if name == "ESP" then
		sectionTitle.Text = "ESP"
		espPage.Visible = true
		espBtn.BackgroundColor3 = Color3.fromRGB(40,40,44)
		espBtn.TextColor3 = Color3.fromRGB(230,230,240)
	elseif name == "Teleport" then
		sectionTitle.Text = "Teleport"
		teleportPage.Visible = true
		teleportBtn.BackgroundColor3 = Color3.fromRGB(40,40,44)
		teleportBtn.TextColor3 = Color3.fromRGB(230,230,240)
	elseif name == "Settings" then
		sectionTitle.Text = "Settings"
		settingsPage.Visible = true
		settingsBtn.BackgroundColor3 = Color3.fromRGB(40,40,44)
		settingsBtn.TextColor3 = Color3.fromRGB(230,230,240)
	else
		sectionTitle.Text = "Misc"
		miscPage.Visible = true
		miscBtn.BackgroundColor3 = Color3.fromRGB(40,40,44)
		miscBtn.TextColor3 = Color3.fromRGB(230,230,240)
	end
end

espBtn.MouseButton1Click:Connect(function() SetPage("ESP") end)
teleportBtn.MouseButton1Click:Connect(function() SetPage("Teleport") end)
settingsBtn.MouseButton1Click:Connect(function() SetPage("Settings") end)
miscBtn.MouseButton1Click:Connect(function() SetPage("Misc") end)

-- HOTKEYS
UIS.InputBegan:Connect(function(i,gp)
	if gp then return end

	if WaitingForKey then
		if i.UserInputType == Enum.UserInputType.Keyboard then
			HotkeyKey = i.KeyCode
			hotkeyButton.Text = tostring(HotkeyKey.Name)
			WaitingForKey = false
			SaveAllSettings()
		end
		return
	end

	if WaitingForXrayKey then
		if i.UserInputType == Enum.UserInputType.Keyboard then
			XrayKey = i.KeyCode
			xrayKeyButton.Text = "Xray Hotkey: "..tostring(XrayKey.Name)
			WaitingForXrayKey = false
			SaveAllSettings()
		end
		return
	end

	if i.KeyCode == HotkeyKey then
		main.Visible = not main.Visible
	end

	if i.KeyCode == XrayKey then
		XrayEnabled = not XrayEnabled
		xrayToggle.set(XrayEnabled)
		if XrayEnabled then EnableXray() else DisableXray() end
		SaveAllSettings()
	end
end)

-- PLAYER ESP LOOP
task.spawn(function()
	while task.wait(0.4) do
		if not ChamsESPEnabled then continue end
		for _,player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character then
				local color = GetRoleColor(player.Character)
				ApplyChams(player.Character,color)
			end
		end
	end
end)

if XrayEnabled then
	EnableXray()
end
