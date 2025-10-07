-- Подключаем библиотеку DivineZ (ссылка — пример, замени на свою)
local DivineZ = loadstring(game:HttpGet("https://raw.githubusercontent.com/YourRepo/DivineZ/main/DivineZ.lua"))()

-- Локализация (если DivineZ поддерживает, либо своя реализация)
local Localization = {
    Enabled = true,
    Prefix = "loc:",
    DefaultLanguage = "en",
    Translations = {
        en = {
            WINDUI_EXAMPLE = "DivineZ Example",
            WELCOME = "Welcome to DivineZ!",
            LIB_DESC = "Beautiful UI library for Roblox (DivineZ)",
            SETTINGS = "Settings",
            APPEARANCE = "Appearance",
            FEATURES = "Features",
            UTILITIES = "Utilities",
            UI_ELEMENTS = "UI Elements",
            CONFIGURATION = "Configuration",
            SAVE_CONFIG = "Save Configuration",
            LOAD_CONFIG = "Load Configuration",
            THEME_SELECT = "Select Theme",
            TRANSPARENCY = "Window Transparency",
            LOCKED_TAB = "Locked Tab"
        },
        ru = {
            WINDUI_EXAMPLE = "Пример DivineZ",
            WELCOME = "Добро пожаловать в DivineZ!",
            LIB_DESC = "Красивая UI‑библиотека для Roblox (DivineZ)",
            SETTINGS = "Настройки",
            APPEARANCE = "Внешний вид",
            FEATURES = "Функции",
            UTILITIES = "Утилиты",
            UI_ELEMENTS = "Элементы UI",
            CONFIGURATION = "Конфигурация",
            SAVE_CONFIG = "Сохранить конфигурацию",
            LOAD_CONFIG = "Загрузить конфигурацию",
            THEME_SELECT = "Выбрать тему",
            TRANSPARENCY = "Прозрачность окна",
            LOCKED_TAB = "Заблокированная вкладка"
        },
    }
}
-- Функция получения локализованного текста
local function L(key)
    if Localization.Enabled then
        local lang = Localization.DefaultLanguage
        local tbl = Localization.Translations[lang]
        if tbl and tbl[key] then
            return tbl[key]
        end
    end
    return key
end

-- Установка темы (пример)
DivineZ:SetTheme("Dark")

-- Градиентная функция (если в DivineZ можно вставлять RichText / HTML)
local function gradient(text, startColor, endColor)
    local result = ""
    if #text <= 1 then
        return text
    end
    for i = 1, #text do
        local t = (i - 1) / (#text - 1)
        local r = math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255)
        local g = math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255)
        local b = math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255)
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', r, g, b, text:sub(i, i))
    end
    return result
end

-- Пример всплывающего окна
DivineZ:Popup({
    Title = gradient("DivineZ Demo", Color3.fromHex("#6A11CB"), Color3.fromHex("#2575FC")),
    Icon = "sparkles",
    Content = "loc:LIB_DESC",
    Buttons = {
        {
            Title = "Get Started",
            Icon = "arrow-right",
            Variant = "Primary",
            Callback = function()
                -- что делать при нажатии
            end
        }
    }
})

-- Создание окна
local Window = DivineZ:CreateWindow({
    Title = "loc:WINDUI_EXAMPLE",
    Icon = "window_icon",  -- пример
    Author = "loc:WELCOME",
    Folder = "DivineZ_Example",
    Size = UDim2.fromOffset(580, 490),
    Theme = "Dark",
    HidePanelBackground = false,
    Acrylic = false,
    HideSearchBar = false,
    SideBarWidth = 200,
})

-- Настройка окна
Window:SetIconSize(48)

-- Теги окна
Window:Tag({
    Title = "v1.0.0",
    Color = Color3.fromHex("#30ff6a")
})
Window:Tag({
    Title = "Beta",
    Color = Color3.fromHex("#315dff")
})
local TimeTag = Window:Tag({
    Title = "--:--",
    Radius = 0,
    Color = Color3.new(1,1,1)
})

-- Обновление времени и радуги
task.spawn(function()
    local hue = 0
    while true do
        local now = os.date("*t")
        local hours = string.format("%02d", now.hour)
        local mins = string.format("%02d", now.min)
        hue = (hue + 0.01) % 1
        local c = Color3.fromHSV(hue, 1, 1)
        TimeTag:SetTitle(hours .. ":" .. mins)
        -- возможно: TimeTag:SetColor(c)
        task.wait(0.06)
    end
end)

-- Кнопка переключения темы
Window:CreateTopbarButton("theme-switcher", "moon", function()
    local current = DivineZ:GetCurrentTheme()
    local newTheme = (current == "Dark") and "Light" or "Dark"
    DivineZ:SetTheme(newTheme)
    DivineZ:Notify({
        Title = "Theme Changed",
        Content = "Current theme: " .. newTheme,
        Duration = 2
    })
end, 990)

