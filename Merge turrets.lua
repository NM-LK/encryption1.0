local blacklist = {
    "BadPlayer1",
    "Hacker123",
    "CheaterABC",
    "",
    "要拉黑的用户名2"
}

local function checkBlacklist()
    local localPlayer = game.Players.LocalPlayer
    local username = localPlayer.Name
    
    for _, blacklistedName in ipairs(blacklist) do
        if username == blacklistedName then
            game.Players.LocalPlayer:Kick("你已被拉黑名单小宝贝~")
            return true
        end
    end
    return false
end

if checkBlacklist() then
    return  
end

function Antihook()
    return "Hook"
end

hookfunction(Antihook, function()
    return "No Hook"
end)

hookfunction(game.HttpGet, print)

if not isfunctionhooked(Antihook) or not isfunctionhooked(game.HttpGet) then
    game:shutdown("别搞我")
    while true do end
end

restorefunction(game.HttpGet)

if isfunctionhooked(game.HttpGet) or isfunctionhooked(request) or isfunctionhooked(tostring) then
    game:shutdown("666")
    while true do end
end

local replicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = game:GetService("Players").LocalPlayer
local tycoon

for _,v in workspace.Tycoon.Tycoons:GetChildren() do
    if v.Owner.Value == localPlayer then
        tycoon = v
    end
end

-- 所有开关变量
local infiniteEnergy = false
local antiLag = false
local autoConvert = false
local moneyAura = false
local killAllZombies = false
local instantKill = false
local damageMultiplier = 1
local gunMods = false
local autoBuyTowers = false
local buyAmount = "10"
local autoMergeTowers = false
local autoUpgradeConvert = false

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

            local MainWindow = WindUI:CreateWindow({
                Title = "<font color='#00AAFF'>合并塔防</font>",
                Icon = "rbxassetid://4483362748",
                Author = "NM Script",
                Size = UDim2.fromOffset(400, 400),
                Transparent = true,        
                Acrylic = true,
            })

            MainWindow:EditOpenButton({
                Title = "打开",
                Icon = "crown",
                CornerRadius = UDim.new(0, 16),
                StrokeThickness = 2,
                Draggable = true
            })

            -- 添加标签
            MainWindow:Tag({ Title = "合并塔防", Color = Color3.fromHex("#00FF66") })
            MainWindow:Tag({ Title = "NM", Color = Color3.fromHex("#FFAA00") })
            MainWindow:Tag({ Title = "👾", Color = Color3.fromHex("#FFAA00") })
        local TimeTag = MainWindow:Tag({
        Title = "00:00",
        Color = Color3.fromHex("#ff0000")
    })
    
    local hue = 0
    task.spawn(function()
        while true do
            local now = os.date("*t")
            local hours = string.format("%02d", now.hour)
            local minutes = string.format("%02d", now.min)
            
            hue = (hue + 0.01) % 1
            local color = Color3.fromHSV(hue, 1, 1)
            
            TimeTag:SetTitle(hours .. ":" .. minutes)

            task.wait(0.06)
        end
    end)

local Tabs = {
    NM = Window:Section({ Title = "功能", Opened = true }),    
}

local TabHandles = {
    Y = Tabs.NM:Tab({ Title = "自动", Icon = "zap" }),      -- 原 Y Tab，改闪电图标
    A = Tabs.NM:Tab({ Title = "击杀", Icon = "skull" }),    -- 原 A Tab，改骷髅图标
}

Toggle = TabHandles.Y:Toggle({
    Title = "无限能源",
    Desc = "手机性能不好卡是正常的",
    Locked = false,
    Callback = function(value)
        infiniteEnergy = value
        antiLag = value
        
        if antiLag then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") then
                    v.Enabled = false
                end
            end
            settings().Rendering.QualityLevel = 1
            game:GetService("Lighting").GlobalShadows = false
        end
    end
})

game:GetService("RunService").RenderStepped:Connect(function()
    if infiniteEnergy then
        local tier = game:GetService("Players").LocalPlayer:GetAttribute("Tier")
        if tier then
            game:GetService("ReplicatedStorage").Signals.RemoteEvents.GetWoolRemote:FireServer(tier)
        end
    end
end)

-- 基地开关
TabHandles.Y:Toggle({
    Title = "自动购买炮塔",
    Desc = "自动拼合炮塔",
    Locked = false,
    Callback = function(value)
        autoBuyTowers = value
    end
})

