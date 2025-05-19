-- Gui Lib
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- Tọa độ đảo Sea 1
local Islands = {
    ["Đảo Khởi đầu"] = Vector3.new(1106.608, 16.308, 1424.957),
    ["Đảo Khỉ"] = Vector3.new(-1613.780, 36.887, 147.830),
    ["Làng Hải Tặc"] = Vector3.new(-1058.873, 13.707, 4107.426),
    ["Đảo Sa Mạc"] = Vector3.new(1113.639, 16.812, 4431.332)
}

-- Biến điều khiển
local autoFarm = false
local selectedIsland = nil

-- Tạo GUI
local Window = Rayfield:CreateWindow({
   Name = "Duc Tuyen Dev",
   LoadingTitle = "Duc Tuyen Dev Hub",
   LoadingSubtitle = "Auto Farm Sea 1",
   ConfigurationSaving = {Enabled = false},
   Discord = {Enabled = false}
})

-- Mục 1: Hiển thị Level
Window:CreateParagraph({
   Title = "Level của bạn",
   Content = tostring(game.Players.LocalPlayer.Data.Level.Value)
})

-- Mục 2: Auto Farm
Window:CreateToggle({
    Name = "Bật/Tắt Auto Farm",
    CurrentValue = false,
    Callback = function(Value)
        autoFarm = Value
    end
})

Window:CreateDropdown({
    Name = "Chọn đảo để farm",
    Options = {"Đảo Khởi đầu", "Đảo Khỉ", "Làng Hải Tặc", "Đảo Sa Mạc"},
    CurrentOption = "Đảo Khởi đầu",
    Callback = function(Option)
        selectedIsland = Islands[Option]
    end
})

-- Tự động bay & farm
task.spawn(function()
    while task.wait(0.1) do
        if autoFarm and selectedIsland then
            -- Teleport bay cao đến đảo
            local plr = game.Players.LocalPlayer
            local char = plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(selectedIsland + Vector3.new(0, 80, 0))
            end

            -- Tìm NPC
            for _, mob in pairs(workspace.Enemies:GetChildren()) do
                if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                    -- Gom quái
                    mob.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0, -5, 0)
                    -- Tấn công
                    local args = {
                        [1] = {
                            ["Type"] = "Combat",
                            ["Hit"] = {mob.HumanoidRootPart},
                            ["CameraShaker"] = Vector3.new(0, 0, 0),
                            ["HitTime"] = 1,
                            ["RealSource"] = plr.Character.HumanoidRootPart,
                            ["Weapon"] = "Combat"
                        }
                    }
                    game:GetService("ReplicatedStorage").Remotes.Combat:FireServer(unpack(args))
                end
            end
        end
    end
end)
