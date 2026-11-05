-- The Strongest Battlegrounds - CANDY BETA Farm (Perfect Pumpkin Combat & Input Simulation)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

if CoreGui:FindFirstChild("TSBCandyBetaGui") then
    CoreGui.TSBCandyBetaGui:Destroy()
end

-- Anti-AFK
player.Idled:Connect(function()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    task.wait(0.1)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TSBCandyBetaGui"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

-- Thanh trạng thái PUMPKIN (đẩy cao lên trên thanh nộ)
local statusContainer = Instance.new("Frame")
statusContainer.Size = UDim2.new(0, 110, 0, 22)
statusContainer.Position = UDim2.new(0.5, -55, 1, -145)
statusContainer.BackgroundTransparency = 1
statusContainer.Visible = true
statusContainer.Parent = screenGui

local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 8, 0, 8)
statusDot.Position = UDim2.new(0, 0, 0.5, -4)
statusDot.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
statusDot.Parent = statusContainer

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = statusDot

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -14, 1, 0)
statusText.Position = UDim2.new(0, 14, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "PUMPKIN"
statusText.TextColor3 = Color3.fromRGB(255, 255, 255)
statusText.TextSize = 12
statusText.Font = Enum.Font.SourceSansBold
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = statusContainer

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 20, 0, 150)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
toggleBtn.Text = "🍬"
toggleBtn.TextSize = 26
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Parent = screenGui

local cornerBtn = Instance.new("UICorner")
cornerBtn.CornerRadius = UDim.new(1, 0)
cornerBtn.Parent = toggleBtn

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 410)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -205)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.Visible = false
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Text = "CANDY BETA"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 13
title.Font = Enum.Font.SourceSansBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

local settings = {
    autoCandy = false,
    autoDoor = false,
    autoBossCombat = false
}

local function createFeatureToggle(name, posY, key)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = name .. ": [OFF]"
    btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    btn.TextSize = 12
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = mainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        settings[key] = not settings[key]
        if settings[key] then
            btn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Text = name .. ": [ON]"
        else
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            btn.TextColor3 = Color3.fromRGB(255, 100, 100)
            btn.Text = name .. ": [OFF]"
        end
    end)
end

createFeatureToggle("CANDY FARM", 45, "autoCandy")
createFeatureToggle("AUTOMATIC DOOR", 90, "autoDoor")

-- Nút teleport 1 lần đến Pumpkin
local teleBossBtn = Instance.new("TextButton")
teleBossBtn.Size = UDim2.new(1, -20, 0, 40)
teleBossBtn.Position = UDim2.new(0, 10, 0, 135)
teleBossBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 100)
teleBossBtn.Text = "TELEPORT TO PUMPKIN"
teleBossBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
teleBossBtn.TextSize = 12
teleBossBtn.Font = Enum.Font.SourceSansBold
teleBossBtn.Parent = mainFrame

local teleCorner = Instance.new("UICorner")
teleCorner.CornerRadius = UDim.new(0, 8)
teleCorner.Parent = teleBossBtn

createFeatureToggle("AUTO PUMPKIN COMBAT", 180, "autoBossCombat")

-- Dropdown menu chọn skill tự động đánh boss
local dropToggleBtn = Instance.new("TextButton")
dropToggleBtn.Size = UDim2.new(1, -20, 0, 35)
dropToggleBtn.Position = UDim2.new(0, 10, 0, 225)
dropToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
dropToggleBtn.Text = "▼ Select Combat Skills Order"
dropToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
dropToggleBtn.TextSize = 11
dropToggleBtn.Font = Enum.Font.SourceSansBold
dropToggleBtn.Parent = mainFrame

local dropToggleCorner = Instance.new("UICorner")
dropToggleCorner.CornerRadius = UDim.new(0, 8)
dropToggleCorner.Parent = dropToggleBtn

local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(1, -20, 0, 100)
dropdownFrame.Position = UDim2.new(0, 10, 0, 265)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
dropdownFrame.Visible = false
dropdownFrame.Parent = mainFrame

local dropCorner = Instance.new("UICorner")
dropCorner.CornerRadius = UDim.new(0, 8)
dropCorner.Parent = dropdownFrame

