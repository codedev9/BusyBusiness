local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local Options = Library.Options
local Toggles = Library.Toggles
local PLAYER_PLOT
for i, v in workspace.Plots:GetChildren() do
	if v.Owner.Value == game.Players.LocalPlayer then 
		PLAYER_PLOT = v
	end
end
local Script = {
	["Remotes"] = {
		["UseMachine"] = game:GetService("ReplicatedStorage").Communication.UseMachine,
		["CustomerOrder"] = game:GetService("ReplicatedStorage").Communication.CustomerOrder,
		["ServeCustomer"] = game:GetService("ReplicatedStorage").Communication.ServeCustomer,
		["UpgradeMachine"] = game:GetService("ReplicatedStorage").Communication.UpgradeMachine,
		["UseTrash"] = game:GetService("ReplicatedStorage").Communication.UseTrash
	},
	["Variables"] = {
		["PLAYER_PLOT"] = PLAYER_PLOT,
		["LocalPlayer"] = game.Players.LocalPlayer
	},
	["Business"] = {
		["Customers"] = PLAYER_PLOT.Customers,
		["Objects"] = PLAYER_PLOT.Objects
	}
}
local useMachine = game:GetService("ReplicatedStorage").Communication.UseMachine
local orderCustomer = game:GetService("ReplicatedStorage").Communication.CustomerOrder
local serveCustomer = game:GetService("ReplicatedStorage").Communication.ServeCustomer
local upgradeMachine = game:GetService("ReplicatedStorage").Communication.UpgradeMachine
--// test library
Library.ShowToggleFrameInKeybinds = true -- Make toggle keybinds work inside the keybinds UI (aka adds a toggle to the UI). Good for mobile users (Default value = true)
Library.ShowCustomCursor = true -- Toggles the Linoria cursor globaly (Default value = true)
Library.NotifySide = "Left" -- Changes the side of the notifications globaly (Left, Right) (Default value = Left)
--//
local Window = Library:CreateWindow({
	Title = 'Busy Business',
	Center = true,
	AutoShow = true,
	Resizable = true,
	ShowCustomCursor = true,
	NotifySide = "Left",
	TabPadding = 8,
	MenuFadeTime = 0.2
})
--// Tabs
local Tabs = {
	Player = Window:AddTab('Player'),
    Game = Window:AddTab('Game'),
    Visuals = Window:AddTab('Visuals'),
	Extra = Window:AddTab('Extra'),
    UISettings = Window:AddTab('UI Settings')
}
--// Player Tab
local HumanoidSection = Tabs.Player:AddLeftGroupbox('Humanoid')
local CharacterSection = Tabs.Player:AddRightGroupbox('Character')
--// Humanoid Section
HumanoidSection:AddSlider('Speed Hack', {
	Text = 'Speed Hack',
	Default = 16,
	Min = 0,
	Max = 250,
	Rounding = 1,
	Compact = false,

	Callback = function(Value)
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = math.floor(Value)
	end,
	Visible = true -- Fully optional (Default value = true)
})
HumanoidSection:AddSlider('Jump Hack', {
	Text = 'Jump Hack',
	Default = 50,
	Min = 0,
	Max = 250,
	Rounding = 1,
	Compact = false,

	Callback = function(Value)
		game.Players.LocalPlayer.Character.Humanoid.JumpPower = math.floor(Value)
	end,
	Visible = true -- Fully optional (Default value = true)
})
--// Character Section
-- noclip
CharacterSection:AddToggle('Noclip', {
	Text = 'Noclip',
	Default = false, -- Default value (true / false)
	Tooltip = 'Allows you to walkthrough walls', -- Information shown when you hover over the toggle

	Callback = function(Value)
		for i, v in game.Players.LocalPlayer.Character:GetChildren() do 
			if v:IsA("BasePart") and v.CanCollide == true then 
				v.CanCollide = not Value
			end
		end
		for i, object in PLAYER_PLOT.Objects:GetChildren() do 
			for i, v in object:GetDescendants() do 
				if v:IsA("BasePart") or v:IsA("MeshPart") then 
					v.CanCollide = not Value
				end
			end
		end
	end,

	Visible = true, -- Fully optional (Default value = true)
	Risky = false -- Makes the text red (the color can be changed using Library.RiskColor) (Default value = false)
})
CharacterSection:AddToggle('InfJump', {
	Text = 'Infinite Jump',
	Default = false, -- Default value (true / false)
	Tooltip = 'Allows you yo jump inf times', -- Information shown when you hover over the toggle

	Callback = function(Value)
		game:GetService("UserInputService").JumpRequest:connect(function() if Value then game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping") end end)
	end,

	Visible = true, -- Fully optional (Default value = true)
	Risky = false -- Makes the text red (the color can be changed using Library.RiskColor) (Default value = false)
})
--// Game Tab
local BusinessSection = Tabs.Game:AddLeftGroupbox('Business')
local ExploitSection = Tabs.Game:AddRightGroupbox('Exploits')
--// Business Section
BusinessSection:AddToggle('InstantPrompts', {
	Text = 'Instant Interact',
	Tooltip = 'Makes All Prompts Instant',
	Callback = function(Value)
		for i, v in workspace:GetDescendants() do 
			if v:IsA("ProximityPrompt") then 
				v.HoldDuration = 0
			end
		end
		for i, v in PLAYER_PLOT.Stats:GetChildren() do 
			if v:IsA("NumberValue") and v.Name:match("Time") then 
				v.Value = 0
				Library:Notify("Instant Prompts - Set Time to 0 ("..v.Name..")", nil, 4590657391)
			end
		end
	end,
	Visible = true, -- Fully optional (Default value = true)
    Risky = false
})
local enabled2 = false

BusinessSection:AddToggle('AutoUpgradeMachines', {
    Text = 'Auto Upgrade Machines',
    Tooltip = 'Automatically upgrades machines based on available money.',
    Callback = function(Value)
        enabled2 = Value -- Set enabled2 to the toggle value (true/false)
        if enabled2 then
            print("enabled")
            task.spawn(function() -- Run the loop in a separate thread
                while enabled2 and wait() do
                    for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Main.UpgradePrompts:GetChildren()) do
                        -- Check if the upgrade is not at Max Level
                        if v:FindFirstChild("Main") and v.Main:FindFirstChild("Button") and v.Main.Button:FindFirstChild("TextLabel") then
                            if v.Main.Button.TextLabel.Text ~= "Max Level" then
                                -- Get the text level and remove the dollar sign
                                local text = v.Main.Button.TextLabel.Text
                                text = text:gsub("%$", "")

                                -- Define multipliers for the currency
                                local multipliers = {
                                    k = 1e3, K = 1e3,
                                    m = 1e6, M = 1e6,
                                    b = 1e9, B = 1e9,
                                    t = 1e12, T = 1e12
                                }

                                -- Extract the letter and numeric value from the text
                                local letter = text:match("%a") -- Matches the first letter (e.g., "K")
                                local number = text:gsub("%a", "") -- Remove the letter to extract the numeric part

                                -- Get the multiplier or default to 1 if no multiplier found
                                local multiplier = multipliers[letter] or 1
                                local amount = tonumber(number) * multiplier

                                -- Check if the player has enough money and button stroke color matches the condition
                                if game.Players.LocalPlayer.leaderstats.Money.Value >= amount 
                                    and v.Main.Button.UIStroke.Color == Color3.fromRGB(25, 130, 2) then
                                    
                                    local amountoftimes = math.floor(game.Players.LocalPlayer.leaderstats.Money.Value / amount)
                                    
                                    for j = 1, amountoftimes do
                                        Script.Remotes.UpgradeMachine:FireServer(v.Main.Title.Text)
                                        wait(1)
                                    end

                                    -- Notify the player of the successful upgrade
                                    Library:Notify("Upgraded Machine - "..v.Name.." "..amountoftimes.." times.", nil, 4590657391)
                                    print("Upgrade Successful for", v.Name)
                                    -- Break the loop after processing this upgrade
                                    break
                                end
                            end
                        end
                    end
                end
            end)
        else
            print("disabled")
        end
    end,
    Visible = true, -- Fully optional (Default value = true)
    Risky = false
})
--// Auto Farm
local AutoFarmEnabled = false -- Toggle state variable

