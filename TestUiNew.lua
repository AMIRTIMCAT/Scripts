--link:https://brady-xyz.gitbook.io/maclib-ui-library
local MacLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/biggaboy212/Public-Resources/main/MacLib/maclib.lua"))() MacLib:Demo()

local Window = MacLib:Window({
    Title = "FluxusZ Hub",
    Subtitle = "Freemuim | V1.00",
    Size = UDim2.fromOffset(868, 650),
    DragStyle = 1,
    DisabledWindowControls = {},
    ShowUserInfo = true,
    Keybind = Enum.KeyCode.RightControl,
    AcrylicBlur = true,
})