local skillListOpen = false
dropToggleBtn.MouseButton1Click:Connect(function()
    skillListOpen = not skillListOpen
    dropdownFrame.Visible = skillListOpen
    if skillListOpen then
        dropToggleBtn.Text = "▲ Select Combat Skills Order"
    else
        dropToggleBtn.Text = "▼ Select Combat Skills Order"
    end
end)

-- Cấu hình danh sách 4 slot skill theo thứ tự ưu tiên sử dụng
local skillOrder = {"1", "2", "3", "4"}
local availableSkills = {"1", "2", "3", "4", "Q", "E", "R", "F"}
local skillSlots = {}

for i = 1, 4 do
    local sBtn = Instance.new("TextButton")
    sBtn.Size = UDim2.new(1, -10, 0, 20)
    sBtn.Position = UDim2.new(0, 5, 0, 5 + (i - 1) * 23)
    sBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
    sBtn.Text = "Skill Slot " .. i .. " : [" .. skillOrder[i] .. "]"
    sBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    sBtn.TextSize = 10
    sBtn.Font = Enum.Font.SourceSansBold
    sBtn.Parent = dropdownFrame
    
    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(0, 4)
    sc.Parent = sBtn
    
    sBtn.MouseButton1Click:Connect(function()
        -- Xoay vòng đổi skill khi bấm vào slot
        for idx, val in ipairs(availableSkills) do
            if val == skillOrder[i] then
                local nextIdx = idx % #availableSkills + 1
                skillOrder[i] = availableSkills[nextIdx]
                break
            end
        end
        sBtn.Text = "Skill Slot " .. i .. " : [" .. skillOrder[i] .. "]"
    end)
end

-- Tự động đóng menu phụ khi menu chính đóng
mainFrame:GetPropertyChangedSignal("Visible"):Connect(function()
    if not mainFrame.Visible then
        skillListOpen = false
        dropdownFrame.Visible = false
        dropToggleBtn.Text = "▼ Select Combat Skills Order"
    end
end)

local validCandies = {
    ["DarkOrangeCandy1"] = true,
    ["DarkOrangeCandy2"] = true,
    ["DarkOrangeCandy3"] = true,
    ["DarkOrangeCandy4"] = true,
    ["OrangeCandy1"] = true,
    ["OrangeCandy2"] = true,
    ["OrangeCandy3"] = true,
    ["OrangeCandy4"] = true,
    ["MrBloxBar"] = true,
    ["BloxRoll"] = true,
    ["Chocoblox"] = true,
    ["BloxyDrops"] = true
}

local openedDoors = {}

local function getBossTarget()
    local liveFolder = Workspace:FindFirstChild("Live")
    if liveFolder then
        local penytaModel = liveFolder:FindFirstChild("Penyta")
        if penytaModel then
            local hrp = penytaModel:FindFirstChild("HumanoidRootPart")
            if hrp and hrp:IsA("BasePart") then
                return penytaModel, hrp
            end
        end
    end
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == "Penyta" and obj:IsA("Model") then
            local hrp = obj:FindFirstChild("HumanoidRootPart")
            if hrp and hrp:IsA("BasePart") then
                return obj, hrp
            end
        end
    end
    return nil, nil
end

-- Hàm kích hoạt RemoteEvent tấn công chuẩn xác trong game (gửi lệnh trực tiếp không cần thao tác chuột vật lý hay bàn phím)
local function triggerCombatRemote(actionType, skillKey)
    pcall(function()
        -- Tìm kiếm RemoteEvent chiến đấu phổ biến trong game
        for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") then
                local rName = string.lower(remote.Name)
                if rName:find("combat") or rName:find("attack") or rName:find("skill") or rName:find("input") or rName:find("punch") then
                    remote:FireServer(actionType, skillKey)
                end
            end
        end
    end)
end

teleBossBtn.MouseButton1Click:Connect(function()
    local _, bossPart = getBossTarget()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") and bossPart then
        char.HumanoidRootPart.CFrame = bossPart.CFrame * CFrame.new(0, 0, 3)
    end
end)

RunService.Stepped:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
            humanoid.Sit = false
        end
    end
    
    local bossModel, bossPart = getBossTarget()
    if bossModel and bossPart then
        statusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        statusDot.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    end
end)

