-- The Strongest Battlegrounds - Object Inspector & Info Copy Tool
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

if CoreGui:FindFirstChild("TSBObjectInspectorGui") then
    CoreGui.TSBObjectInspectorGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TSBObjectInspectorGui"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 360, 0, 420)
mainFrame.Position = UDim2.new(0.5, -180, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.05
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Text = "OBJECT INSPECTOR & COPY"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 13
title.Font = Enum.Font.SourceSansBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

-- Khung hiển thị thông tin cuộn
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -110)
scrollFrame.Position = UDim2.new(0, 10, 0, 50)
scrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
scrollFrame.BorderSizePixel = 0
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.Parent = mainFrame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 8)
scrollCorner.Parent = scrollFrame

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -10, 1, 0)
infoLabel.Position = UDim2.new(0, 5, 0, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Đang trỏ chuột vào đối tượng bất kỳ...\n(Hover chuột vào vật thể để xem thông tin)"
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoLabel.TextSize = 12
infoLabel.Font = Enum.Font.Code
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.TextWrapped = true
infoLabel.Parent = scrollFrame

-- Nút Copy
local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(1, -20, 0, 40)
copyBtn.Position = UDim2.new(0, 10, 1, -50)
copyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
copyBtn.Text = "COPY ALL INFO"
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.TextSize = 13
copyBtn.Font = Enum.Font.SourceSansBold
copyBtn.Parent = mainFrame

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 8)
copyCorner.Parent = copyBtn

local lastCopiedText = ""
local currentObject = nil

-- Hàm lấy thông tin chi tiết xuống dòng từng mục
local function getObjectInfo(obj)
    if not obj then return "Không có đối tượng nào được chọn." end
    
    local name = obj.Name
    local className = obj.ClassName
    local fullName = obj.GetFullName and obj:GetFullName() or "N/A"
    local parentName = obj.Parent and obj.Parent.Name or "N/A"
    
    local posStr = "N/A"
    if obj:IsA("BasePart") then
        local p = obj.Position
        posStr = string.format("X: %.2f, Y: %.2f, Z: %.2f", p.X, p.Y, p.Z)
    elseif obj:IsA("Model") then
        local primary = obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildOfClass("BasePart")
        if primary then
            local p = primary.Position
            posStr = string.format("X: %.2f, Y: %.2f, Z: %.2f (Model Center)", p.X, p.Y, p.Z)
        end
    end
    
    local material = obj:IsA("BasePart") and tostring(obj.Material):gsub("Enum.Material.", "") or "N/A"
    local color = obj:IsA("BasePart") and tostring(obj.Color) or "N/A"
    local size = obj:IsA("BasePart") and string.format("X: %.2f, Y: %.2f, Z: %.2f", obj.Size.X, obj.Size.Y, obj.Size.Z) or "N/A"
    
    -- Định dạng xuống dòng rõ ràng cho từng thuộc tính
    local result = string.format(
        "Name: %s\n" ..
        "ClassName: %s\n" ..
        "Parent: %s\n" ..
        "FullName: %s\n" ..
        "Position: %s\n" ..
        "Material: %s\n" ..
        "Size: %s\n" ..
        "Color: %s",
        name, className, parentName, fullName, posStr, material, size, color
    )
    
    return result
end

-- Raycast theo chuột để chọn đối tượng trong game theo thời gian thực
RunService.RenderStepped:Connect(function()
    local mouse = player:GetMouse()
    local target = mouse.Target
    
    if target and target ~= currentObject then
        currentObject = target
        lastCopiedText = getObjectInfo(target)
        infoLabel.Text = lastCopiedText
    end
end)

-- Sự kiện nhấn nút Copy
copyBtn.MouseButton1Click:Connect(function()
    if lastCopiedText ~= "" then
        pcall(function()
            setclipboard(lastCopiedText)
        end)
        copyBtn.Text = "COPIED SUCCESSFULLY!"
        copyBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
        task.wait(1)
        copyBtn.Text = "COPY ALL INFO"
        copyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    end
end)

print("Object Inspector Loaded Successfully!")