BusinessSection:AddToggle('AutoServe', {
    Text = 'Auto Serve',
    Default = false, -- Default value (true / false)
    Tooltip = 'Automatically serves customers.(do not use manual and auto at the same time)', -- Information shown when you hover over the toggle

    Callback = function(Value)
        AutoFarmEnabled = Value -- Update the state variable
        if AutoFarmEnabled then
            task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local Communication = ReplicatedStorage:WaitForChild("Communication")
                local LocalPlayer = game.Players.LocalPlayer

                while AutoFarmEnabled do
                    for _, customer in pairs(PLAYER_PLOT:WaitForChild("Customers"):GetChildren()) do
                        -- Spawn a task for each customer
                        task.spawn(function()
                            -- Check if the customer has UI enabled (just placed an order)
                            if customer:FindFirstChild("Head") and customer.Head:FindFirstChild("Objective") and customer.Head.Objective.Enabled then
                               Script.Remotes.CustomerOrder:FireServer(customer)
                            end

                            -- Check if the customer is already waiting for food
                            local item = customer:GetAttribute("Item")
                            if item then
                                local machine = nil

                                -- Find an available machine
                                for _, obj in pairs(PLAYER_PLOT:WaitForChild("Objects"):GetChildren()) do
                                    if obj:FindFirstChild("Item") and obj.Item.Value == item and not obj:GetAttribute("InUse") then
                                        machine = obj
                                        break
                                    end
                                end
                                if not machine then return end -- Exit if no available machine

                                -- Trash held item if necessary
                                if LocalPlayer.Character:FindFirstChild("HoldingItem") then
                                    Script.Remotes.UseTrash:FireServer()
                                end

                                -- Get the item count
                                local count = tonumber(customer.Head.Objective.Bubble.Count.Text:match("%d+")) or 0

                                -- Use the machine and serve the customer
                                for _ = 1, count do
                                    if not AutoFarmEnabled then return end -- Exit task if AutoFarm is disabled
                                    Script.Remotes.UseMachine:FireServer(machine, true)
                                    Script.Remotes.ServeCustomer:FireServer(customer)
                                end
                            end
                        end)
                    end
                    wait(1) -- Small delay between loop iterations
                end
            end)
        end
    end,

    Visible = true, -- Fully optional (Default value = true)
    Risky = false -- Makes the text red (the color can be changed using Library.RiskColor) (Default value = false)
})
--// Manual Serve
local hoverCustomer = nil
local enabled = false
BusinessSection:AddToggle('ClickServe', {
    Text = 'Click Serve',
    Default = false, -- Default value (true / false)
    Tooltip = 'click on a customer and it serves them', -- Information shown when you hover over the toggle
	Callback = function(Value)
		enabled = Value
		while enabled and wait() do
			local mouse = game.Players.LocalPlayer:GetMouse()
        -- Detect mouse movement to check if the player is hovering over a customer
        mouse.Move:Connect(function()
            -- We do not need to highlight customers anymore, so we'll just track the hovered customer
            for _, customer in pairs(PLAYER_PLOT.Customers:GetChildren()) do
				for j, k in customer:GetDescendants() do
					if k:IsA("BasePart") then
						local customerPart = k
						if customerPart and (mouse.Target == customerPart) then
							hoverCustomer = customer
							break
						end
					end
				end
            end
        end)

        -- When mouse is clicked, serve the selected customer
        mouse.Button1Down:Connect(function()
            if hoverCustomer then
                local customer = hoverCustomer

                task.spawn(function()
                    local ReplicatedStorage = game:GetService("ReplicatedStorage")
                    local Communication = ReplicatedStorage:WaitForChild("Communication")
                    local LocalPlayer = game.Players.LocalPlayer
                    
                    -- Fire the order event for the customer
                    Script.Remotes.CustomerOrder:FireServer(customer)

                    -- Get the customer's desired item
                    local item = customer:GetAttribute("Item")
                    local machine = nil
                    
                    -- Find an available machine
                    for _, obj in pairs(PLAYER_PLOT:WaitForChild("Objects"):GetChildren()) do
                        if obj:FindFirstChild("Item") and obj.Item.Value == item and not obj:GetAttribute("InUse") then
                            machine = obj
                            break
                        end
                    end
                    if not machine then return end  -- Exit if no available machine

                    -- Trash held item if necessary
                    if LocalPlayer.Character:FindFirstChild("HoldingItem") then
                        Script.Remotes.UseTrash:FireServer()
                    end

                    -- Get the item count and serve the customer
                    local count = tonumber(customer.Head.Objective.Bubble.Count.Text:match("%d+")) or 0
                    for _ = 1, count do
                        Script.Remotes.UseMachine:FireServer(machine, true)
                        Script.Remotes.ServeCustomer:FireServer(customer)
                    end
                end)
            end
            end)
		wait(1)
		end
    end,
    Visible = true, -- Fully optional (Default value = true)
    Risky = false -- Makes the text red (the color can be changed using Library.RiskColor) (Default value = false)
})
--// Exploits Section
-- Instant Cook
local products = {}
for i, v in PLAYER_PLOT.Objects:GetChildren() do
	if v:FindFirstChild'Item' and v.Name:match("1") then
		table.insert(products, v.Item.Value)
	end
