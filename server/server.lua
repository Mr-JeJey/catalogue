ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Categories = {}
local Vehicles = {}

MySQL.ready(function()
	Categories = MySQL.Sync.fetchAll('SELECT * FROM vehicle_categories')
	local vehicles = MySQL.Sync.fetchAll('SELECT * FROM vehicles')

	for i=1, #vehicles, 1 do
		local vehicle = vehicles[i]

		for j=1, #Categories, 1 do
			if Categories[j].name == vehicle.category then
				vehicle.categoryLabel = Categories[j].label
				break
			end
		end

		table.insert(Vehicles, vehicle)
	end

end)

ESX.RegisterServerCallback('catalogue:getCategories', function(xPlayer, source, cb)
	cb(Categories)
end)

ESX.RegisterServerCallback('catalogue:getVehicles', function(xPlayer, source, cb)
	cb(Vehicles)
end)