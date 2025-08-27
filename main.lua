-- LocalScript: StatsTopCenter_WithLogoToggle
-- Put this LocalScript into StarterPlayer -> StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ===== CONFIG (chỉnh ở đây nếu cần) =====
local GITHUB_RAW_LOGO = "https://raw.githubusercontent.com/Bieoidungbuonnua/show-boost/main/tquyencute.png"
local UI_WIDTH = 640          -- chiều ngang bảng
local UI_HEIGHT = 100         -- chiều cao bảng
local UI_TOP_OFFSET = 48      -- khoảng cách (px) từ mép trên của cửa sổ đến bảng (đặt sao cho nằm dưới thanh trên trong ảnh)
local UPDATE_INTERVAL = 0.5   -- giây giữa các lần cập nhật dữ liệu

-- ===== Create ScreenGui =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TopStatsUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ===== Logo (circular) ở góc trên phải =====
local logoBtn = Instance.new("ImageButton")
logoBtn.Name = "LogoToggle"
logoBtn.Parent = screenGui
logoBtn.Size = UDim2.new(0, 56, 0, 56)
logoBtn.AnchorPoint = Vector2.new(1, 0) -- neo theo góc phải trên
logoBtn.Position = UDim2.new(1, -12, 0, 8) -- góc trên phải, chỉnh margin bằng offset
logoBtn.BackgroundTransparency = 1
logoBtn.Image = GITHUB_RAW_LOGO
logoBtn.ScaleType = Enum.ScaleType.Fit
logoBtn.ZIndex = 99

local logoCorner = Instance.new("UICorner", logoBtn)
logoCorner.CornerRadius = UDim.new(1, 0)

-- subtle shadow behind logo (for visibility)
local logoShadow = Instance.new("Frame")
logoShadow.Name = "LogoShadow"
logoShadow.Parent = screenGui
logoShadow.Size = UDim2.new(0, 72, 0, 72)
logoShadow.AnchorPoint = Vector2.new(1, 0)
logoShadow.Position = UDim2.new(1, -6, 0, 6)
logoShadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
logoShadow.BackgroundTransparency = 0.6
logoShadow.BorderSizePixel = 0
logoShadow.ZIndex = 90
local sCorner = Instance.new("UICorner", logoShadow)
sCorner.CornerRadius = UDim.new(1,0)

-- ===== Main frame (top-center) =====
local mainFrame = Instance.new("Frame")
mainFrame.Name = "StatsFrame"
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, UI_WIDTH, 0, UI_HEIGHT)
mainFrame.AnchorPoint = Vector2.new(0.5, 0) -- neo theo top-center
mainFrame.Position = UDim2.new(0.5, 0, 0, UI_TOP_OFFSET) -- top-center, offset từ trên
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
mainFrame.BorderSizePixel = 0
mainFrame.ZIndex = 95
mainFrame.ClipsDescendants = true

local frameCorner = Instance.new("UICorner", mainFrame)
frameCorner.CornerRadius = UDim.new(0, 12)

local frameStroke = Instance.new("UIStroke", mainFrame)
frameStroke.Thickness = 2
frameStroke.Color = Color3.fromRGB(50, 200, 255)
frameStroke.Transparency = 0.22

-- subtle gradient
local g = Instance.new("UIGradient", mainFrame)
g.Rotation = 0
g.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(26,26,30)), ColorSequenceKeypoint.new(1, Color3.fromRGB(16,16,18))})

