local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

local Window = Library:MakeWindow({
  Title = "My Cool Hub",
  SubTitle = "by me",
  ScriptFolder = "my-scripts"
})

local Tab = Window:MakeTab({
  Title = "Main",
  Icon = "Home"
})

Tab:AddButton({
  Name = "Click Me!",
  Callback = function()
    print("Button clicked!")
    Window:Notify({
      Title = "Hello!",
      Content = "You clicked the button!",
      Duration = 3
    })
  end
})