task.spawn(function()
    local currentSkillIndex = 1
    local actionDelay = 0
    
    while true do
        task.wait(0.03)
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            
            -- AUTO PUMPKIN COMBAT: Bay bám sát sau lưng boss, hướng mặt thẳng vào lưng boss, gửi lệnh Remote đánh và tung skill theo thứ tự
            if settings.autoBossCombat then
                local bossModel, bossPart = getBossTarget()
                if bossModel and bossPart then
                    -- Đứng phía sau lưng boss và nhìn thẳng về phía boss (CFrame đảo hướng 180 độ)
                    local targetCF = bossPart.CFrame
                    local behindPos = targetCF * CFrame.new(0, 0, 4)
                    hrp.CFrame = CFrame.new(behindPos.Position, targetCF.Position)
                    
                    -- Gửi lệnh remote đánh thường (M1) liên tục
                    triggerCombatRemote("M1", nil)
                    
                    -- Lần lượt tung skill theo thứ tự đã cài đặt
                    actionDelay = actionDelay + 1
                    if actionDelay >= 20 then
                        actionDelay = 0
                        local activeKey = skillOrder[currentSkillIndex]
                        triggerCombatRemote("Skill", activeKey)
                        currentSkillIndex = currentSkillIndex % #skillOrder + 1
                    end
                    
                    continue
                end
            end
            
            -- CANDY FARM
            if settings.autoCandy then
                local bestCandyCenter = nil
                local maxCandiesInCluster = 0
                local allCandies = {}
                
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and validCandies[obj.Name] and obj.Position.Y > -10 then
                        local pos = obj.Position
                        local isForbiddenArea = (pos.X > 500 and pos.X < 800 and pos.Z > -200 and pos.Z < 100)
                        if not isForbiddenArea then
                            table.insert(allCandies, obj)
                        end
                    end
                end
                
                for _, candy in ipairs(allCandies) do
                    local count = 0
                    for _, other in ipairs(allCandies) do
                        if (candy.Position - other.Position).Magnitude <= 30 then
                            count = count + 1
                        end
                    end
                    if count > maxCandiesInCluster then
                        maxCandiesInCluster = count
                        bestCandyCenter = candy
                    end
                end
                
                if not bestCandyCenter and #allCandies > 0 then
                    local minDist = math.huge
                    for _, candy in ipairs(allCandies) do
                        local dist = (candy.Position - hrp.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            bestCandyCenter = candy
                        end
                    end
                end
                
                if bestCandyCenter then
                    hrp.CFrame = CFrame.new(bestCandyCenter.Position + Vector3.new(0, 2.5, 0), hrp.Position + hrp.CFrame.LookVector)
                    task.wait(0.02)
                    continue
                end
            end
            
            -- AUTOMATIC DOOR
            if settings.autoDoor then
                local foundDoor = false
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj.Name == "DOOR 1 NEW" and not openedDoors[obj] then
                        local promptList = {}
                        for _, p in pairs(obj:GetDescendants()) do
                            if p:IsA("ProximityPrompt") then
                                table.insert(promptList, p)
                            end
                        end
                        
                        if #promptList == 0 or not obj.Parent then
                            openedDoors[obj] = true
                        else
                            local targetPart = obj:FindFirstChild("Right Door") or obj:FindFirstChild("RightDoor") or obj:FindFirstChild("Left Door") or obj:FindFirstChildOfClass("BasePart")
                            if targetPart then
                                hrp.CFrame = targetPart.CFrame * CFrame.new(0, 0, 3)
                                
                                for i = 1, 8 do
                                    pcall(function()
                                        for _, prompt in ipairs(promptList) do
                                            prompt.MaxActivationDistance = 999999
                                            prompt.HoldDuration = 0
                                            fireproximityprompt(prompt)
                                        end
                                    end)
                                    task.wait(0.01)
                                end
                                
                                local stillHasPrompt = false
                                for _, p in pairs(obj:GetDescendants()) do
                                    if p:IsA("ProximityPrompt") then
                                        stillHasPrompt = true
                                        break
                                    end
                                end
                                
                                if not stillHasPrompt then
                                    openedDoors[obj] = true
                                end
                                
                                foundDoor = true
                                break
                            end
                        end
                    end
                end
                if foundDoor then continue end
            end
        end
    end
end)

print("CANDY BETA (Remote Combat & Perfect Orientation Fix) Loaded Successfully!")
