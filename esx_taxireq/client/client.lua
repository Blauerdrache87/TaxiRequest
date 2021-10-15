ESX = nil
carblip = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('mani_taxi:openreqs')
AddEventHandler('mani_taxi:openreqs', function(source)
	OpenReqsList()
end)

RegisterNetEvent('mani_taxi:acceptreq')
AddEventHandler('mani_taxi:acceptreq', function(loc)
	SetNewWaypoint(loc)
end)

RegisterNetEvent('mani_taxi:addblip')
AddEventHandler('mani_taxi:addblip', function(id, coords)
	local id = id
	if carblip ~= 0 then
		RemoveBlip(carblip)
		carblip = 0
	end
	Wait(2000)
	carblip = AddBlipForCoord(coords)
	SetBlipSprite(carblip, 198)
	SetBlipFlashes(carblip, true)
	SetBlipColour(carblip,5)
	SetBlipFlashTimer(carblip, 5000)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName('Taxi officer')
	EndTextCommandSetBlipName(carblip)
	while carblip ~= 0 do
		Wait(3000)
		ESX.TriggerServerCallback('mani_taxi:getcoord', function(coords)
			if coords ~= nil then
				SetBlipCoords(carblip,coords)
			else
				RemoveBlip(carblip)
				carblip = 0
			end
		end,id)
	end
end)

RegisterNetEvent('mani_taxi:delblip')
AddEventHandler('mani_taxi:delblip',function()
	if carblip ~= 0 then
		RemoveBlip(carblip)
		carblip = 0
	end
end)

function OpenReqsList()
	ESX.TriggerServerCallback('mani_taxi:getReqs', function(reqs)
		local elements = {
			head = {"ShakHs", "ReQ ID", "ToziHaT", "StaTuS", "GoziNe"},
			rows = {}
		}
		for i=1, #reqs, 1 do
			table.insert(elements.rows, {
				data = reqs[i],
				cols = {
					reqs[i].name,
					reqs[i].reqid,
					reqs[i].reason,
					reqs[i].status,
					'{{' .. "Answer" .. '|answer}} {{' .. "Close" .. '|close}} {{' .. "Call" .. '|call}}'
				}
			})
		end
		ESX.UI.Menu.Open('list', GetCurrentResourceName(), "reqs_lists", elements, function(data, menu)
			local req = data.data
			if data.value == 'answer' then
				TriggerServerEvent('mani_taxi:areqs', req.reqid)
				menu.close()
			elseif data.value == 'close' then
				TriggerServerEvent('mani_taxi:creqs', req.reqid)
				menu.close()
			elseif data.value == 'call' then
				menu.close()
				TriggerEvent('gcphone:autoCall', req.phone)
			end
		end, function(data, menu)
			menu.close()
		end)
	end)
end