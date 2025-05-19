-- Script by Cyber ShadowInf3ct
-- Auto Farm Lever [Combat] v3 - Full tính năng theo yêu cầu

local plr = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local vinput = game:GetService("VirtualInputManager")

getgenv().AutoFarm = false

-- Tạo GUI Menu
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

-- Toggle Button
local toggle = Instance.new("TextButton", gui)
toggle.Size = UDim2.new(0, 150, 0, 40)
toggle.Position = UDim2.new(0, 10, 0, 10)
toggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
toggle.Text = "BẬT AUTO FARM"
toggle.TextColor3 = Color3.new(1,1,1)
toggle.TextScaled = true

-- Lever Display
local levelLabel = Instance.new("TextLabel", gui)
levelLabel.Size = UDim2.new(0, 150, 0, 30)
levelLabel.Position = UDim2.new(0, 10, 0, 60)
levelLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
levelLabel.TextColor3 = Color3.new(1,1,1)
levelLabel.TextScaled = true
levelLabel.Text = "Level: " .. plr.Data.Level.Value

-- Tự cập nhật level hiển thị
spawn(function()
    while true do
        pcall(function()
            levelLabel.Text = "Level: " .. plr.Data.Level.Value
        end)
        wait(1)
    end
end)

-- Click võ thường
function click()
    vinput:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    vinput:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

-- Toggle chức năng
toggle.MouseButton1Click:Connect(function()
    AutoFarm = not AutoFarm
    toggle.Text = AutoFarm and "TẮT AUTO FARM" or "BẬT AUTO FARM"
    toggle.BackgroundColor3 = AutoFarm and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(0, 200, 0)
end)

-- Lấy dữ liệu từ la bàn (QuestCompass)
function getCompassTarget()
    local compass = workspace:FindFirstChild("QuestMarkers")
    if compass and compass:FindFirstChild("QuestMarker") then
        return compass.QuestMarker.Position
    end
    return nil
end

-- Lấy info mob theo cấp
function getMobInfo()
    local lv = plr.Data.Level.Value
    if lv < 15 then
        return {
            Name = "Bandit",
            QuestName = "BanditQuest1"
        }
    elseif lv < 30 then
        return {
            Name = "Monkey",
            QuestName = "JungleQuest"
        }
    elseif lv < 50 then
        return {
            Name = "Pirate",
            QuestName = "BuggyQuest1"
        }
    else
        return nil
    end
end

-- Nhận quest
function getQuest(info)
    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Quest", info.QuestName, 1)
end

-- Vòng lặp farm
spawn(function()
    while true do
        if AutoFarm then
            local info = getMobInfo()
            local compassPos = getCompassTarget()

            if info and compassPos then
                -- Teleport tới la bàn chỉ định
                plr.Character.HumanoidRootPart.CFrame = CFrame.new(compassPos + Vector3.new(0, 5, 0))
                wait(1)

                -- Nhận nhiệm vụ
                getQuest(info)
                wait(1)

                -- Tìm mob
                for _, mob in pairs(workspace.Enemies:GetChildren()) do
                    if mob.Name == info.Name and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                        repeat
                            pcall(function()
                                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                                local mhrp = mob:FindFirstChild("HumanoidRootPart")
                                if hrp and mhrp then
                                    hrp.CFrame = mhrp.CFrame + Vector3.new(0, 5, 0)
                                    click()
                                end
                            end)
                            wait(0.3)
                        until not mob.Parent or mob.Humanoid.Health <= 0 or not AutoFarm
                    end
                end
            end
        end
        wait(0.5)
    end
end)
