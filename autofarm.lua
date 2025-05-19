-- Auto Farm Level by Cyber ShadowInf3ct
-- Tested on Xeno Executor
-- Chạy trong Sea 1

getgenv().AutoFarm = true

function notify(msg)
    game.StarterGui:SetCore("SendNotification", {
        Title = "Auto Farm Level",
        Text = msg,
        Duration = 4
    })
end

notify("Bắt đầu Auto Farm...")

local function getEnemy()
    local lv = game.Players.LocalPlayer.Data.Level.Value
    local enemyList = {
        -- [minLevel] = {mobName, questName, questPos, mobPos}
        [10] = {"Bandit", "BanditQuest1", Vector3.new(1060, 17, 1547), Vector3.new(1150, 17, 1580)},
        [15] = {"Monkey", "JungleQuest", Vector3.new(-1602, 37, 153), Vector3.new(-1440, 63, 200)},
        [30] = {"Pirate", "BuggyQuest1", Vector3.new(-1144, 5, 3828), Vector3.new(-1160, 5, 3930)},
        -- bạn có thể thêm nhiều dòng khác theo level ở đây
    }

    local selected = nil
    for minLevel, data in pairs(enemyList) do
        if lv >= minLevel then
            selected = data
        end
    end
    return selected
end

function tweenTo(pos)
    local plr = game.Players.LocalPlayer
    local hrp = plr.Character:WaitForChild("HumanoidRootPart")
    local tween = game:GetService("TweenService"):Create(hrp, TweenInfo.new((hrp.Position - pos).Magnitude / 200, Enum.EasingStyle.Linear), {CFrame = CFrame.new(pos)})
    tween:Play()
    tween.Completed:Wait()
end

spawn(function()
    while AutoFarm do
        local enemy = getEnemy()
        if enemy then
            local mobName = enemy[1]
            local questName = enemy[2]
            local questPos = enemy[3]
            local mobPos = enemy[4]

            -- Lấy quest
            pcall(function()
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(questPos)
                wait(1)
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Quest", questName, 1)
            end)

            wait(1)

            -- Tìm và đánh quái
            for _, mob in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                if mob.Name == mobName and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                    repeat
                        pcall(function()
                            local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
                            hrp.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                            wait(0.2)
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, "Z", false, game)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, "Z", false, game)
                        end)
                        wait(0.5)
                    until mob.Humanoid.Health <= 0 or not AutoFarm
                end
            end
        end
        wait(1)
    end
end)
