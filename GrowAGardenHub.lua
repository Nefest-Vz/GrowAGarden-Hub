-- =====================================
-- Grow A Garden Hub v1.0 (UI COMPLETA)
-- Compatível com DELTA
-- =====================================

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local CoreGui = game:GetService("CoreGui")

pcall(function()
    CoreGui:FindFirstChild("GrowGardenHub"):Destroy()
end)

-- ScreenGui
local Gui = Instance.new("ScreenGui")
Gui.Name = "GrowGardenHub"
Gui.IgnoreGuiInset = true
Gui.ResetOnSpawn = false
Gui.Parent = CoreGui

-- Main Frame
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 460, 0, 300)
Main.Position = UDim2.new(0.5, -230, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true
Main.BorderSizePixel = 0

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

-- Title
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "🌱 Grow A Garden Hub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(0, 255, 120)

-- Sidebar
local Side = Instance.new("Frame", Main)
Side.Size = UDim2.new(0, 140, 1, -45)
Side.Position = UDim2.new(0, 0, 0, 45)
Side.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Side.BorderSizePixel = 0

-- Content
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -140, 1, -45)
Content.Position = UDim2.new(0, 140, 0, 45)
Content.BackgroundTransparency = 1

-- Estado dos sistemas
local States = {
    AutoHatch = false,
    AutoSell = false,
    AutoOpen = false
}

-- Função botão toggle
local function CreateToggle(text, yPos, callback)
    local btn = Instance.new("TextButton", Content)
    btn.Size = UDim2.new(0, 260, 0, 45)
    btn.Position = UDim2.new(0.5, -130, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = text .. ": OFF"

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    btn.MouseButton1Click:Connect(function()
        local state = callback()
        btn.Text = text .. (state and ": ON" or ": OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0,170,90) or Color3.fromRGB(45,45,45)
    end)
end

-- Criar Toggles
CreateToggle("Auto Hatch", 20, function()
    States.AutoHatch = not States.AutoHatch
    print("Auto Hatch:", States.AutoHatch)
    return States.AutoHatch
end)

CreateToggle("Auto Open Eggs", 80, function()
    States.AutoOpen = not States.AutoOpen
    print("Auto Open:", States.AutoOpen)
    return States.AutoOpen
end)

CreateToggle("Auto Sell Pets", 140, function()
    States.AutoSell = not States.AutoSell
    print("Auto Sell:", States.AutoSell)
    return States.AutoSell
end)

-- Info
local Info = Instance.new("TextLabel", Content)
Info.Size = UDim2.new(1, -40, 0, 40)
Info.Position = UDim2.new(0, 20, 0, 210)
Info.BackgroundTransparency = 1
Info.TextWrapped = true
Info.Text = "⚠️ Funções visuais prontas.\nLógica do jogo entra na próxima versão."
Info.Font = Enum.Font.Gotham
Info.TextSize = 12
Info.TextColor3 = Color3.fromRGB(180, 180, 180)

print("Grow A Garden Hub v1.0 carregado (UI COMPLETA)")
