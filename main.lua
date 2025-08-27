--// Script show FPS + CPU + RAM + Ping //--
--// Made by ChatGPT for Đào Nguyễn Minh Triết :) //--

local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StatsUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- === CONFIG ===
local logoURL = "https://raw.githubusercontent.com/Bieoidungbuonnua/show-boost/main/tquyencute.png"

-- === Tạo Logo Toggle ===
local logoButton = Instance.new("ImageButton")
logoButton.Name = "LogoButton"
logoButton.Size = UDim2.new(0, 50, 0, 50)
logoButton.Position = UDim2.new(1, -60, 0, 10) -- Góc trên bên phải
logoButton.AnchorPoint = Vector2.new(0, 0)
logoButton.BackgroundTransparency = 1
logoButton.Image = logoURL
logoButton.Parent = screenGui

-- Bo tròn logo
local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(1, 0)
logoCorner.Parent = logoButton

-- === Bảng Stats ===
local statsFrame = Instance.new("Frame")
statsFrame.Name = "StatsFrame"
statsFrame.Size = UDim2.new(0, 280, 0, 90)
statsFrame.Position = UDim2.new(0.65, 0, 0.75, 0) -- Vị trí gần giống hình
statsFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
statsFrame.BorderSizePixel = 0
statsFrame.Visible = true
statsFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = statsFrame

-- === Text hiển thị ===
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(1, -10, 0, 20)
fpsLabel.Position = UDim2.new(0, 5, 0, 5)
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
fpsLabel.TextSize = 18
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Parent = statsFrame

local pingLabel = fpsLabel:Clone()
pingLabel.Position = UDim2.new(0, 5, 0, 28)
pingLabel.TextColor3 = Color3.fromRGB(0, 180, 255)
pingLabel.Parent = statsFrame

local cpuLabel = fpsLabel:Clone()
cpuLabel.Position = UDim2.new(0, 5, 0, 51)
cpuLabel.TextColor3 = Color3.fromRGB(255, 170, 0)
cpuLabel.Parent = statsFrame

local ramLabel = fpsLabel:Clone()
ramLabel.Position = UDim2.new(0, 5, 0, 74)
ramLabel.TextColor3 = Color3.fromRGB(255, 105, 180)
ramLabel.Parent = statsFrame

-- === Toggle bảng khi click logo ===
local isVisible = true
logoButton.MouseButton1Click:Connect(function()
	isVisible = not isVisible
	statsFrame.Visible = isVisible
end)

-- === Cập nhật FPS, Ping, CPU, RAM realtime ===
local lastTick = tick()
local frames = 0

RunService.RenderStepped:Connect(function()
	frames = frames + 1
	local now = tick()
	if now - lastTick >= 1 then
		fpsLabel.Text = string.format("⚡ FPS: %d", frames)
		frames = 0
		lastTick = now
	end

	-- Ping từ Roblox stats
	local pingValue = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
	pingLabel.Text = string.format("📡 PING: %d ms", math.floor(pingValue))

	-- CPU & RAM
	local memory = collectgarbage("count") / 1024 -- MB
	local cpuUsage = Stats.Workspace["CpuTime"]:GetValue() or 0
	cpuLabel.Text = string.format("🖥️ CPU: %.1f%%", cpuUsage)
	ramLabel.Text = string.format("💾 RAM: %.1f MB", memory)
end)
