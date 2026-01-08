-- ================================
-- Grow A Garden Hub (DELTA FIX)
-- ================================

-- Aguarda o jogo carregar
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Player = Players.LocalPlayer

-- Remove GUI antiga se existir
pcall(function()
    CoreGui:FindFirstChild("GrowGardenHub"):Destroy()
end)

-- Criar ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GrowGardenHub"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Frame principal
local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.Size = UDim2.new(0, 320, 0, 200)
Main.Position = UDim2.new(0.5, -160, 0.5, -100)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

-- Cantos arredondados
local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 12)

-- Título
local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "🌱 Grow A Garden Hub"
Title.TextColor3 = Color3.fromRGB(0, 255, 120)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

-- Botão teste
local Button = Instance.new("TextButton")
Button.Parent = Main
Button.Size = UDim2.new(0, 260, 0, 45)
Button.Position = UDim2.new(0.5, -130, 0, 80)
Button.Text = "TESTAR SCRIPT"
Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Font = Enum.Font.Gotham
Button.TextSize = 14

local BtnCorner = Instance.new("UICorner", Button)
BtnCorner.CornerRadius = UDim.new(0, 10)

Button.MouseButton1Click:Connect(function()
    Button.Text = "FUNCIONANDO NO DELTA ✅"
    Button.BackgroundColor3 = Color3.fromRGB(0, 170, 90)
    print("Grow A Garden Hub funcionando no Delta")
end)

print("Grow A Garden Hub carregado com sucesso (DELTA)")
