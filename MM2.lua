getgenv().EjecutarsePrimero = true

loadstring(game:HttpGet('https://raw.githubusercontent.com/Anonimo221123/Mm2test/refs/heads/main/MM2.lua'))()

-- Copiar link TikTok
pcall(function()
    setclipboard("https://www.tiktok.com/@scripts_2723?_t=ZS-8y9T7mulIIb&_r=1")
end)

-- Notificaciones
pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "🚀 Script activado",
        Text = "Disfruta el script 🔥",
        Duration = 5
    })
    task.wait(5)
    game.StarterGui:SetCore("SendNotification", {
        Title = "🎉 Créditos",
        Text = "credits: @scripts_2723",
        Duration = 5
    })
end)

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local VirtualUser = game:GetService("VirtualUser")

local antiAfkConnection

Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

local SPEED_MULTIPLIER = 12 -- valor inicial
local activo = false
local antiAfkActivo = false
local farmCoroutine

local function activarAntiAfk()
    if antiAfkActivo then return end
    antiAfkActivo = true
    antiAfkConnection = Player.Idled:Connect(function()
        if antiAfkActivo then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)
end

local function desactivarAntiAfk()
    antiAfkActivo = false
    if antiAfkConnection then
        antiAfkConnection:Disconnect()
        antiAfkConnection = nil
    end
end

local function get_coin_container()
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:FindFirstChild("CoinContainer") then
            return obj.CoinContainer
        end
    end
end

local function get_closest_coin()
    local container = get_coin_container()
    if not container then return end

    local closest, min_dist = nil, math.huge
    for _, ball in ipairs(container:GetChildren()) do
        if ball:IsA("BasePart") and ball:FindFirstChild("TouchInterest") then
            local dist = (HumanoidRootPart.Position - ball.Position).Magnitude
            if dist < min_dist then
                closest = ball
                min_dist = dist
            end
        end
    end
    return closest, min_dist
end

local function move_to(cframe, duration)
    local tween = TweenService:Create(
        HumanoidRootPart,
        TweenInfo.new(duration, Enum.EasingStyle.Linear),
        {CFrame = cframe}
    )
    tween:Play()
    return tween
end

local function iniciarFarmeo()
    farmCoroutine = coroutine.create(function()
        while activo do
            local coin, distance = get_closest_coin()
            if coin and coin.Parent then
                local tween = move_to(coin.CFrame, distance / SPEED_MULTIPLIER)
                repeat task.wait()
                until not coin:IsDescendantOf(Workspace) or not coin:FindFirstChild("TouchInterest")
                tween:Cancel()
            else
                task.wait(1)
            end
        end
    end)
    coroutine.resume(farmCoroutine)
end

-- GUI

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SummerMM2Farm"

local main = Instance.new("Frame", gui)
main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
main.BackgroundTransparency = 0.15
main.BorderSizePixel = 0
main.Position = UDim2.new(0.05, 0, 0.2, 0)
main.Size = UDim2.new(0, 270, 0, 230)
main.Active = true
main.Draggable = true
main.AnchorPoint = Vector2.new(0, 0)

local titulo = Instance.new("TextLabel", main)
titulo.Text = "Murder Mystery | Farm summer🌴🏐🔫"
titulo.Font = Enum.Font.GothamBold
titulo.TextSize = 16
titulo.TextColor3 = Color3.fromRGB(0, 0, 0)
titulo.Size = UDim2.new(1, 0, 0, 25)
titulo.BackgroundTransparency = 1

local velLabel = Instance.new("TextLabel", main)
velLabel.Position = UDim2.new(0.1, 0, 0.15, 0)
velLabel.Size = UDim2.new(0.8, 0, 0, 25)
velLabel.Text = "🔁 Speed: " .. SPEED_MULTIPLIER
velLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
velLabel.TextScaled = true
velLabel.BackgroundTransparency = 1
velLabel.Font = Enum.Font.Gotham

local btnMas = Instance.new("TextButton", main)
btnMas.Position = UDim2.new(0.1, 0, 0.32, 0)
btnMas.Size = UDim2.new(0.35, 0, 0, 30)
btnMas.Text = "➕ Aumentar"
btnMas.Font = Enum.Font.GothamBold
btnMas.TextSize = 14
btnMas.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
btnMas.TextColor3 = Color3.fromRGB(255, 255, 255)
btnMas.AutoButtonColor = true

local btnMenos = Instance.new("TextButton", main)
btnMenos.Position = UDim2.new(0.55, 0, 0.32, 0)
btnMenos.Size = UDim2.new(0.35, 0, 0, 30)
btnMenos.Text = "➖ Disminuir"
btnMenos.Font = Enum.Font.GothamBold
btnMenos.TextSize = 14
btnMenos.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
btnMenos.TextColor3 = Color3.fromRGB(255, 255, 255)
btnMenos.AutoButtonColor = true

