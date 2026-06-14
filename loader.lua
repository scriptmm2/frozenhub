--==================================================================
--  💎 AUTH GUI — IP WHITELIST EDITION (blue theme + sounds + animations)
--==================================================================

-- ⚙️ НАСТРОЙКИ
local Settings = {
    Title    = "Authorization",
    SubTitle = "IP Whitelist Access",
    YourLink = "https://твоя-ссылка.com/whitelist", -- ссылка, которая вайтлистит IP
    -- Эндпоинт проверки: должен вернуть "true"/"ok" если IP юзера в вайтлисте
    CheckURL = "https://твой-сервер.com/check", -- проверка по IP
    -- Звуки (можешь заменить на свои assetId)
    SoundClick   = "rbxassetid://6042053626",
    SoundSuccess = "rbxassetid://9120386436",
    SoundError   = "rbxassetid://9118823106",
}

--==================================================================
local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local plr          = Players.LocalPlayer

-- helper: звук
local function playSound(id)
    local s = Instance.new("Sound")
    s.SoundId = id
    s.Volume = 1
    s.Parent = game:GetService("SoundService")
    s:Play()
    s.Ended:Connect(function() s:Destroy() end)
    task.delay(5, function() if s then s:Destroy() end end)
end

-- helper: проверка IP-вайтлиста через твой сервер
local function isWhitelisted()
    local ok, res = pcall(function()
        return game:HttpGet(Settings.CheckURL)
    end)
    if ok and res then
        res = res:lower():gsub("%s+", "")
        return res == "true" or res == "ok" or res == "1" or res == "valid"
    end
    return false
end

-- что запускается после успешной авторизации
local function runMainScript()
    game.StarterGui:SetCore("SendNotification", {
        Title = "✅ Авторизация успешна",
        Text  = "Скрипт активирован!",
        Duration = 5,
    })
    -- 🔻 ТВОЙ ОСНОВНОЙ СКРИПТ СЮДА 🔻
    -- loadstring(game:HttpGet("https://твой-сервер.com/main.lua"))()
end

--==================================================================
-- 🎨 ИНТЕРФЕЙС
local gui = Instance.new("ScreenGui")
gui.Name = "AuthGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = plr:WaitForChild("PlayerGui")

-- основная панель
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 380, 0, 250)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(15, 22, 40)
frame.BackgroundTransparency = 1 -- для появления
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
--==================================================================
-- ❄️ БРЕНДИНГ "Frozen" в углу
--==================================================================
local brand = Instance.new("TextLabel")
brand.Name = "Brand"
brand.Size = UDim2.new(0, 110, 0, 24)
brand.Position = UDim2.new(1, -118, 0, 8)   -- правый верхний угол
brand.AnchorPoint = Vector2.new(0, 0)
brand.BackgroundTransparency = 1
brand.Text = "❄️ Frozen"
brand.TextColor3 = Color3.fromRGB(140, 210, 255)
brand.TextXAlignment = Enum.TextXAlignment.Right
brand.Font = Enum.Font.GothamBold
brand.TextSize = 16
brand.TextTransparency = 1   -- появится вместе с панелью
brand.Parent = frame

-- лёгкое мерцание снежинки
task.spawn(function()
    while brand and brand.Parent do
        TweenService:Create(brand, TweenInfo.new(1), {TextColor3 = Color3.fromRGB(200, 240, 255)}):Play()
        task.wait(1)
        TweenService:Create(brand, TweenInfo.new(1), {TextColor3 = Color3.fromRGB(120, 190, 255)}):Play()
        task.wait(1)
    end
end)

-- голубой градиент фона
local grad = Instance.new("UIGradient", frame)
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 28, 55)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 18, 35)),
})
grad.Rotation = 90

-- светящаяся рамка
local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(70, 160, 255)
stroke.Thickness = 1.8
stroke.Transparency = 1

-- заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 22)
title.BackgroundTransparency = 1
title.Text = Settings.Title
title.TextColor3 = Color3.fromRGB(120, 200, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 26
title.TextTransparency = 1
title.Parent = frame

local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(1, 0, 0, 20)
sub.Position = UDim2.new(0, 0, 0, 60)
sub.BackgroundTransparency = 1
sub.Text = Settings.SubTitle
sub.TextColor3 = Color3.fromRGB(110, 130, 170)
sub.Font = Enum.Font.Gotham
sub.TextSize = 14
sub.TextTransparency = 1
sub.Parent = frame

-- статус
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -40, 0, 22)
status.Position = UDim2.new(0, 20, 0, 96)
status.BackgroundTransparency = 1
status.Text = "Статус: ожидание авторизации"
status.TextColor3 = Color3.fromRGB(150, 170, 200)
status.Font = Enum.Font.Gotham
status.TextSize = 13
status.TextTransparency = 1
status.Parent = frame

