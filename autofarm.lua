-- Auto Farm Level (Võ Tân Binh) by Cyber ShadowInf3ct
-- Sử dụng click chuột (võ thường) để đánh
-- Chạy tốt trên Xeno Executor

getgenv().AutoFarm = true

function notify(msg)
    game.StarterGui:SetCore("SendNotification", {
        Title = "Auto Farm",
        Text = msg,
        Duration = 4
    })
end

notify("Đang bắt đầu Auto Farm...")

local function getEnemy()
    local lv = game.Players.LocalPlayer.Data.Level.Value
    local enemyList = {
        [10] = {"Bandit", "BanditQuest1", Vector3.new(1060, 17, 1547), Vector3.new(1150, 17, 1580)},
        [15] = {"Monkey", "JungleQuest", Vector3.new(-1602, 37, 153), Vector3.new(-1440, 63, 200)},
        [30] = {"Pirate", "BuggyQuest1", Vector3.new(-1144, 5, 3828), Vector3.new(-1160, 5, 3930)},
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
    local tween = game:GetService("TweenService"):Create(
        hrp,
        TweenInfo.new((hrp.Position - pos).Magnitude / 200, Enum.EasingStyle.Linear),
        {CFrame = CFrame.new(pos)}
    )
    tween:Play()
    tween.Completed:Wait()
end

function clickAttack()
    local VirtualInput = game:GetService("VirtualInputManager")
    VirtualInput:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    wait()
    VirtualInput:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

spawn(function()
    while AutoFarm do
        local enemy = getEnemy()
        if enemy then
            local mobName = enemy[1]
            local questName = enemy[2]
            local questPos = enemy[3]
            local mobPos = enemy[4]

            -- Nhận quest
            pcall(function()
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(questPos)
                wait(1)
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Quest", questName, 1)
            end)

            wait(1)

            -- Tìm mob và đánh
            for _, mob in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                if mob.Name == mobName and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                    repeat
                        pcall(function()
                            local player = game.Players.LocalPlayer
                            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                            if hrp and mob:FindFirstChild("HumanoidRootPart") then
                                hrp.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                                clickAttack()
                            end
                        end)
                        wait(0.3)
                    until not mob.Parent or mob.Humanoid.Health <= 0 or not AutoFarm
                end
            end
        end
        wait(0.5)
    end
end)
