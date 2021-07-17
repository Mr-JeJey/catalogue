local Choisis = nil
local LastVehicles = {}
local vehiclesByCategory = {}
local AParcourirPourLeMenuCatalogue = {}

RMenu.Add("catalogue", "catalogue_main", RageUI.CreateMenu("Catalogue","Véhicules disponibles"))
RMenu:Get("catalogue", "catalogue_main").Closed = function()
	MenuCatalogue = false
    FreezeEntityPosition(PlayerPedId(), false)
    DeleteLastVeh()
end

RMenu.Add('catalogue_infos', 'catalogue_infos_main', RageUI.CreateSubMenu(RMenu:Get('catalogue', 'catalogue_main'), "Véhicules", "Informations"))
RMenu:Get('catalogue_infos', 'catalogue_infos_main').Closed = function()
end

function initVehicleForCata()
	local VehicleData   = nil

	for i=1, #Categories, 1 do
		vehiclesByCategory[Categories[i].name] = {}
	end

	for i=1, #Vehicles, 1 do
		table.insert(vehiclesByCategory[Vehicles[i].category], Vehicles[i])
	end

    for i=1, #Categories, 1 do
		local category = Categories[i]
		local categoryVehicles = vehiclesByCategory[category.name]
		local vehicleNames = {}

		for j=1, #categoryVehicles, 1 do
			local vehicle = categoryVehicles[j]

			if i == 1 and j == 1 then
				VehicleData = vehicle
			end

			table.insert(vehicleNames, vehicle.name)
		end

		table.insert(AParcourirPourLeMenuCatalogue, {
			name = category.name,
			label = category.label,
			items = vehicleNames,
		})
	end
end

function DeleteLastVeh()
	while #LastVehicles > 0 do
		local vehicle = LastVehicles[1]
		ESX.Game.DeleteVehicle(vehicle)
		table.remove(LastVehicles, 1)
	end
end

function openMenuCatalogue()
    if not MenuCatalogue then 
        MenuCatalogue = true
		RageUI.Visible(RMenu:Get('catalogue', 'catalogue_main'), true)

		Citizen.CreateThread(function()
			while MenuCatalogue do
                FreezeEntityPosition(PlayerPedId(), true) -- Eviter que le joueuur se barre avec le menu
                RageUI.IsVisible(RMenu:Get("catalogue",'catalogue_main'),true,true,true,function()
                    RageUI.Separator("↓ ~b~Catégories~s~ ↓")

                    for i = 1, #AParcourirPourLeMenuCatalogue, 1 do
                        RageUI.ButtonWithStyle(AParcourirPourLeMenuCatalogue[i].label, 'Voici la catégorie des véhicules disponibles', {RightLabel = "→"}, true, function(_, _, s)
                            if s then
                                Choisis = AParcourirPourLeMenuCatalogue[i]
                            end
                        end,RMenu:Get('catalogue_infos', 'catalogue_infos_main')) 
                    end
                    
                end, function()    
                end, 1)


                RageUI.IsVisible(RMenu:Get("catalogue_infos",'catalogue_infos_main'),true,true,true,function()
                    RageUI.Separator("↓ ~b~Véhicules~s~ ↓")

                    for k,v in pairs(Choisis.items) do
                        RageUI.ButtonWithStyle(Choisis.items[k], 'Voici la liste des véhicules disponibles', {RightLabel = "→"}, true, function(_, _, s)
                            if s then
                                SpawnVehOnLocal(vehiclesByCategory[Choisis.name][k])
                            end
                        end,RMenu:Get('catalogue_infos', 'catalogue_infos_main')) 
                    end
                    
                end, function()    
                end, 1)

				Wait(1)
			end

		MenuCatalogue = false
		end)
	end
end

function SpawnVehOnLocal(veh)
    DeleteLastVeh()

                                
    ESX.Game.SpawnLocalVehicle(veh.model, vector3(228.77, -982.86, -99.0), 178.0, function(vehicle)
        table.insert(LastVehicles, vehicle)
        SetVehicleEngineOn(vehicle, false, true, true)
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        FreezeEntityPosition(vehicle, true)
    end)
end