-- ===== Contents: title + info =====
local title = Instance.new("TextLabel", mainFrame)
title.Name = "Title"
title.Size = UDim2.new(0.6, -12, 0, 26)
title.Position = UDim2.new(0, 12, 0, 8)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBlack
title.TextSize = 14
title.Text = "⚡ Script show fps · CPU · RAM · PING"
title.TextColor3 = Color3.fromRGB(170, 220, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 96

local credit = Instance.new("TextLabel", mainFrame)
credit.Name = "Credit"
credit.Size = UDim2.new(0.3, -12, 0, 24)
credit.Position = UDim2.new(1, - (UI_WIDTH*0.3 + 18), 0, 8)
credit.BackgroundTransparency = 1
credit.Font = Enum.Font.Gotham
credit.TextSize = 10
credit.Text = "Script show fps\nCpu Ram By ChatGPT"
credit.TextColor3 = Color3.fromRGB(200,200,200)
credit.TextXAlignment = Enum.TextXAlignment.Right
credit.TextYAlignment = Enum.TextYAlignment.Top
credit.ZIndex = 96

local infoLabel = Instance.new("TextLabel", mainFrame)
infoLabel.Name = "Info"
infoLabel.Size = UDim2.new(1, -24, 1, -44)
infoLabel.Position = UDim2.new(0, 12, 0, 36)
infoLabel.BackgroundTransparency = 1
infoLabel.Font = Enum.Font.GothamSemibold
infoLabel.TextSize = 15
infoLabel.RichText = true
infoLabel.TextColor3 = Color3.fromRGB(240,240,240)
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.Text = "Đang tải..."
infoLabel.ZIndex = 96

-- small progress bars area (right side)
local barsFrame = Instance.new("Frame", mainFrame)
barsFrame.Name = "Bars"
barsFrame.Size = UDim2.new(0.32, 0, 0, 18)
barsFrame.Position = UDim2.new(1, - (UI_WIDTH*0.32) - 12, 1, -26)
barsFrame.BackgroundTransparency = 1
barsFrame.ZIndex = 96

local cpuLabel = Instance.new("TextLabel", barsFrame)
cpuLabel.Size = UDim2.new(1, 0, 0, 10)
cpuLabel.Position = UDim2.new(0, 0, 0, 0)
cpuLabel.BackgroundTransparency = 1
cpuLabel.Font = Enum.Font.Gotham
cpuLabel.TextSize = 11
cpuLabel.Text = "CPU"
cpuLabel.TextColor3 = Color3.fromRGB(200,200,200)
cpuLabel.TextXAlignment = Enum.TextXAlignment.Left

local cpuBg = Instance.new("Frame", barsFrame)
cpuBg.Size = UDim2.new(1, 0, 0, 6)
cpuBg.Position = UDim2.new(0, 0, 0, 10)
cpuBg.BackgroundColor3 = Color3.fromRGB(35,35,38)
cpuBg.BorderSizePixel = 0
local cpuCorner = Instance.new("UICorner", cpuBg); cpuCorner.CornerRadius = UDim.new(0,4)
local cpuBar = Instance.new("Frame", cpuBg)
cpuBar.Name = "CpuBar"
cpuBar.Size = UDim2.new(0,0,1,0)
cpuBar.BackgroundColor3 = Color3.fromRGB(0,200,255)
local cpuBarCorner = Instance.new("UICorner", cpuBar); cpuBarCorner.CornerRadius = UDim.new(0,4)

local ramLabelT = cpuLabel:Clone()
ramLabelT.Parent = barsFrame
ramLabelT.Position = UDim2.new(0,0,0,28)
ramLabelT.Text = "RAM"
local ramBg = cpuBg:Clone()
ramBg.Parent = barsFrame
ramBg.Position = UDim2.new(0,0,0,38)
local ramBar = ramBg:FindFirstChildOfClass("Frame")
ramBar.Name = "RamBar"
ramBar.Size = UDim2.new(0,0,1,0)
ramBar.BackgroundColor3 = Color3.fromRGB(255,170,60)
local ramBarCorner = ramBar:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", ramBar); ramBarCorner.CornerRadius = UDim.new(0,4)

-- ===== Utility: FPS / safe ping / safe cpu/mem =====
local fps = 0
do
	local frames = 0
	local last = tick()
	RunService.RenderStepped:Connect(function()
		frames = frames + 1
		local now = tick()
		if now - last >= 1 then
			fps = frames
			frames = 0
			last = now
		end
	end)
end

local function safeGetPing()
	local ok, stat = pcall(function()
		return Stats.Network.ServerStatsItem["Data Ping"]
	end)
	if ok and stat then
		local ok2, v = pcall(function() return stat:GetValue() end)
		if ok2 and type(v) == "number" then
			return math.floor(v)
		end
	end
	return nil
end

local function safeGetCpuMem()
	local cpuPercent = 0
	local memMB = 0
	-- CPU: try Frame Rate Manager path
	pcall(function()
		local frm = Stats:FindFirstChild("Workspace") and Stats.Workspace:FindFirstChild("Frame Rate Manager")
		if frm and frm:FindFirstChild("CpuTime") then
			local v = frm.CpuTime:GetValue()
			if type(v) == "number" then
				cpuPercent = math.clamp(v * 100, 0, 100)
			end
		end
	end)
	-- Memory: Stats API
	pcall(function()
		local m = Stats:GetTotalMemoryUsageMb()
		if type(m) == "number" then
			memMB = m
		end
	end)
	return cpuPercent, memMB
end

-- rainbow color helper
local rainbowT = 0
local function stepRainbow(dt)
	rainbowT = rainbowT + dt * 0.9
	local r = (math.sin(rainbowT) + 1) * 0.5
	local g = (math.sin(rainbowT + 2.0) + 1) * 0.5
	local b = (math.sin(rainbowT + 4.0) + 1) * 0.5
	return Color3.new(r,g,b)
end

-- ===== Update loop =====
spawn(function()
	while true do
		local pingVal = safeGetPing()
		local cpuPercent, memMB = safeGetCpuMem()

		local pingText = (pingVal and tostring(pingVal) .. " ms") or "N/A"
		local cpuText = string.format("%.1f%%", cpuPercent)
		local ramText = string.format("%.1f MB", memMB)

		-- rainbow color
		local col = stepRainbow(UPDATE_INTERVAL)
		title.TextColor3 = Color3.new(1 - col.R, 1 - col.G, 1 - col.B)
		infoLabel.TextColor3 = col

		infoLabel.Text = string.format("🎮 FPS: <b>%d</b>    |    📡 PING: <b>%s</b>\n🧠 CPU: <b>%s</b>    |    💾 RAM: <b>%s</b>",
			fps, pingText, cpuText, ramText)

		-- update bars visually
		local cpuPct = math.clamp(cpuPercent / 100, 0, 1)
		local ramPct = 0
		if memMB > 0 then
			-- map memory visually (assume 8GB = 8192MB)
			ramPct = math.clamp(memMB / 8192, 0, 1)
		end

		TweenService:Create(cpuBar, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(cpuPct, 0, 1, 0)}):Play()
		TweenService:Create(ramBar, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(ramPct, 0, 1, 0)}):Play()

		task.wait(UPDATE_INTERVAL)
	end
