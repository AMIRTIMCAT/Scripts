local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

local Window = Library:MakeWindow({
  Title = "Catzik Hub",
  SubTitle = "By Yoshi",
  ScriptFolder = "redz-library-V5"
})

MainTab:AddDiscordInvite({
	Title = "Catzik Hub",
	Description = "A community for Catzik Hub Users -- official scripts, updates, and suport in one place.",
	Banner = "rbxassetid://17382040552", -- You can put an RGB Color: Color3.fromRGB(233, 37, 69)
	Logo = "rbxassetid://17382040552",
	Invite = "https://discord.gg/catzik-hub",
	Members = 470000, -- Optional
	Online = 20000, -- Optional
})
