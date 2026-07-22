local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local remotes = ReplicatedStorage:WaitForChild("TapForgeRemotes")
local Economy = require(ReplicatedStorage.Shared.Economy)

local gui = Instance.new("ScreenGui")
gui.Name = "TapForgeUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local panel = Instance.new("Frame")
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Position = UDim2.fromScale(0.5, 0.72)
panel.Size = UDim2.fromOffset(430, 230)
panel.BackgroundColor3 = Color3.fromRGB(25, 28, 40)
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 18)

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.Parent = panel

local function makeLabel(text: string, height: number)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -30, 0, height)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.TextColor3 = Color3.fromRGB(245, 247, 255)
	label.TextScaled = true
	label.Text = text
	label.Parent = panel
	return label
end

local function makeButton(text: string, color: Color3)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -40, 0, 48)
	button.BackgroundColor3 = color
	button.Font = Enum.Font.GothamBold
	button.TextColor3 = Color3.new(1, 1, 1)
	button.TextScaled = true
	button.Text = text
	button.Parent = panel
	Instance.new("UICorner", button).CornerRadius = UDim.new(0, 12)
	return button
end

local status = makeLabel("Loading TapForge...", 42)
local tapButton = makeButton("TAP FOR ENERGY", Color3.fromRGB(49, 151, 255))
local upgradeButton = makeButton("BUY MULTIPLIER", Color3.fromRGB(112, 78, 255))
local rebirthButton = makeButton("REBIRTH", Color3.fromRGB(255, 105, 75))

local stats = player:WaitForChild("leaderstats")
local energy = stats:WaitForChild("Energy")
local multiplier = stats:WaitForChild("Multiplier")
local rebirths = stats:WaitForChild("Rebirths")

local function refresh()
	status.Text = string.format("%d Energy  •  x%d  •  %d Rebirths", energy.Value, multiplier.Value, rebirths.Value)
	upgradeButton.Text = string.format("BUY x%d  —  %d ENERGY", multiplier.Value + 1, Economy.multiplierCost(multiplier.Value))
	rebirthButton.Text = string.format("REBIRTH  —  %d ENERGY", Economy.rebirthCost(rebirths.Value))
end

energy.Changed:Connect(refresh)
multiplier.Changed:Connect(refresh)
rebirths.Changed:Connect(refresh)
tapButton.Activated:Connect(function() remotes.Tap:FireServer() end)
upgradeButton.Activated:Connect(function() remotes.BuyMultiplier:FireServer() end)
rebirthButton.Activated:Connect(function() remotes.Rebirth:FireServer() end)
refresh()