end)

-- ===== Toggle behavior: slide up to hide, slide down to show =====
local visible = true
local showPos = UDim2.new(0.5, 0, 0, UI_TOP_OFFSET)
local hidePos = UDim2.new(0.5, 0, 0, - (UI_HEIGHT + 16)) -- trượt lên trên để ẩn

mainFrame.Position = showPos

logoBtn.MouseButton1Click:Connect(function()
	visible = not visible
	local target = visible and showPos or hidePos
	TweenService:Create(mainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = target}):Play()
	-- feedback logo
	local t = TweenService:Create(logoBtn, TweenInfo.new(0.18), {ImageTransparency = visible and 0 or 0.5})
	t:Play()
end)

-- Optional: allow drag of logo (hold & drag) so user can move it
local dragging = false
local dragOffset = Vector2.new(0,0)
logoBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		local m = player:GetMouse()
		dragOffset = Vector2.new(logoBtn.AbsolutePosition.X - m.X, logoBtn.AbsolutePosition.Y - m.Y)
	end
end)
logoBtn.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
RunService.RenderStepped:Connect(function()
	if dragging then
		local m = player:GetMouse()
		local newX = m.X + dragOffset.X
		local newY = m.Y + dragOffset.Y
		-- clamp inside viewport
		local v = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920,1080)
		newX = math.clamp(newX, 8, v.X - 8)
		newY = math.clamp(newY, 8, v.Y - 8)
		logoBtn.Position = UDim2.new(0, newX, 0, newY)
		logoShadow.Position = UDim2.new(0, newX - 6, 0, newY - 2)
	end
end)

-- DONE
