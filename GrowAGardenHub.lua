--==============================
-- GROW A GARDEN HUB (DELTA FIX)
--==============================

-- Aguarda jogo carregar
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
repeat task.wait() until Player

--==============================
-- CONFIG
--==============================
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

local AutoHatch = false
local AutoOpen = false
local AutoSell = false

--==============================
-- REMOTES (AJUSTE SE PRECISAR)
--==============================
local RemotesFolder = ReplicatedStorage:WaitForChild("Remotes", 10)
if not RemotesFolder then
    warn("❌ Pasta Remotes não encontrada")
    return
end

local Remotes = {
    Equip = RemotesFolder:WaitForChild("EquipPet"),
    Unequip = RemotesFolder:WaitForChild("UnequipAll"),
    Hatch = RemotesFolder:WaitForChild("HatchEgg"),
    Open = RemotesFolder:WaitForChild("OpenEgg"),
    Sell = RemotesFolder:WaitForChild("SellPet")
}

--==============================
-- FUNÇÕES
--==============================
local function PetsFolder()
    return Player:WaitForChild("Pets")
end

local function UnequipAll()
    pcall(function()
        Remotes.Unequip:FireServer()
    end)
end

local function EquipPet(name)
    for _,pet in pairs(PetsFolder():GetChildren()) do
        if pet.Name == name then
            pcall(function()
                Remotes.Equip:FireServer(pet)
            end)
        end
    end
end

local function ShouldSell(pet)
    if Config.IgnoreGiant and pet:FindFirstChild("Giant") then
        return false
    end
    return Config.PetsToSell[pet.Name] == true
end

--==============================
-- UI (COREGUI – DELTA FIX)
--==============================
pcall(function()
    if CoreGui:FindFirstChild("GrowGardenHub") then
        CoreGui.GrowGardenHub:Destroy()
    end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "GrowGardenHub"
gui.Parent = CoreGui

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 480, 0, 350)
main.Position = UDim2.new(0.5, -240, 0.5, -175)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "🌱 GROW A GARDEN HUB"
title.TextColor3 = Color3.fromRGB(255,140,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 22

--==============================
-- UI HELPERS
--==============================
local function Button(text, x, y)
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

local function Input(label, x, y, default, callback)
    local l = Instance.new("TextLabel", main)
    l.Text = label
    l.Position = UDim2.new(0,x,0,y)
    l.Size = UDim2.new(0,200,0,20)
    l.TextColor3 = Color3.new(1,1,1)
    l.BackgroundTransparency = 1
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Font = Enum.Font.Gotham
    l.TextSize = 13

    local box = Instance.new("TextBox", main)
    box.Text = tostring(default)
    box.Position = UDim2.new(0,x,0,y+20)
    box.Size = UDim2.new(0,200,0,30)
    box.BackgroundColor3 = Color3.fromRGB(30,30,30)
    box.TextColor3 = Color3.new(1,1,1)
    box.ClearTextOnFocus = false

    box.FocusLost:Connect(function()
        local v = tonumber(box.Text)
        if v then
            callback(v)
        end
    end)
end

--==============================
-- BOTÕES
--==============================
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

--==============================
-- DELAYS
--==============================
Input("Delay Hatch",250,60,Config.DelayHatch,function(v) Config.DelayHatch=v end)
Input("Delay Open Egg",250,110,Config.DelayOpen,function(v) Config.DelayOpen=v end)
Input("Delay Sell",250,160,Config.DelaySell,function(v) Config.DelaySell=v end)

--==============================
-- SELEÇÃO DE PETS PARA VENDER
--==============================
local used = {}
local startY = 210
local col = 0
local row = 0

for _,pet in pairs(PetsFolder():GetChildren()) do
    if not used[pet.Name] then
        used[pet.Name] = true

        local chk = Instance.new("TextButton", main)
        chk.Size = UDim2.new(0,140,0,25)
        chk.Position = UDim2.new(0,20 + (col*150),0,startY + (row*30))
        chk.Text = pet.Name.." [OFF]"
        chk.BackgroundColor3 = Color3.fromRGB(30,30,30)
        chk.TextColor3 = Color3.new(1,1,1)
        chk.BorderSizePixel = 0
        chk.Font = Enum.Font.Gotham
        chk.TextSize = 12

        chk.MouseButton1Click:Connect(function()
            Config.PetsToSell[pet.Name] = not Config.PetsToSell[pet.Name]
            chk.Text = pet.Name .. (Config.PetsToSell[pet.Name] and " [ON]" or " [OFF]")
        end)

        col += 1
        if col >= 3 then
            col = 0
            row += 1
        end
    end
end

--==============================
-- LOOPS
--==============================
task.spawn(function()
    while task.wait(Config.DelayHatch) do
        if AutoHatch then
            UnequipAll()
            for _,p in pairs(Config.HatchCombo) do
                EquipPet(p)
            end
            pcall(function()
                Remotes.Hatch:FireServer()
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(Config.DelayOpen) do
        if AutoOpen then
            UnequipAll()
            EquipPet(Config.OpenPet)
            pcall(function()
                Remotes.Open:FireServer()
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(Config.DelaySell) do
        if AutoSell then
            UnequipAll()
            EquipPet(Config.SellPet)

            for _,pet in pairs(PetsFolder():GetChildren()) do
                if ShouldSell(pet) then
                    pcall(function()
                        Remotes.Sell:FireServer(pet)
                    end)
                end
            end
        end
    end
end)

print("✅ Grow A Garden Hub carregado com sucesso (DELTA)")