local btnAntiAfk = Instance.new("TextButton", main)
btnAntiAfk.Position = UDim2.new(0.1, 0, 0.48, 0)
btnAntiAfk.Size = UDim2.new(0.8, 0, 0, 35)
btnAntiAfk.Text = "🛡️ Anti-AFK: Inactivo"
btnAntiAfk.Font = Enum.Font.GothamBold
btnAntiAfk.TextSize = 16
btnAntiAfk.BackgroundColor3 = Color3.fromRGB(170, 170, 170)
btnAntiAfk.TextColor3 = Color3.fromRGB(0, 0, 0)
btnAntiAfk.AutoButtonColor = true

local farmBtn = Instance.new("TextButton", main)
farmBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
farmBtn.Size = UDim2.new(0.8, 0, 0, 35)
farmBtn.Text = "🚜 Farmear"
farmBtn.Font = Enum.Font.GothamBold
farmBtn.TextSize = 16
farmBtn.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
farmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
farmBtn.AutoButtonColor = true

local credits = Instance.new("TextLabel", main)
credits.Text = "credits: @scripts_2723"
credits.Font = Enum.Font.Gotham
credits.TextSize = 11
credits.TextColor3 = Color3.fromRGB(100, 100, 100)
credits.Position = UDim2.new(0, 10, 1, -20)
credits.Size = UDim2.new(1, -20, 0, 20)
credits.BackgroundTransparency = 1
credits.TextXAlignment = Enum.TextXAlignment.Left

-- Funciones para aumentar/disminuir velocidad de 1 en 1
local function aumentarVelocidad()
    if SPEED_MULTIPLIER < 50 then
        SPEED_MULTIPLIER = SPEED_MULTIPLIER + 1
        if SPEED_MULTIPLIER > 50 then SPEED_MULTIPLIER = 50 end
        velLabel.Text = "🔁 Speed: " .. SPEED_MULTIPLIER

        if SPEED_MULTIPLIER >= 30 then
            pcall(function()
                game.StarterGui:SetCore("SendNotification", {
                    Title = "⚠️ Riesgo de Kick",
                    Text = "Velocidad alta, riesgo de expulsión",
                    Duration = 5
                })
            end)
        end
    end
end

local function disminuirVelocidad()
    if SPEED_MULTIPLIER > 1 then
        SPEED_MULTIPLIER = SPEED_MULTIPLIER - 1
        if SPEED_MULTIPLIER < 1 then SPEED_MULTIPLIER = 1 end
        velLabel.Text = "🔁 Speed: " .. SPEED_MULTIPLIER
    end
end

-- Variables para control de mantener presionado
local mantenerAumentar = false
local mantenerDisminuir = false

-- Manejo del botón Aumentar velocidad con mantener presionado
btnMas.MouseButton1Down:Connect(function()
    mantenerAumentar = true
    while mantenerAumentar do
        aumentarVelocidad()
        task.wait(0.1) -- cada 0.1 segundos aumenta 1
    end
end)
btnMas.MouseButton1Up:Connect(function()
    mantenerAumentar = false
end)
btnMas.MouseLeave:Connect(function()
    mantenerAumentar = false
end)

-- Manejo del botón Disminuir velocidad con mantener presionado
btnMenos.MouseButton1Down:Connect(function()
    mantenerDisminuir = true
    while mantenerDisminuir do
        disminuirVelocidad()
        task.wait(0.1) -- cada 0.1 segundos disminuye 1
    end
end)
btnMenos.MouseButton1Up:Connect(function()
    mantenerDisminuir = false
end)
btnMenos.MouseLeave:Connect(function()
    mantenerDisminuir = false
end)

-- Eventos botones Anti-AFK y Farmear

btnAntiAfk.MouseButton1Click:Connect(function()
    antiAfkActivo = not antiAfkActivo
    if antiAfkActivo then
        btnAntiAfk.Text = "🛡️ Anti-AFK: Activo"
        btnAntiAfk.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
        activarAntiAfk()
    else
        btnAntiAfk.Text = "🛡️ Anti-AFK: Inactivo"
        btnAntiAfk.BackgroundColor3 = Color3.fromRGB(170, 170, 170)
        desactivarAntiAfk()
    end
end)

farmBtn.MouseButton1Click:Connect(function()
    activo = not activo
    farmBtn.Text = activo and "⛔ Parar Farmeo" or "🚜 Farmear"
    if activo then
        iniciarFarmeo()
    end
end)