-- Секции и вкладки
local Sections = {
    Main = Window:Section({ Title = "loc:FEATURES", Opened = true }),
    Settings = Window:Section({ Title = "loc:SETTINGS", Opened = true }),
    Utilities = Window:Section({ Title = "loc:UTILITIES", Opened = true }),
}
local Tabs = {
    Elements = Sections.Main:Tab({ Title = "loc:UI_ELEMENTS", Icon = "layout-grid" }),
    Appearance = Sections.Settings:Tab({ Title = "loc:APPEARANCE", Icon = "brush" }),
    Config = Sections.Utilities:Tab({ Title = "loc:CONFIGURATION", Icon = "settings" }),
    Locked1 = Window:Tab({ Title = "loc:LOCKED_TAB", Icon = "lock", Locked = true }),
    Locked2 = Window:Tab({ Title = "loc:LOCKED_TAB", Icon = "lock", Locked = true }),
}

-- Вкладка Elements — примеры элементов
local elSec = Tabs.Elements:Section({
    Title = "Section Example",
    Icon = "star"
})

local toggleState = false
local featureToggle = elSec:Toggle({
    Title = "Enable Features",
    Value = false,
    Callback = function(state)
        toggleState = state
        DivineZ:Notify({
            Title = "Features",
            Content = state and "Enabled" or "Disabled",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

local intensitySlider = elSec:Slider({
    Title = "Effect Intensity",
    Desc = "Adjust strength",
    Value = { Min = 0, Max = 100, Default = 50 },
    Callback = function(v)
        print("Intensity:", v)
    end
})

local dropdownValues = {}
for i = 1, 40 do
    dropdownValues[i] = "Test " .. i
end

elSec:Space()

local testDropdown = elSec:Dropdown({
    Title = "Dropdown test",
    Values = dropdownValues,
    Value = dropdownValues[1],
    Callback = function(opt)
        print("Selected:", opt)
    end
})
testDropdown:Refresh(dropdownValues)

elSec:Divider()

elSec:Button({
    Title = "Show Notification",
    Icon = "bell",
    Callback = function()
        DivineZ:Notify({
            Title = "Hello DivineZ!",
            Content = "This is a sample notification",
            Icon = "bell",
            Duration = 3
        })
    end
})

elSec:Colorpicker({
    Title = "Select Color",
    Default = Color3.fromHex("#30ff6a"),
    Transparency = 0,
    Callback = function(col, tr)
        DivineZ:Notify({
            Title = "Color Changed",
            Content = string.format("New: %s, Transparency: %.2f", col:ToHex(), tr),
            Duration = 2
        })
    end
})

elSec:Code({
    Title = "my_code.lua",
    Code = [[print("Hello world!")]],
    OnCopy = function()
        print("Copied code")
    end
})

-- Вкладка Appearance
Tabs.Appearance:Paragraph({
    Title = "Customize Interface",
    Desc = "Personalize settings",
    Image = "palette",
    ImageSize = 20,
    Color = "White"
})

local themes = {}
for name, _ in pairs(DivineZ:GetThemes()) do
    table.insert(themes, name)
end
table.sort(themes)

local canChangeTheme = true
local themeDropdown = Tabs.Appearance:Dropdown({
    Title = "loc:THEME_SELECT",
    Values = themes,
    SearchBarEnabled = true,
    MenuWidth = 280,
    Value = DivineZ:GetCurrentTheme(),
    Callback = function(theme)
        if canChangeTheme then
            DivineZ:SetTheme(theme)
            DivineZ:Notify({
                Title = "Theme Applied",
                Content = theme,
                Icon = "palette",
                Duration = 2
            })
        end
    end
})

local transparencySlider = Tabs.Appearance:Slider({
    Title = "loc:TRANSPARENCY",
    Value = { Min = 0, Max = 1, Default = 0.2 },
    Step = 0.05,
    Callback = function(val)
        DivineZ.TransparencyValue = val
        Window:ToggleTransparency(val > 0)
    end
})

local themeToggle = Tabs.Appearance:Toggle({
    Title = "Enable Dark Mode",
    Desc = "Switch dark/light",
    Value = (DivineZ:GetCurrentTheme() == "Dark"),
    Callback = function(st)
        if canChangeTheme then
            DivineZ:SetTheme(st and "Dark" or "Light")
        end
    end
})

DivineZ:OnThemeChange(function(newTheme)
    canChangeTheme = false
    themeToggle:Set(newTheme == "Dark")
    canChangeTheme = true
end)

Tabs.Appearance:Button({
    Title = "Create New Theme",
    Icon = "plus",
    Callback = function()
        Window:Dialog({
            Title = "Create Theme",
            Content = "Coming soon!",
            Buttons = {
                { Title = "OK", Variant = "Primary" }
            }
        })
    end
})

-- Вкладка Config
Tabs.Config:Paragraph({
    Title = "Configuration Manager",
    Desc = "Save and load your settings",
    Image = "save",
    ImageSize = 20,
    Color = "White"
})

local configName = "default"
local configFile = nil
local MyPlayerData = {
    name = "Player1",
    level = 1,
    inventory = { "sword", "shield", "potion" }
}

Tabs.Config:Input({
    Title = "Config Name",
    Value = configName,
    Callback = function(val)
        configName = val or "default"
    end
})

-- Предположим, у DivineZ есть ConfigManager
local ConfigManager = Window.ConfigManager
if ConfigManager then
    ConfigManager:Init(Window)

    Tabs.Config:Button({
        Title = "loc:SAVE_CONFIG",
        Icon = "save",
        Variant = "Primary",
        Callback = function()
            configFile = ConfigManager:CreateConfig(configName)
            configFile:Register("featureToggle", featureToggle)
            configFile:Register("intensitySlider", intensitySlider)
            configFile:Register("testDropdown", testDropdown)
            configFile:Register("themeDropdown", themeDropdown)
            configFile:Register("transparencySlider", transparencySlider)
            configFile:Set("playerData", MyPlayerData)
            configFile:Set("lastSave", os.date("%Y-%m-%d %H:%M:%S"))
            if configFile:Save() then
                DivineZ:Notify({
                    Title = "loc:SAVE_CONFIG",
                    Content = "Saved as: " .. configName,
                    Icon = "check",
                    Duration = 3
                })
            else
                DivineZ:Notify({
                    Title = "Error",
                    Content = "Failed saving",
                    Icon = "x",
                    Duration = 3
                })
            end
        end
    })

    Tabs.Config:Button({
        Title = "loc:LOAD_CONFIG",
        Icon = "folder",
        Callback = function()
            configFile = ConfigManager:CreateConfig(configName)
            local loaded = configFile:Load()
            if loaded then
                if loaded.playerData then
                    MyPlayerData = loaded.playerData
                end
                local last = loaded.lastSave or "Unknown"
                DivineZ:Notify({
                    Title = "loc:LOAD_CONFIG",
                    Content = "Loaded: " .. configName .. "\nLast: " .. last,
                    Icon = "refresh-cw",
                    Duration = 5
                })
                Tabs.Config:Paragraph({
                    Title = "Player Data",
                    Desc = string.format("Name: %s\nLevel: %d\nInv: %s",
                        MyPlayerData.name,
                        MyPlayerData.level,
                        table.concat(MyPlayerData.inventory, ", ")
                    )
                })
            else
                DivineZ:Notify({
                    Title = "Error",
                    Content = "Failed loading",
                    Icon = "x",
                    Duration = 3
                })
            end
        end
    })
else
    Tabs.Config:Paragraph({
        Title = "Config Manager Not Available",
        Desc = "Requires ConfigManager",
        Image = "alert-triangle",
        ImageSize = 20,
        Color = "White"
    })
end

-- Footer секция
local footer = Window:Section({ Title = "DivineZ Version" })
Tabs.Config:Paragraph({
    Title = "GitHub Repository",
    Desc = "github.com/YourRepo/DivineZ",
    Image = "github",
    ImageSize = 20,
    Color = "Grey",
    Buttons = {
        {
            Title = "Copy Link",
            Icon = "copy",
            Variant = "Tertiary",
            Callback = function()
                setclipboard("https://github.com/YourRepo/DivineZ")
                DivineZ:Notify({
                    Title = "Copied!",
                    Content = "GitHub link copied",
                    Duration = 2
                })
            end
        }
    }
})

Window:OnClose(function()
    print("Window closed")
    if ConfigManager and configFile then
        configFile:Set("playerData", MyPlayerData)
        configFile:Set("lastSave", os.date("%Y-%m-%d %H:%M:%S"))
        configFile:Save()
        print("Auto‑saved config on close")
    end
end)

Window:OnOpen(function()
    print("Window opened")
end)

-- Расблокировка элементов (если поддерживается)
Window:UnlockAll()

-- Пример печати заблокированных элементов (если DivineZ хранит так)
local unlocked = Window:GetUnlocked and Window:GetUnlocked()
if unlocked and #unlocked > 0 then
    print("Locked elements:")
    for _, elem in ipairs(unlocked) do
        local title = elem.Title
        if string.find(title, Localization.Prefix) then
            local key = title:sub(#Localization.Prefix + 1)
            title = Localization.Translations[Localization.DefaultLanguage][key] or title
        end
        print("- " .. (title or "Unknown"))
    end
end
