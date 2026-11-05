-- The Strongest Battlegrounds - Nearby Mob / Boss Scanner
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

if CoreGui:FindFirstChild("TSBMobScannerGui") then
    CoreGui.TSBMobScannerGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TSBMobScannerGui"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

-- Nút mở/đóng Menu
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 20, 0, 280)
toggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 150)
toggleBtn.Text = "👾"
toggleBtn.TextSize = 24
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Parent = screenGui

local cornerBtn = Instance.new("UICorner")
cornerBtn.CornerRadius = UDim.new(1, 0)
cornerBtn.Parent = toggleBtn

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 260)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -130)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Visible = false
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Text = "Nearby Mob / Boss Scanner"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 12
title.Font = Enum.Font.SourceSansBold
title.Parent = mainFrame

local scrollBox = Instance.new("ScrollingFrame")
scrollBox.Size = UDim2.new(1, -20, 1, -100)
scrollBox.Position = UDim2.new(0, 10, 0, 45)
scrollBox.BackgroundTransparency = 1
scrollBox.CanvasSize = UDim2.new(0, 0, 2, 0)
scrollBox.ScrollBarThickness = 6
scrollBox.Parent = mainFrame

local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(1, 0, 1, 0)
infoText.BackgroundTransparency = 1
infoText.Text = "Đứng gần con quái/boss rồi bấm 'Quét Quái Xung Quanh'."
infoText.TextColor3 = Color3.fromRGB(200, 200, 200)
infoText.TextSize = 11
infoText.TextWrapped = true
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.Parent = scrollBox

-- Nút Quét
local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(1, -20, 0, 35)
scanBtn.Position = UDim2.new(0, 10, 1, -50)
scanBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 150)
scanBtn.Text = "Quét Quái Xung Quanh (50 studs)"
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.TextSize = 11
scanBtn.Font = Enum.Font.SourceSansBold
scanBtn.Parent = mainFrame

-- Nút Copy
local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(1, -20, 0, 30)
copyBtn.Position = UDim2.new(0, 10, 1, -12)
copyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
copyBtn.Text = "Copy Tất Cả Tên Quái"
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.TextSize = 10
copyBtn.Font = Enum.Font.SourceSansBold
copyBtn.Parent = mainFrame

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

local copiedString = ""

scanBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    local foundMobs = {}
    local uniqueCheck = {}
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
            -- Bỏ qua người chơi trong phòng
            local isPlayer = false
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character == obj then
                    isPlayer = true
                    break
                end
            end
            
            if not isPlayer then
                local rootPart = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
                if rootPart then
                    local dist = (rootPart.Position - hrp.Position).Magnitude
                    if dist <= 50 then
                        local entry = obj.Name .. " (Model) / Part: " .. rootPart.Name
                        if not uniqueCheck[entry] then
                            uniqueCheck[entry] = true
                            table.insert(foundMobs, entry)
                        end
                    end
                end
            end
        end
    end
    
    if #foundMobs > 0 then
        copiedString = table.concat(foundMobs, ", ")
        infoText.Text = "Danh sách Quái/Boss quét được:\n\n" .. copiedString
    else
        infoText.Text = "Không tìm thấy con quái nào trong bán kính 50 studs!"
        copiedString = ""
    end
end)

copyBtn.MouseButton1Click:Connect(function()
    if copiedString ~= "" then
        pcall(function()
            setclipboard(copiedString)
        end)
        copyBtn.Text = "Đã Copy Danh Sách Quái!"
        task.wait(1.5)
        copyBtn.Text = "Copy Tất Cả Tên Quái"
    end
end)

print("Mob Scanner đã khởi động!")
