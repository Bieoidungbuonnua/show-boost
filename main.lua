-- // Roblox Performance Monitor UI (Pro Version)
-- // By ChatGPT

-- Dịch vụ Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local GuiService = game:GetService("GuiService")

-- Người chơi hiện tại
local player = Players.LocalPlayer

-- Tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PerfMonitorUI"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- ID logo bạn yêu cầu
local LOGO_ID = "rbxassetid://95299420830927"

-- Frame chính (căn giữa)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "StatsFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 180)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Đổ bóng cho frame
local uiCorner = Instance.new("UICorner", mainFrame)
uiCorner.CornerRadius = UDim.new(0, 15)

local uiStroke = Instance.new("UIStroke", mainFrame)
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(0, 255, 150)

-- Tiêu đề
local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = mainFrame
titleLabel.Text = "⚡ HIỆU SUẤT HỆ THỐNG ⚡"
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold

-- Các thông số
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Parent = mainFrame
fpsLabel.Position = UDim2.new(0, 10, 0, 50)
fpsLabel.Size = UDim2.new(1, -20, 0, 25)
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsLabel.TextScaled = true
fpsLabel.Font = Enum.Font.GothamMedium
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left

local pingLabel = fpsLabel:Clone()
pingLabel.Parent = mainFrame
pingLabel.Position = UDim2.new(0, 10, 0, 80)

local cpuLabel = fpsLabel:Clone()
cpuLabel.Parent = mainFrame
cpuLabel.Position = UDim2.new(0, 10, 0, 110)

local memLabel = fpsLabel:Clone()
memLabel.Parent = mainFrame
memLabel.Position = UDim2.new(0, 10, 0, 140)

-- Nút bật/tắt UI
local toggleButton = Instance.new("ImageButton")
toggleButton.Name = "ToggleButton"
toggleButton.Parent = screenGui
toggleButton.Size = UDim2.new(0, 60, 0, 60)
toggleButton.Position = UDim2.new(0, 15, 0, 15)
toggleButton.BackgroundTransparency = 1
toggleButton.Image = LOGO_ID -- Logo từ ID bạn đưa

-- Ẩn/hiện UI khi bấm nút
local isVisible = true
toggleButton.MouseButton1Click:Connect(function()
	isVisible = not isVisible
	mainFrame.Visible = isVisible
end)

-- Tính toán FPS, Ping, CPU, RAM
local lastUpdate = tick()
local frameCounter = 0

RunService.RenderStepped:Connect(function()
	frameCounter = frameCounter + 1
	local now = tick()
	if now - lastUpdate >= 1 then
		local fps = frameCounter
		frameCounter = 0
		lastUpdate = now

		-- FPS
		fpsLabel.Text = "FPS: " .. tostring(fps)

		-- Ping
		local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		pingLabel.Text = "Ping: " .. math.floor(ping) .. " ms"

		-- CPU
		local cpu = Stats.Workspace.Heartbeat:GetValue() * 100
		cpuLabel.Text = string.format("CPU: %.1f%%", cpu)

		-- RAM
		local mem = Stats:GetTotalMemoryUsageMb()
		memLabel.Text = string.format("RAM: %.1f MB", mem)
	end
end)
