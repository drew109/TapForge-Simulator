local DataStoreService = game:GetService("DataStoreService")

local STORE = DataStoreService:GetDataStore("TapForgePlayerData_v1")
local AUTOSAVE_SECONDS = 60

local DataService = {}
local profiles = {}

local DEFAULT_DATA = {
	Energy = 0,
	Multiplier = 1,
	Rebirths = 0,
}

local function copyDefaults()
	return table.clone(DEFAULT_DATA)
end

function DataService.load(player: Player)
	local data = copyDefaults()
	local success, stored = pcall(function()
		return STORE:GetAsync(tostring(player.UserId))
	end)

	if success and type(stored) == "table" then
		for key, defaultValue in DEFAULT_DATA do
			if typeof(stored[key]) == typeof(defaultValue) then
				data[key] = math.max(0, stored[key])
			end
		end
	elseif not success then
		warn("TapForge: data load failed for", player.UserId)
	end

	profiles[player] = data
	return data
end

function DataService.get(player: Player)
	return profiles[player]
end

function DataService.save(player: Player)
	local data = profiles[player]
	if not data then
		return
	end

	local snapshot = table.clone(data)
	local success, message = pcall(function()
		STORE:UpdateAsync(tostring(player.UserId), function()
			return snapshot
		end)
	end)

	if not success then
		warn("TapForge: data save failed for", player.UserId, message)
	end
end

function DataService.remove(player: Player)
	DataService.save(player)
	profiles[player] = nil
end

task.spawn(function()
	while true do
		task.wait(AUTOSAVE_SECONDS)
		for player in profiles do
			DataService.save(player)
		end
	end
end)

return DataService

