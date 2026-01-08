-- =====================================
-- Grow A Garden Hub v2.1
-- UI Completa + Auto Collect Fruits
-- Compatível com DELTA
-- =====================================

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Player = Players.LocalPlayer

-- Remove GUI antiga
pcall(function()
    CoreGui:FindFirstChild("GrowGardenHub"):Destroy()
end)

-- ======================
-- GUI BASE
-- ======================

local Gui = Instance.new("ScreenGui")
Gui.Name = "GrowGardenHub"
Gui.IgnoreGuiInset = true
Gui.ResetOnSpawn = false
Gui.Parent = CoreGui

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 460, 0, 320)
Main.Position = UDim2.new(0.5, -230, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "🌱 Grow A Garden Hub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(0, 255, 120)

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, 0, 1, -45)
Content.Position = UDim2.new(0, 0, 0, 45)
Content.BackgroundTransparency = 1

-- ======================
-- ESTADOS
-- ======================

local States = {
    AutoCollect = false
}

-- ======================
-- FUNÇÃO BOTÃO TOGGLE
-- ======================

local function CreateToggle(text, yPos, callback)
    local btn = Instance.new("TextButton", Content)
    btn.Size = UDim2.new(0, 360, 0, 45)
    btn.Position = UDim2.new(0.5, -180, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = text .. ": OFF"
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    btn.MouseButton1Click:Connect(function()
        local state = callback()
        btn.Text = text .. (state and ": ON" or ": OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0,170,90) or Color3.fromRGB(45,45,45)
    end)
end

-- ======================
-- AUTO COLLECT FRUITS
-- ======================

task.spawn(function()
    while task.wait(0.5) do
        if not States.AutoCollect then
            continue
        end

        local char = Player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        for _, v in pairs(workspace:GetDescendants()) do
            -- ProximityPrompt (principal)
            if v:IsA("ProximityPrompt") and v.Enabled then
                pcall(function()
                    fireproximityprompt(v)
                end)
            end

            -- Touch (fallback)
            if v:IsA("BasePart") and v.Name:lower():find("fruit") then
                pcall(function()
                    firetouchinterest(hrp, v, 0)
                    firetouchinterest(hrp, v, 1)
                end)
            end
        end
    end
end)

-- ======================
-- BOTÃO
-- ======================

CreateToggle("Auto Collect Fruits", 40, function()
    States.AutoCollect = not States.AutoCollect
    print("Auto Collect Fruits:", States.AutoCollect)
    return States.AutoCollect
end)

-- Info
local Info = Instance.new("TextLabel", Content)
Info.Size = UDim2.new(1, -40, 0, 60)
Info.Position = UDim2.new(0, 20, 0, 100)
Info.BackgroundTransparency = 1
Info.TextWrapped = true
Info.Text = "✔ Coleta automática de frutas\n✔ Qualquer fruta disponível\n⚠️ Sistema simples (v2.1)"
Info.Font = Enum.Font.Gotham
Info.TextSize = 12
Info.TextColor3 = Color3.fromRGB(180, 180, 180)

print("Grow A Garden Hub v2.1 carregado com sucesso (DELTA)")
