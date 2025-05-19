-- Script Auto Farm với menu DucTuyen

local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

getgenv().AutoFarm = false
getgenv().SelectedIsland = nil

-- Tọa độ các đảo để bay đến farm
local islandPositions = {
    ["Đảo Khởi Đầu"] = Vector3.new(-1000, 50, 1500),    -- Bạn chỉnh tọa độ đúng
    ["Đảo Khỉ"] = Vector3.new(2000, 50, 1000),           -- Bạn chỉnh tọa độ đúng
    ["Đảo Cướp Biển"] = Vector3.new(3000, 50, 2500),     -- Bạn chỉnh tọa độ đúng
}

-- Tên mob và quest tương ứng cho từng đảo
local islandInfo = {
    ["Đảo Khởi Đầu"] = { MobName = "Bandit", QuestName = "BanditQuest1" },
    ["Đảo Khỉ"] = { MobName = "Monkey", QuestName = "JungleQuest" },
    ["Đảo Cướp Biển"] = { MobName = "Pirate", QuestName = "BuggyQuest1" },
}

-- Tạo GUI menu
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "DucTuyen"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 220, 0, 180)
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "DucTuyen Auto Farm"
Title.Font = Enum.Font.SourceSansBold
Title.TextScaled = true

-- Level Label
local LevelLabel = Instance.new("TextLabel", Frame)
LevelLabel.Size = UDim2.new(1, -20, 0, 30)
LevelLabel.Position = UDim2.new(0, 10, 0, 40)
LevelLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
LevelLabel.TextColor3 = Color3.new(1,1,1)
LevelLabel.TextScaled = true
LevelLabel.Text = "Level: " .. plr.Data.Level.Value

-- Dropdown chọn đảo
local IslandDropdown = Instance.new("TextButton", Frame)
IslandDropdown.Size = UDim2.new(1, -20, 0, 30)
IslandDropdown.Position = UDim2.new(0, 10, 0, 80)
IslandDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
IslandDropdown.TextColor3 = Color3.new(1,1,1)
IslandDropdown.Text = "Chọn đảo"
IslandDropdown.AutoButtonColor = false

local IslandList = Instance.new("Frame", Frame)
IslandList.Size = UDim2.new(1, -20, 0, 90)
IslandList.Position = UDim2.new(0, 10, 0, 115)
IslandList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
IslandList.Visible = false
IslandList.ClipsDescendants = true

-- Tạo item cho dropdown
local function createDropdownItem(name)
    local btn = Instance.new("TextButton", IslandList)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = name
    btn.AutoButtonColor = false
    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(100,100,100) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(60,60,60) end)
    btn.MouseButton1Click:Connect(function()
        IslandDropdown.Text = name
        getgenv().SelectedIsland = name
        IslandList.Visible = false
    end)
    return btn
end

-- Tạo dropdown items
for islandName, _ in pairs(islandPositions) do
    createDropdownItem(islandName)
end

-- Toggle hiện/ẩn dropdown
IslandDropdown.MouseButton1Click:Connect(function()
    IslandList.Visible = not IslandList.Visible
end)

-- Toggle Bật/Tắt AutoFarm
local ToggleButton = Instance.new("TextButton", Frame)
ToggleButton.Size = UDim2.new(1, -20, 0, 30)
ToggleButton.Position = UDim2.new(0, 10, 0, 160)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
ToggleButton.TextColor3 = Color3.new(1,1,1)
ToggleButton.Text = "BẬT AUTO FARM"
ToggleButton.AutoButtonColor = false

ToggleButton.MouseButton1Click:Connect(function()
    getgenv().AutoFarm = not getgenv().AutoFarm
    if getgenv().AutoFarm then
        ToggleButton.Text = "TẮT AUTO FARM"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    else
        ToggleButton.Text = "BẬT AUTO FARM"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    end
end)

-- Cập nhật level liên tục
spawn(function()
    while true do
        pcall(function()
            LevelLabel.Text = "Level: " .. plr.Data.Level.Value
        end)
        wait(1)
    end
end)

-- Click võ tân binh
local function click()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

-- Vòng lặp auto farm
spawn(function()
    while true do
        if getgenv().AutoFarm and getgenv().SelectedIsland then
            local info = islandInfo[getgenv().SelectedIsland]
            local pos = islandPositions[getgenv().SelectedIsland]
            if info and pos and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                -- Bay lên cao hơn +10 để tránh NPC đánh
                plr.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 10, 0))
                wait(1)

                -- Nhận nhiệm vụ
                pcall(function()
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Quest", info.QuestName, 1)
                end)
                wait(1)

                -- Tìm mob farm
                for _, mob in pairs(workspace.Enemies:GetChildren()) do
                    if mob.Name == info.MobName and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                        repeat
                            pcall(function()
                                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                                local mhrp = mob:FindFirstChild("HumanoidRootPart")
                                if hrp and mhrp then
                                    hrp.CFrame = mhrp.CFrame + Vector3.new(0, 10, 0)
                                    click()
                                end
                            end)
                            wait(0.3)
                        until not mob.Parent or mob.Humanoid.Health <= 0 or not getgenv().AutoFarm
                    end
                end
            end
        end
        wait(0.5)
    end
end)
