-- UI Overlay FPS + Ping + CPU + RAM
local screenGui = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local uiCorner = Instance.new("UICorner")
local uiStroke = Instance.new("UIStroke")
local fpsLabel = Instance.new("TextLabel")
local pingLabel = Instance.new("TextLabel")
local cpuLabel = Instance.new("TextLabel")
local ramLabel = Instance.new("TextLabel")

screenGui.Parent = game.CoreGui

-- Khung chính
mainFrame.Size = UDim2.new(0, 350, 0, 130)
mainFrame.Position = UDim2.new(0.5, -175, 0.05, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

uiStroke.Thickness = 2
uiStroke.Parent = mainFrame

-- Hàm tạo TextLabel
local function createLabel(text, posY)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 30)
    lbl.Position = UDim2.new(0, 0, 0, posY)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 22
    lbl.TextColor3 = Color3.new(1, 1, 1)
    lbl.Parent = mainFrame
    return lbl
end

fpsLabel = createLabel("FPS: 0", 5)
pingLabel = createLabel("PING: 0 ms", 35)
cpuLabel = createLabel("CPU: 0%", 65)
ramLabel = createLabel("RAM: 0 MB", 95)

-- Hàm đổi màu cầu vồng
local rainbowColors = {
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(255, 127, 0),
    Color3.fromRGB(255, 255, 0),
    Color3.fromRGB(0, 255, 0),
    Color3.fromRGB(0, 255, 255),
    Color3.fromRGB(0, 0, 255),
    Color3.fromRGB(255, 0, 255)
}
local colorIndex = 1

spawn(function()
    while true do
        uiStroke.Color = rainbowColors[colorIndex]
        fpsLabel.TextColor3 = rainbowColors[colorIndex]
        pingLabel.TextColor3 = rainbowColors[colorIndex]
        cpuLabel.TextColor3 = rainbowColors[colorIndex]
        ramLabel.TextColor3 = rainbowColors[colorIndex]
        colorIndex = colorIndex % #rainbowColors + 1
        wait(0.3)
    end
end)

-- Hàm cập nhật thông số hệ thống
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local fps = 0
local lastUpdate = tick()

RunService.RenderStepped:Connect(function()
    fps = fps + 1
    if tick() - lastUpdate >= 1 then
        fpsLabel.Text = "FPS: " .. fps
        lastUpdate = tick()
        fps = 0
    end
end)

-- Fake Ping, CPU, RAM demo (nếu game ko có API)
spawn(function()
    while true do
        local fakePing = math.random(20, 100)
        local fakeCPU = math.random(10, 90)
        local fakeRAM = math.random(500, 3000)
        pingLabel.Text = "PING: " .. fakePing .. " ms"
        cpuLabel.Text = "CPU: " .. fakeCPU .. "%"
        ramLabel.Text = "RAM: " .. fakeRAM .. " MB"
        wait(1)
    end
end)
