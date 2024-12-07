local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo..'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local Options = Library.Options
local Toggles = Library.Toggles
--//
if game.GameId == 3937036363 then 
    Library:Notify("Busy Business Loader - Loading Script...", nil, 4590657391)
    wait(1)
    Library:Notify("Busy Business Loader - Loaded Script....", nil, 4590657391)
    wait(1)
    Library:Notify("Busy Business Loader - Finished Loading", nil, 4590657391)
    wait(1)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/codedev9/BusyBusiness/refs/heads/main/script.lua"))()
else
    Library:Notify("Busy Business Loader - Game not supported.", nil, 4590657391)
    return
end