
--// GROW A GARDEN HUB - VISUAL PRO
--// Estilo SPEED HUB

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")

-- ===== REMOTES (AJUSTE SE PRECISAR) =====
local Remotes = {
    Equip = RS.Remotes.EquipPet,
    Unequip = RS.Remotes.UnequipAll,
    Hatch = RS.Remotes.HatchEgg,
    OpenEgg = RS.Remotes.OpenEgg,
    Sell = RS.Remotes.SellPet
}

-- ===== CONFIG =====
local Config = {
    DelayHatch = 1.2,
    DelayOpen = 1.5,
    DelaySell = 2,

    HatchCombo = {"Chicken","Cow","Pig"},
    OpenPet = "Koi",
    SellPet = "Seal",
    IgnoreGiant = true,

    PetsToSell = {}
}

-- ===== FLAGS =====
local AutoHatch = false
local AutoOpen = false
local AutoSell = false

-- ===== FUNÇÕES =====
local function PetsFolder()
    return Player:WaitForChild("Pets")
end

local function UnequipAll()
    Remotes.Unequip:FireServer()
end

local function Equip(name)
    for _,p in pairs(PetsFolder():GetChildren()) do
        if p.Name == name then
            Remotes.Equip:FireServer(p)
        end
    end
end

local function ShouldSell(pet)
    if Config.IgnoreGiant and pet:FindFirstChild("Giant") then
        return false
    end
    return Config.PetsToSell[pet.Name] == true
end

-- ===== UI =====
local gui = Instance.new("ScreenGui", Player.PlayerGui)
gui.Name = "GrowGardenHub"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,480,0,340)
main.Position = UDim2.new(0.5,-240,0.5,-170)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.Active = true
main.Draggable = true
main.BorderSizePixel = 0

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.Text = "🌱 GROW A GARDEN HUB"
title.TextColor3 = Color3.fromRGB(255,140,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.BackgroundTransparency = 1

-- BOTÃO
local function Button(text,x,y)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0,200,0,35)
    b.Position = UDim2.new(0,x,0,y)
    b.Text = text
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.BackgroundColor3 = Color3.fromRGB(35,35,35)
    b.TextColor3 = Color3.new(1,1,1)
    b.BorderSizePixel = 0
    return b
end

-- INPUT
local function Input(label,x,y,default,callback)
    local l = Instance.new("TextLabel", main)
    l.Text = label
    l.Position = UDim2.new(0,x,0,y)
    l.Size = UDim2.new(0,200,0,20)
    l.TextColor3 = Color3.new(1,1,1)
    l.BackgroundTransparency = 1
    l.TextXAlignment = Left

    local box = Instance.new("TextBox", main)
    box.Text = tostring(default)
    box.Position = UDim2.new(0,x,0,y+20)
    box.Size = UDim2.new(0,200,0,30)
    box.BackgroundColor3 = Color3.fromRGB(30,30,30)
    box.TextColor3 = Color3.new(1,1,1)

    box.FocusLost:Connect(function()
        local v = tonumber(box.Text)
        if v then callback(v) end
    end)
end

-- BOTÕES
local hatchBtn = Button("Auto Hatch [OFF]",20,60)
local openBtn  = Button("Auto Open Egg [OFF]",20,105)
local sellBtn  = Button("Auto Sell [OFF]",20,150)

hatchBtn.MouseButton1Click:Connect(function()
    AutoHatch = not AutoHatch
    hatchBtn.Text = AutoHatch and "Auto Hatch [ON]" or "Auto Hatch [OFF]"
end)

openBtn.MouseButton1Click:Connect(function()
    AutoOpen = not AutoOpen
    openBtn.Text = AutoOpen and "Auto Open Egg [ON]" or "Auto Open Egg [OFF]"
end)

sellBtn.MouseButton1Click:Connect(function()
    AutoSell = not AutoSell
    sellBtn.Text = AutoSell and "Auto Sell [ON]" or "Auto Sell [OFF]"
end)

-- DELAYS
Input("Delay Hatch",250,60,Config.DelayHatch,function(v) Config.DelayHatch=v end)
Input("Delay Open Egg",250,110,Config.DelayOpen,function(v) Config.DelayOpen=v end)
Input("Delay Sell",250,160,Config.DelaySell,function(v) Config.DelaySell=v end)

-- ===== PET SELECT (VENDA) =====
local listY = 210
local used = {}

for _,pet in pairs(PetsFolder():GetChildren()) do
    if not used[pet.Name] then
        used[pet.Name] = true

        local chk = Instance.new("TextButton", main)
        chk.Size = UDim2.new(0,140,0,25)
        chk.Position = UDim2.new(0,20 + (#used%3)*150,0,listY + math.floor(#used/3)*30)
        chk.Text = pet.Name.." [OFF]"
        chk.BackgroundColor3 = Color3.fromRGB(30,30,30)
        chk.TextColor3 = Color3.new(1,1,1)
        chk.BorderSizePixel = 0

        chk.MouseButton1Click:Connect(function()
            Config.PetsToSell[pet.Name] = not Config.PetsToSell[pet.Name]
            chk.Text = pet.Name..(Config.PetsToSell[pet.Name] and " [ON]" or " [OFF]")
        end)
    end
end

-- ===== LOOPS =====
task.spawn(function()
    while true do
        task.wait(Config.DelayHatch)
        if AutoHatch then
            UnequipAll()
            for _,p in pairs(Config.HatchCombo) do Equip(p) end
            Remotes.Hatch:FireServer()
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(Config.DelayOpen)
        if AutoOpen then
            UnequipAll()
            Equip(Config.OpenPet)
            Remotes.OpenEgg:FireServer()
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(Config.DelaySell)
        if AutoSell then
            UnequipAll()
            Equip(Config.SellPet)
            for _,p in pairs(PetsFolder():GetChildren()) do
                if ShouldSell(p) then
                    Remotes.Sell:FireServer(p)
                end
            end
        end
    end
end)
