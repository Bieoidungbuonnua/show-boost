-- LocalScript: PerformanceUI_withToggle
-- Put this LocalScript into StarterPlayer -> StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ====== Config ======
local GITHUB_RAW_LOGO = "https://raw.githubusercontent.com/Bieoidungbuonnua/show-boost/main/tquyencute.png"
local UI_WIDTH = 460
local UI_HEIGHT = 96
local UPDATE_INTERVAL = 0.5

-- ====== ScreenGui ======
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PerformanceUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ====== Toggle Button (circular logo) - right side ======
local toggleBtn = Instance.new("ImageButton")
toggleBtn.Name = "PerfToggleBtn"
toggleBtn.Parent = screenGui
toggleBtn.Size = UDim2.new(0, 64, 0, 64)
toggleBtn.AnchorPoint = Vector2.new(1, 0.5)
toggleBtn.Position = UDim2.new(1, -16, 0.5, 0) -- middle-right
toggleBtn.BackgroundTransparency = 1
toggleBtn.Image = GITHUB_RAW_LOGO
toggleBtn.ScaleType = Enum.ScaleType.Fit
toggleBtn.ZIndex = 60
toggleBtn.ImageTransparency = 0

-- subtle shadow behind the button
local btnShadow = Instance.new("Frame")
btnShadow.Name = "BtnShadow"
btnShadow.Parent = screenGui
btnShadow.Size = UDim2.new(0, 84, 0, 84)
btnShadow.AnchorPoint = Vector2.new(1, 0.5)
btnShadow.Position = UDim2.new(1, -12, 0.5, 4)
btnShadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
btnShadow.BackgroundTransparency = 0.6
btnShadow.ZIndex = 55
btnShadow.BorderSizePixel = 0
local sCorner = Instance.new("UICorner", btnShadow); sCorner.CornerRadius = UDim.new(1,0)

-- ====== Main Frame (left of toggle, floating) ======
local frame = Instance.new("Frame")
frame.Name = "PerfFrame"
frame.Parent = screenGui
frame.Size = UDim2.new(0, UI_WIDTH, 0, UI_HEIGHT)
frame.AnchorPoint = Vector2.new(1, 0.5)
frame.Position = UDim2.new(1, -96, 0.5, 0) -- slightly left of toggle
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
frame.BorderSizePixel = 0
frame.ZIndex = 58
frame.ClipsDescendants = true

local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, 12)

-- glow stroke
local frameStroke = Instance.new("UIStroke", frame)
frameStroke.Thickness = 2
frameStroke.Color = Color3.fromRGB(40, 200, 255)
frameStroke.Transparency = 0.25

-- soft inner gradient
local bgGradient = Instance.new("UIGradient", frame)
bgGradient.Rotation = 0
bgGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(25,25,28)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(16,16,18))
}
bgGradient.Transparency = NumberSequence.new(0.0)

-- small left icon (lightning)
local icon = Instance.new("TextLabel", frame)
icon.Name = "Icon"
icon.Size = UDim2.new(0, 28, 0, 28)
icon.Position = UDim2.new(0, 10, 0, 10)
icon.BackgroundTransparency = 1
icon.Text = "⚡"
icon.Font = Enum.Font.SourceSansBold
icon.TextScaled = true
icon.TextColor3 = Color3.fromRGB(255, 210, 60)
icon.ZIndex = 59