-- функция создания кнопки
local function makeButton(text, posY, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -50, 0, 42)
    btn.Position = UDim2.new(0, 25, 0, posY)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = color
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 16
    btn.AutoButtonColor = false
    btn.BackgroundTransparency = 1
    btn.TextTransparency = 1
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    -- hover-эффект
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            Size = UDim2.new(1, -42, 0, 44)
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            Size = UDim2.new(1, -50, 0, 42)
        }):Play()
    end)
    return btn
end

local getBtn  = makeButton("🔗 Получить доступ", 130, Color3.fromRGB(40, 110, 230))
local authBtn = makeButton("✅ Авторизоваться", 184, Color3.fromRGB(30, 140, 220))

--==================================================================
-- ✨ АНИМАЦИЯ ПОЯВЛЕНИЯ (плавное расширение из точки)
--==================================================================
-- стартовое состояние: крошечная панель в центре
frame.Size = UDim2.new(0, 0, 0, 0)
frame.BackgroundTransparency = 1

-- этап 1: расширение по ширине (тонкая полоска)
local expandWidth = TweenService:Create(
    frame,
    TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    {
        Size = UDim2.new(0, 380, 0, 4),
        BackgroundTransparency = 0,
    }
)

-- этап 2: раскрытие по высоте (с лёгким bounce)
local expandHeight = TweenService:Create(
    frame,
    TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {
        Size = UDim2.new(0, 380, 0, 250),
    }
)

playSound(Settings.SoundClick)

expandWidth:Play()
expandWidth.Completed:Connect(function()
    expandHeight:Play()
end)

-- содержимое появляется только после полного раскрытия
expandHeight.Completed:Connect(function()
    for _, obj in ipairs({title, sub, status, stroke, brand}) do
        local prop = obj:IsA("UIStroke") and {Transparency = 0} or {TextTransparency = 0}
        TweenService:Create(obj, TweenInfo.new(0.4), prop):Play()
    end
    for _, b in ipairs({getBtn, authBtn}) do
        TweenService:Create(b, TweenInfo.new(0.4), {BackgroundTransparency = 0, TextTransparency = 0}):Play()
    end
end)
-- 🎮 ЛОГИКА
getBtn.MouseButton1Click:Connect(function()
    playSound(Settings.SoundClick)
    if setclipboard then
        setclipboard(Settings.YourLink)
        status.Text = "Ссылка скопирована — пройди по ней, чтобы добавить свой IP"
        status.TextColor3 = Color3.fromRGB(120, 200, 255)
    else
        status.Text = Settings.YourLink
    end
end)

authBtn.MouseButton1Click:Connect(function()
    playSound(Settings.SoundClick)
    status.Text = "Проверяю IP..."
    status.TextColor3 = Color3.fromRGB(150, 200, 255)
    task.wait(0.4)

    if isWhitelisted() then
        playSound(Settings.SoundSuccess)
        status.Text = "✅ IP в вайтлисте — доступ разрешён"
        status.TextColor3 = Color3.fromRGB(80, 230, 140)
        authBtn.Text = "✅ Успешно"
        TweenService:Create(authBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(45, 190, 110)}):Play()
        task.wait(0.8)
        -- закрытие с анимацией
        local close = TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 380, 0, 0),
            BackgroundTransparency = 1,
        })
        close:Play()
        close.Completed:Connect(function()
            gui:Destroy()
            runMainScript()
        end)
    else
        playSound(Settings.SoundError)
        status.Text = "❌ IP не найден в вайтлисте. Пройди по ссылке."
        status.TextColor3 = Color3.fromRGB(255, 90, 90)
        -- shake-эффект
        for i = 1, 4 do
            frame.Position = UDim2.new(0.5, (i % 2 == 0 and 6 or -6), 0.5, 0)
            task.wait(0.04)
        end
        frame.Position = UDim2.new(0.5, 0, 0.5, 0)
        TweenService:Create(authBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(200, 60, 60)}):Play()
        task.wait(1.2)
        authBtn.Text = "✅ Авторизоваться"
        TweenService:Create(authBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 140, 220)}):Play()
    end
end)