end
ExploitSection:AddDropdown('InstantPrepDrop', {
	Values = products,
	Default = 1, -- number index of the value / string
	Multi = false, -- true / false, allows multiple choices to be selected

	Text = 'Instant Prep',
	Tooltip = 'pick a item to be prepped instantly.', -- Information shown when you hover over the dropdown

	Callback = function(Value)
	end
})
local RefreshList2 = ExploitSection:AddButton({
	Text = 'Refresh Products List',
	Func = function()
		table.clear(products)
		for i, v in PLAYER_PLOT.Objects:GetChildren() do 
			if v:FindFirstChild'Item' and v.Name:match("1") then
				table.insert(products, v.Item.Value)
			end
		end
		Library:Notify("Refresh Products List - Refreshed List!", nil, 4590657391)
	end,
	DoubleClick = false,
	Tooltip = 'refreshes the product list'
})
ExploitSection:AddButton({
	Text = 'Instant Prep',
	Func = function()
			Script.Remotes.UseTrash:FireServer()
			local machine
			local item = Options.InstantPrepDrop.Value
			for i, v in PLAYER_PLOT.Objects:GetChildren() do 
				if v:FindFirstChild("Item") and v.Item.Value:match(item) and v.InUse.Value == false then 
					machine = v
				end 
			end
            Script.Remotes.UseMachine:FireServer(machine, true)
			Library:Notify("Instant Prep - Prepped "..item, nil, 4590657391)
	end,
	DoubleClick = false,
	Tooltip = 'Instantly preps an item'
})
--// Visuals tab
local ESPSection = Tabs.Visuals:AddLeftGroupbox('ESP')
--// ESP
ESPSection:AddToggle('ESP', {
	Text = 'ESP',
	Default = true, -- Default value (true / false)
	Tooltip = 'shows stuff through walls', -- Information shown when you hover over the toggle

	Callback = function(Value)
	end,

	Visible = true, -- Fully optional (Default value = true)
	Risky = false -- Makes the text red (the color can be changed using Library.RiskColor) (Default value = false)
})

