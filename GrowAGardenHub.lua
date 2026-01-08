-- =====================================
-- Grow A Garden Hub v2.3
-- Auto Collect (Seguro) + Duplicate Fruit
-- Compatível com DELTA
-- =====================================

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Player = Players.LocalPlayer

pcall(function()
    CoreGui:FindFirstChild("GrowGardenHub"):Destroy()
end)

-- ======================
-- GUI
-- ======================

local Gui = Instance.new("ScreenGui")
Gui.Name = "GrowGardenHub"
Gui.IgnoreGuiInset = true
Gui.ResetOnSpawn = false
Gui.Parent = CoreGui

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 460, 0, 340)
Main.Position = UDim2.new(0.5, -230, 0.5, -170)
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
-- BOTÃO TOGGLE
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

local function CreateButton(text, yPos, callback)
    local btn = Instance.new("TextButton", Content)
    btn.Size = UDim2.new(0, 360, 0, 45)
    btn.Position = UDim2.new(0.5, -180, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = text
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    btn.MouseButton1Click:Connect(callback)
end

-- ======================
-- AUTO COLLECT (SEGURO)
-- ======================

local MAX_DISTANCE = 18

local function isFruitPrompt(prompt)
    local parentName = prompt.Parent.Name:lower()
    local action = (prompt.ActionText or ""):lower()

    if parentName:find("shop") or parentName:find("npc") then return false end
    if action:find("harvest") or action:find("collect") or action:find("pick") then
        return true
    end
    if parentName:find("fruit") then return true end
    return false
end

task.spawn(function()
    while task.wait(0.4) do
        if not States.AutoCollect then continue end

        local char = Player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") and v.Enabled then
                local part = v.Parent:IsA("BasePart") and v.Parent
                if part then
                    local dist = (part.Position - hrp.Position).Magnitude
                    if dist <= MAX_DISTANCE and isFruitPrompt(v) then
                        pcall(function()
                            fireproximityprompt(v)
                        end)
                    end
                end
            end
        end
    end
end)

-- ======================
-- DUPLICAR FRUTA NA MÃO
-- ======================

local function DuplicateHeldFruit()
    local char = Player.Character
    if not char then return end

    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then
        warn("Nenhuma fruta equipada")
        return
    end

    local clone = tool:Clone()
    clone.Parent = Player.Backpack

    print("Fruta duplicada:", tool.Name)
end

-- ======================
-- BOTÕES
-- ======================

CreateToggle("Auto Collect Fruits", 30, function()
    States.AutoCollect = not States.AutoCollect
    return States.AutoCollect
end)

CreateButton("Duplicate Held Fruit", 90, function()
    DuplicateHeldFruit()
end)

-- Info
local Info = Instance.new("TextLabel", Content)
Info.Size = UDim2.new(1, -40, 0, 120)
Info.Position = UDim2.new(0, 20, 0, 150)
Info.BackgroundTransparency = 1
Info.TextWrapped = true
Info.Text = "✔ Auto Collect filtrado\n✔ Duplicar fruta equipada\n⚠️ Dup pode ser local (depende do jogo)"
Info.Font = Enum.Font.Gotham
Info.TextSize = 12
Info.TextColor3 = Color3.fromRGB(180, 180, 180)

print("Grow A Garden Hub v2.3 carregado com sucesso")    btn.BorderSizePixel = 0
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
