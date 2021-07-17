ESX = nil

Citizen.CreateThread(function ()
    while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Wait(0)
    end
  
    ESX.TriggerServerCallback('catalogue:getCategories', function(categories)
        Categories = categories    
    end)
  
    ESX.TriggerServerCallback('catalogue:getVehicles', function(vehicles)
        Vehicles = vehicles
    end)

    Wait(500)
    initVehicleForCata()
end)



Citizen.CreateThread(function()
    while true do
        local coords = GetEntityCoords(PlayerPedId())
		local playerPed = PlayerPedId()
        local fps = false
		local CurrentZone = nil
        for k,v in pairs(Config.CataEntree) do
            if #(coords - v.Pos) < 1.5 then
                fps = true
                BeginTextCommandDisplayHelp('STRING') 
                AddTextComponentSubstringPlayerName("Appuyer sur ~INPUT_PICKUP~ pour intéragir.") 
                EndTextCommandDisplayHelp(0, false, true, -1)
                if IsControlJustReleased(0, 38) then
					if k == 'Entrer' then
						SetEntityCoords(playerPed, Config.CataEntree.Sortie.Pos.x, Config.CataEntree.Sortie.Pos.y, Config.CataEntree.Sortie.Pos.z)
					elseif k == 'Sortie' then 
						SetEntityCoords(playerPed, Config.CataEntree.Entrer.Pos.x, Config.CataEntree.Entrer.Pos.y, Config.CataEntree.Entrer.Pos.z)
					elseif k == 'Interaction' then
						openMenuCatalogue()
					end
                end
            elseif #(coords - v.Pos) < 12.0 then
                fps = true
                DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
            end
        end
        if fps then
            Wait(1)
        else
            Wait(1500)
        end
    end
end)