-- Title
local title = Instance.new("TextLabel", frame)
title.Name = "Title"
title.Size = UDim2.new(0, 260, 0, 22)
title.Position = UDim2.new(0, 48, 0, 8)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBlack
title.TextSize = 14
title.Text = "Script show fps · CPU · RAM · PING"
title.TextColor3 = Color3.fromRGB(150, 210, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 59

-- small right credit
local credit = Instance.new("TextLabel", frame)
credit.Name = "Credit"
credit.Size = UDim2.new(0, 150, 0, 22)
credit.Position = UDim2.new(1, -156, 0, 8)
credit.BackgroundTransparency = 1
credit.Font = Enum.Font.Gotham
credit.TextSize = 10
credit.Text = "Script show fps\nCpu Ram By ChatGPT"
credit.TextColor3 = Color3.fromRGB(200,200,200)
credit.TextXAlignment = Enum.TextXAlignment.Right
credit.TextYAlignment = Enum.TextYAlignment.Top
credit.ZIndex = 59

-- Info label (main lines)
local infoLabel = Instance.new("TextLabel", frame)
infoLabel.Name = "Info"
infoLabel.Size = UDim2.new(1, -20, 1, -36)
infoLabel.Position = UDim2.new(0, 10, 0, 30)
infoLabel.BackgroundTransparency = 1
infoLabel.Font = Enum.Font.GothamSemibold
infoLabel.TextSize = 14
infoLabel.Text = "Đang tải..."
infoLabel.RichText = true
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.TextColor3 = Color3.fromRGB(240,240,240)
infoLabel.ZIndex = 59

-- Small progress bars container
local barsContainer = Instance.new("Frame", frame)
barsContainer.Name = "Bars"
barsContainer.Size = UDim2.new(0.5, -16, 0, 18)
barsContainer.Position = UDim2.new(0, 10, 1, -24)
barsContainer.BackgroundTransparency = 1
barsContainer.ZIndex = 59

-- CPU Bar (background)
local cpuBg = Instance.new("Frame", barsContainer)
cpuBg.Name = "CpuBg"
cpuBg.Size = UDim2.new(1, 0, 0, 6)
cpuBg.Position = UDim2.new(0,0,0,0)
cpuBg.BackgroundColor3 = Color3.fromRGB(40,40,44)
cpuBg.BorderSizePixel = 0
local cpuCorner = Instance.new("UICorner", cpuBg); cpuCorner.CornerRadius = UDim.new(0,4)

local cpuBar = Instance.new("Frame", cpuBg)
cpuBar.Name = "CpuBar"
cpuBar.Size = UDim2.new(0, 0, 1, 0)
cpuBar.BackgroundColor3 = Color3.fromRGB(0,200,255)
local cpuBarCorner = Instance.new("UICorner", cpuBar); cpuBarCorner.CornerRadius = UDim.new(0,4)

-- RAM Bar
local ramBg = cpuBg:Clone()
ramBg.Parent = barsContainer
ramBg.Name = "RamBg"
ramBg.Position = UDim2.new(0,0,0,8)

local ramBar = ramBg:FindFirstChildWhichIsA("Frame")
ramBar.Name = "RamBar"
ramBar.Parent = ramBg
ramBar.Size = UDim2.new(0,0,1,0)
ramBar.BackgroundColor3 = Color3.fromRGB(255,170,60)
local ramBarCorner = ramBar:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", ramBar); ramBarCorner.CornerRadius = UDim.new(0,4)

-- ====== Utility functions ======
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
	-- CPU may be available via Frame Rate Manager's CpuTime; Memory via Stats API
	local cpuPercent = 0
	local memMB = 0
	-- try cpu
	pcall(function()
		local frm = Stats:FindFirstChild("Workspace") and Stats.Workspace:FindFirstChild("Frame Rate Manager")
		if frm and frm:FindFirstChild("CpuTime") then
			local v = frm.CpuTime:GetValue()
			if type(v) == "number" then
				cpuPercent = math.clamp(v * 100, 0, 100)
			end
		end
	end)
	-- try memory
	pcall(function()
		local m = Stats:GetTotalMemoryUsageMb()
		if type(m) == "number" then
			memMB = m
		end
	end)
	return cpuPercent, memMB
end

-- rainbow color helper for text
local rainbowT = 0
local function stepRainbow(dt)
	rainbowT = rainbowT + dt * 0.8
	local r = (math.sin(rainbowT) + 1) * 0.5
	local g = (math.sin(rainbowT + 2.0) + 1) * 0.5
	local b = (math.sin(rainbowT + 4.0) + 1) * 0.5
	return Color3.new(r,g,b)
end

-- ====== Update loop ======
spawn(function()
	while true do
		local pingVal = safeGetPing()
		local cpuPercent, memMB = safeGetCpuMem()

		local pingText = (pingVal and tostring(pingVal) .. " ms") or "N/A"
		local cpuText = string.format("%.1f%%", cpuPercent)
		local ramText = string.format("%.1f MB", memMB)

		-- update main text
		local color = stepRainbow(UPDATE_INTERVAL)
		infoLabel.TextColor3 = color
		title.TextColor3 = Color3.new(1 - color.R, 1 - color.G, 1 - color.B)

		infoLabel.Text = string.format(
			"🎮 FPS: <b>%d</b>    |    📡 PING: <b>%s</b>\n🧠 CPU: <b>%s</b>    |    💾 RAM: <b>%s</b>",
			fps, pingText, cpuText, ramText
		)

		-- update bars (CPU uses percent, RAM scaled to some max for visualization)
		local cpuPercentClamped = math.clamp(cpuPercent / 100, 0, 1)
		local ramPct = 0
		if memMB > 0 then
			-- choose an arbitrary max memory to map visually (e.g., 8192 MB)
			ramPct = math.clamp(memMB / 8192, 0, 1)
		end

		-- tween bars for smoothness
		local cpuTarget = UDim2.new(cpuPercentClamped, 0, 1, 0)
		local ramTarget = UDim2.new(ramPct, 0, 1, 0)
		TweenService:Create(cpuBar, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = cpuTarget}):Play()
		TweenService:Create(ramBar, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = ramTarget}):Play()

		task.wait(UPDATE_INTERVAL)
	end
end)

-- ====== Toggle behavior (show/hide frame) ======
local visible = true
local showPos = UDim2.new(1, -96, 0.5, 0) -- default (frame near button)
local hidePos = UDim2.new(1, UI_WIDTH * 1.2, 0.5, 0) -- pushed off-screen to right

frame.Position = showPos

toggleBtn.MouseButton1Click:Connect(function()
	visible = not visible
	local target = visible and showPos or hidePos
	TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = target}):Play()
	-- small feedback on the button
	local imgT = visible and 0 or 0.45
	TweenService:Create(toggleBtn, TweenInfo.new(0.18), {ImageTransparency = imgT}):Play()
end)

-- Optional: click+drag to reposition button (hold and drag)
local dragging = false
local dragOffset = Vector2.new(0,0)
toggleBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		local mouse = player:GetMouse()
		dragOffset = Vector2.new(toggleBtn.AbsolutePosition.X - mouse.X, toggleBtn.AbsolutePosition.Y - mouse.Y)
	end
end)
toggleBtn.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
RunService.RenderStepped:Connect(function()
	if dragging then
		local mouse = player:GetMouse()
		local newX = mouse.X + dragOffset.X
		local newY = mouse.Y + dragOffset.Y
		-- clamp to viewport
		local v2 = workspace.CurrentCamera.ViewportSize
		newX = math.clamp(newX, 8, v2.X - 8)
		newY = math.clamp(newY, 8, v2.Y - 8)
		toggleBtn.Position = UDim2.new(0, newX, 0, newY)
		btnShadow.Position = UDim2.new(0, newX+10, 0, newY+4)
		-- update frame anchor to stay near button (simple behavior: keep frame at fixed offset from right)
		-- (we keep the original frame showPos for consistent animation)
	end
end)

-- Done.
