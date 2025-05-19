-- Auto Farm Lever by Cyber ShadowInf3ct (Dùng Combat)
-- Sửa lỗi không đánh, thêm bay lên đầu NPC

getgenv().AutoFarm = true

local plr = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local vinput = game:GetService("VirtualInputManager")

-- Hàm click đánh thường (Combat)
function click()
    vinput:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    vinput:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

-- Thông báo
game.StarterGui:SetCore("SendNotification", {
    Title = "Auto Farm",
    Text = "Đã bắt đầu auto farm bằng Combat!",
    Duration = 5
})

-- Hàm tìm mob theo cấp
function getMobInfo()
    local lv = plr.Data.Level.Value
    if lv < 15 then
        return {
            Name = "Bandit",
            QuestName = "BanditQuest1",
            QuestPos = CFrame.new(1060, 17, 1547),
        }
    elseif lv < 30 then
        return {
            Name = "Monkey",
            QuestName = "JungleQuest",
            QuestPos = CFrame.new(-1602, 37, 153),
        }
    elseif lv < 50 then
        return {
            Name = "Pirate",
            QuestName = "BuggyQuest1",
            QuestPos = CFrame.new(-1144, 5, 3828),
        }
    else
        return nil
    end
end

-- Hàm lấy quest
function getQuest(info)
    pcall(function()
        plr.Character.HumanoidRootPart.CFrame = info.QuestPos
        wait(1)
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Quest", info.QuestName, 1)
        wait(0.5)
    end)
end

-- Farm mob
spawn(function()
    while AutoFarm do
        local info = getMobInfo()
        if info then
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
            game.StarterGui:SetCore("SendNotification", {
                Title = "Auto Farm",
                Text = "Chưa hỗ trợ cấp cao hơn!",
                Duration = 5
            })
            AutoFarm = false
        end
        wait(0.5)
    end
end)