-- 购买数量下拉框
TabHandles.Y:Dropdown({
    Title = "选择数量",
    Desc = "选择后自动购买炮塔",
    Values = {"3", "10", "30", "50", "100", "1000", "10000"},
    Value = "3",
    Callback = function(value)
        buyAmount = value
    end
})

TabHandles.Y:Toggle({
    Title = "金钱光环",
    Desc = "自动收集周围范围的金钱",
    Locked = false,
    Callback = function(value)
        moneyAura = value
    end
})

TabHandles.Y:Toggle({
    Title = "自动合并",
    Desc = "自动合并炮塔",
    Locked = false,
    Callback = function(value)
        autoMergeTowers = value
    end
})

TabHandles.Y:Toggle({
    Title = "自动升级转换",
    Desc = "自动升级",
    Locked = false,
    Callback = function(value)
        autoUpgradeConvert = value
    end
})

-- 武器开关
TabHandles.A:Toggle({
    Title = "击杀所有僵尸",
    Desc = "『必须有武器拿在手上』",
    Locked = false,
    Callback = function(value)
        killAllZombies = value
    end
})

TabHandles.A:Toggle({
    Title = "伤害",
    Desc = "伤害僵尸",
    Locked = false,
    Callback = function(value)
        instantKill = value
    end
})

-- 伤害倍数滑块
TabHandles.A:Slider({
    Title = "调整伤害倍数 (1-10)",    
    Value = {
        Min = 1,
        Max = 10,
        Default = 1,
    },
    Callback = function(value)
        damageMultiplier = value
    end
})

-- 枪械修改开关
TabHandles.A:Toggle({
    Title = "枪械修改",
    Desc = "自动改为全自动，射速0，装填0",
    Locked = false,
    Callback = function(value)
        gunMods = value
    end
})

-- 主循环
game:GetService("RunService").RenderStepped:Connect(function(delta)
    local character = localPlayer.Character
    if not character then return end
    
    local tier = localPlayer:GetAttribute("Tier")
    local tool = character:FindFirstChildWhichIsA("Tool")
    local gun 
    if tool and tool:FindFirstChild("GunClient") and tool:FindFirstChild("Configuration") then
        gun = tool
    end

    if infiniteEnergy and tier then
        replicatedStorage.Signals.RemoteEvents.GetWoolRemote:FireServer(tier)
    end
    
    if autoConvert then
        replicatedStorage.Signals.RemoteEvents.PutRemote:FireServer()
    end
    
    if moneyAura then
        for _,v in workspace:GetChildren() do
            if v.Name == "Money" then
                firetouchinterest(v, character.HumanoidRootPart, 0)
                firetouchinterest(v, character.HumanoidRootPart, 1)
            end
        end
    end
    
    if gunMods and gun then
        if gun.Configuration:FindFirstChild("Automatic") and tool.Configuration.Automatic.Value == false then
            gun.Configuration.Automatic.Value = true
        end
        if gun.Configuration:FindFirstChild("Firerate") and gun.Configuration.Firerate.Value > 0 then
            gun.Configuration.Firerate.Value = 0
        end
        if gun.Configuration:FindFirstChild("ReloadTime") and gun.Configuration.ReloadTime.Value > 0 then
            gun.Configuration.ReloadTime.Value = 0
        end
    end
    
    for i = 1, damageMultiplier do
        if killAllZombies and gun and tycoon then
            for _,v in tycoon.Round:GetChildren() do
                if v:FindFirstChild("Humanoid") then
                    gun.Remotes.CastRay:FireServer(vector.create(1,1,1), v.Humanoid, true)
                    if instantKill then
                        v.Humanoid.Health = 0
                    end
                end
            end
        end
    end
    
    if autoBuyTowers and tycoon and buyAmount ~= "" then
        firetouchinterest(tycoon.Buttons_E["Add"..buyAmount].Head, character.HumanoidRootPart, 0)
        firetouchinterest(tycoon.Buttons_E["Add"..buyAmount].Head, character.HumanoidRootPart, 1)
    end
    
    if autoMergeTowers and tycoon then
        firetouchinterest(tycoon.Buttons_E.Merge.Head, character.HumanoidRootPart, 0)
        firetouchinterest(tycoon.Buttons_E.Merge.Head, character.HumanoidRootPart, 1)
    end
    
    if autoUpgradeConvert and tycoon then
        firetouchinterest(tycoon.Buttons_E.Upgrade.Head, character.HumanoidRootPart, 0)
        firetouchinterest(tycoon.Buttons_E.Upgrade.Head, character.HumanoidRootPart, 1)
    end
end)