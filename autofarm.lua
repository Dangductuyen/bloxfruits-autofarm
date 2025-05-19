-- Script by Cyber ShadowInf3ct
-- Auto Farm Lever [Combat] - Có Menu + Auto chuyển đảo

local plr = game.Players.LocalPlayer
local vinput = game:GetService("VirtualInputManager")

-- Thêm GUI Menu đơn giản
local screenGui = Instance.new("ScreenGui", game.CoreGui)
local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 150, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "BẬT AUTO FARM"
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.TextScaled = true

getgenv().AutoFarm = false

toggleButton.MouseButton1Click:Connect(function()
    AutoFarm = not AutoFarm
    toggleButton.Text = AutoFarm and "TẮT AUTO FARM" or "BẬT AUTO FARM"
    toggleButton.BackgroundColor3 = AutoFarm and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(0, 200, 0)
end)

-- Click Combat
function click()
    vinput:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    vinput:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

-- Danh sách đảo theo level
function getMobInfo()
    local lv = plr.Data.Level.Value
    if lv < 15 then
        return {
            Name = "Bandit",
            QuestName = "BanditQuest1",
            QuestPos = CFrame.new(1060, 17, 1547),
            IslandPos = CFrame.new(1141, 16, 1630),
        }
    elseif lv < 30 then
        return {
            Name = "Monkey",
            QuestName = "JungleQuest",
            QuestPos = CFrame.new(-1602, 37, 153),
            IslandPos = CFrame.new(-1336, 11, 503),
        }
    elseif lv < 50 then
        return {
            Name = "Pirate",
            QuestName = "BuggyQuest1",
            QuestPos = CFrame.new(-1144, 5, 3828),
            IslandPos = CFrame.new(-1115, 4, 3895),
        }
    else
        return nil
    end
end

-- Lấy nhiệm vụ
function getQuest(info)
    pcall(function()
        plr.Character.HumanoidRootPart.CFrame = info.QuestPos
        wait(1)
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Quest", info.QuestName, 1)
        wait(0.5)
    end)
end

-- Auto Farm
spawn(function()
    while true do
        if AutoFarm then
            local info = getMobInfo()
            if info then
                -- Bay tới đảo nếu chưa đúng
                local dist = (plr.Character.HumanoidRootPart.Position - info.IslandPos.Position).Magnitude
                if dist > 500 then
                    plr.Character.HumanoidRootPart.CFrame = info.IslandPos
                    wait(2)
                end

                -- Nhận nhiệm vụ và farm
                getQuest(info)

                for _, mob in pairs(workspace.Enemies:GetChildren()) do
                    if mob.Name == info.Name and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                        repeat
                            pcall(function()
                                local char = plr.Character
                                if char and char:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("HumanoidRootPart") then
                                    char.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                                    click()
                                end
                            end)
                            wait(0.3)
                        until not mob.Parent or mob.Humanoid.Health <= 0 or not AutoFarm
                    end
                end
            else
                warn("Cấp độ quá cao, chưa cập nhật đảo!")
                AutoFarm = false
                toggleButton.Text = "BẬT AUTO FARM"
                toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            end
        end
        wait(0.5)
    end
end)