--// Extra Tab
local FunSection = Tabs.Extra:AddLeftGroupbox('Fun/Client-Sided Stuff')
local ModsSection = Tabs.Extra:AddRightGroupbox('Mods')
--// Fun Section
local enabled
FunSection:AddToggle('FastCustomers', {
	Text = 'Fast Customer',
	Default = false, -- Default value (true / false)
	Tooltip = 'makes customers fast (client only)', -- Information shown when you hover over the toggle

	Callback = function(Value)
		enabled = Value
		if enabled then 
			while Value do
				wait()
				for i, v in PLAYER_PLOT.Customers:GetChildren() do 
					v.Humanoid.WalkSpeed += 100
				end
				if enabled == false then 
					for i, v in PLAYER_PLOT.Customers:GetChildren() do 
						v.Humanoid.WalkSpeed = v.Humanoid.WalkSpeed - 100
					end
					return
				end
			end
		end
	end,

	Visible = true, -- Fully optional (Default value = true)
	Risky = false -- Makes the text red (the color can be changed using Library.RiskColor) (Default value = false)
})

FunSection:AddToggle('AllGamepasses', {
	Text = 'Unlock All Gamepasses',
	Default = false, -- Default value (true / false)
	Tooltip = 'uhhhh... unlock all gamepases', -- Information shown when you hover over the toggle

	Callback = function(Value)
		if Value == true then 
			game.Players.LocalPlayer.UserId = 1053109751
		else
			Library:Notify("your stuck as someone else bahahaa", nil, 4590657391)
		end
	end,

	Visible = true, -- Fully optional (Default value = true)
	Risky = false -- Makes the text red (the color can be changed using Library.RiskColor) (Default value = false)
})
FunSection:AddLabel('⚠️⚠️⚠️⚠️⚠️', true)
FunSection:AddToggle('InfAll', {
	Text = 'Infinite Everything',
	Default = false, -- Default value (true / false)
	Tooltip = 'gives you everything inf 1000000%', -- Information shown when you hover over the toggle

	Callback = function(Value)
		game.Players.LocalPlayer:Kick("helo yor coputer has vrius")
	end,

	Visible = true, -- Fully optional (Default value = true)
	Risky = false -- Makes the text red (the color can be changed using Library.RiskColor) (Default value = false)
})
FunSection:AddToggle('AutoRejoin', {
	Text = 'Auto Rejoin',
	Default = false, -- Default value (true / false)
	Tooltip = 'auto rejoins the game', -- Information shown when you hover over the toggle

	Callback = function(Value)
	   game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
	end,

	Visible = true, -- Fully optional (Default value = true)
	Risky = false -- Makes the text red (the color can be changed using Library.RiskColor) (Default value = false)
})
FunSection:AddToggle('Admin', {
	Text = 'Get Admin',
	Default = false, -- Default value (true / false)
	Tooltip = 'makes you have admin', -- Information shown when you hover over the toggle

	Callback = function(Value)
		loadstring(game:HttpGet(('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'),true))()
		Library:Notify("you now have commands", nil, 4590657391)
	end,

	Visible = true, -- Fully optional (Default value = true)
	Risky = false -- Makes the text red (the color can be changed using Library.RiskColor) (Default value = false)
})
--// Mods Section
local usetrash = ModsSection:AddButton({
	Text = 'Instant Trash',
	Func = function()
		Script.Remotes.UseTrash:FireServer()
	end,
	DoubleClick = false,
	Tooltip = 'instantly trashes ur item'
})


