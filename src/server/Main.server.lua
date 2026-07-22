local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Economy = require(ReplicatedStorage.Shared.Economy)
local DataService = require(script.Parent.DataService)

local remotes = Instance.new("Folder")
remotes.Name = "TapForgeRemotes"
remotes.Parent = ReplicatedStorage

local tapRemote = Instance.new("RemoteEvent")
tapRemote.Name = "Tap"
tapRemote.Parent = remotes

local buyRemote = Instance.new("RemoteEvent")
buyRemote.Name = "BuyMultiplier"
buyRemote.Parent = remotes

local rebirthRemote = Instance.new("RemoteEvent")
rebirthRemote.Name = "Rebirth"
rebirthRemote.Parent = remotes

local lastTap = {}

local function makeStat(parent: Instance, name: string, value: number)
	local stat = Instance.new("IntValue")
	stat.Name = name
	stat.Value = value
	stat.Parent = parent
	return stat
end

local function sync(player: Player)
	local data = DataService.get(player)
	local stats = player:FindFirstChild("leaderstats")
	if data and stats then
		stats.Energy.Value = math.floor(data.Energy)
		stats.Multiplier.Value = math.floor(data.Multiplier)
		stats.Rebirths.Value = math.floor(data.Rebirths)
	end
end

Players.PlayerAdded:Connect(function(player)
	local data = DataService.load(player)
	local stats = Instance.new("Folder")
	stats.Name = "leaderstats"
	stats.Parent = player
	makeStat(stats, "Energy", data.Energy)
	makeStat(stats, "Multiplier", data.Multiplier)
	makeStat(stats, "Rebirths", data.Rebirths)
end)

Players.PlayerRemoving:Connect(function(player)
	lastTap[player] = nil
	DataService.remove(player)
end)

tapRemote.OnServerEvent:Connect(function(player)
	local now = os.clock()
	if now - (lastTap[player] or 0) < 0.075 then
		return
	end
	lastTap[player] = now

	local data = DataService.get(player)
	if data then
		data.Energy += Economy.tapValue(data.Multiplier, data.Rebirths)
		sync(player)
	end
end)

buyRemote.OnServerEvent:Connect(function(player)
	local data = DataService.get(player)
	if not data then
		return
	end
	local cost = Economy.multiplierCost(data.Multiplier)
	if data.Energy >= cost then
		data.Energy -= cost
		data.Multiplier += 1
		sync(player)
	end
end)

rebirthRemote.OnServerEvent:Connect(function(player)
	local data = DataService.get(player)
	if not data then
		return
	end
	local cost = Economy.rebirthCost(data.Rebirths)
	if data.Energy >= cost then
		data.Energy = 0
		data.Multiplier = 1
		data.Rebirths += 1
		sync(player)
	end
end)

game:BindToClose(function()
	for _, player in Players:GetPlayers() do
		DataService.save(player)
	end
end)

