--// Dịch vụ cần thiết
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

--// Tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SystemStatsUI"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

--// Nút bật/tắt UI
local toggleButton = Instance.new("ImageButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 45, 0, 45)
toggleButton.Position = UDim2.new(1, -60, 0, 10)
toggleButton.BackgroundTransparency = 1
toggleButton.Image = "rbxassetid://95299420830927" -- Logo của bạn
toggleButton.Parent = screenGui

--// Khung hiển thị thông tin
local statsFrame = Instance.new("Frame")
statsFrame.Name = "StatsFrame"
statsFrame.Size = UDim2.new(0, 180, 0, 120)
statsFrame.Position = UDim2.new(1, -190, 0, 10)
statsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
statsFrame.BorderSizePixel = 0
statsFrame.Visible = true
statsFrame.Parent = screenGui

--// Bo góc khung
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = statsFrame

--// Tiêu đề
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 25)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "📊 Hệ thống"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = statsFrame

--// FPS
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(1, -10, 0, 25)
fpsLabel.Position = UDim2.new(0, 5, 0, 30)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: 0"
fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 14
fpsLabel.Parent = statsFrame

--// Ping
local pingLabel = Instance.new("TextLabel")
pingLabel.Size = UDim2.new(1, -10, 0, 25)
pingLabel.Position = UDim2.new(0, 5, 0, 55)
pingLabel.BackgroundTransparency = 1
pingLabel.Text = "Ping: 0ms"
pingLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
pingLabel.TextXAlignment = Enum.TextXAlignment.Left
pingLabel.Font = Enum.Font.GothamBold
pingLabel.TextSize = 14
pingLabel.Parent = statsFrame

--// CPU
local cpuLabel = Instance.new("TextLabel")
cpuLabel.Size = UDim2.new(1, -10, 0, 25)
cpuLabel.Position = UDim2.new(0, 5, 0, 80)
cpuLabel.BackgroundTransparency = 1
cpuLabel.Text = "CPU: 0%"
cpuLabel.TextColor3 = Color3.fromRGB(0, 191, 255)
cpuLabel.TextXAlignment = Enum.TextXAlignment.Left
cpuLabel.Font = Enum.Font.GothamBold
cpuLabel.TextSize = 14
cpuLabel.Parent = statsFrame

--// RAM
local ramLabel = Instance.new("TextLabel")
ramLabel.Size = UDim2.new(1, -10, 0, 25)
ramLabel.Position = UDim2.new(0, 5, 0, 105)
ramLabel.BackgroundTransparency = 1
ramLabel.Text = "RAM: 0MB"
ramLabel.TextColor3 = Color3.fromRGB(255, 99, 71)
ramLabel.TextXAlignment = Enum.TextXAlignment.Left
ramLabel.Font = Enum.Font.GothamBold
ramLabel.TextSize = 14
ramLabel.Parent = statsFrame

--// Hàm cập nhật số liệu
local frameCounter, lastUpdate = 0, tick()
RunService.RenderStepped:Connect(function()
	frameCounter += 1
	local now = tick()
	if now - lastUpdate >= 1 then
		-- FPS
		fpsLabel.Text = "FPS: " .. tostring(frameCounter)
		frameCounter = 0
		lastUpdate = now

		-- Ping
		local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		pingLabel.Text = "Ping: " .. math.floor(ping) .. "ms"

		-- CPU
		local cpuUsage = Stats.Workspace:GetTotalMemoryUsageMb() / 8192 * 100 -- Tính gần đúng %
		cpuLabel.Text = string.format("CPU: %.1f%%", cpuUsage)

		-- RAM
		local ramUsage = Stats.Workspace:GetTotalMemoryUsageMb()
		ramLabel.Text = string.format("RAM: %.1fMB", ramUsage)
	end
end)

--// Chức năng bật/tắt bảng thống kê
local visible = true
toggleButton.MouseButton1Click:Connect(function()
	visible = not visible
	statsFrame.Visible = visible
end)