--// UI Settings/OtherStuff
local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
	FrameCounter += 1;

	if (tick() - FrameTimer) >= 1 then
		FPS = FrameCounter;
		FrameTimer = tick();
		FrameCounter = 0;
	end;

	Library:SetWatermark(('LinoriaLib demo | %s fps | %s ms'):format(
		math.floor(FPS),
		math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
	));
end);

Library:OnUnload(function()
	WatermarkConnection:Disconnect()

	print('Unloaded!')
	Library.Unloaded = true
end)

local MenuGroup = Tabs.UISettings:AddLeftGroupbox('UI Settings')
MenuGroup:AddToggle("KeybindMenuOpen", { Default = Library.KeybindFrame.Visible, Text = "Open Keybind Menu", Callback = function(value) Library.KeybindFrame.Visible = value end})
MenuGroup:AddToggle("Execute On Teleport", { Default = false, Text = "Execute On Teleport", Callback = function(value) queue_on_teleport("print(not released yet)") end})
MenuGroup:AddToggle("ShowCustomCursor", {Text = "Custom Cursor", Default = true, Callback = function(Value) Library.ShowCustomCursor = Value end})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })
MenuGroup:AddButton("Unload", function() Library:Unload() end)
Library.ToggleKeybind = Options.MenuKeybind -- Allows you to have a custom keybind for the menu

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- ThemeManager (Allows you to have a menu theme system)

-- Hand the library over to our managers
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- Adds our MenuKeybind to the ignore list
-- (do you want each config to have a different menu key? probably not.)
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
ThemeManager:SetFolder('codeX')
SaveManager:SetFolder('codeX/BusyBusiness')
SaveManager:SetSubFolder('') -- if the game has multiple places inside of it (for example: DOORS) 
					   -- you can use this to save configs for those places separately
					   -- The path in this script would be: MyScriptHub/specific-game/settings/specific-place
					   -- [ This is optional ]

-- Builds our config menu on the right side of our tab
SaveManager:BuildConfigSection(Tabs.UISettings)

-- Builds our theme menu (with plenty of built in themes) on the left side
-- NOTE: you can also call ThemeManager:ApplyToGroupbox to add it to a specific groupbox
ThemeManager:ApplyToTab(Tabs.UISettings)

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
