ESX = nil
local rcount = 1
local reqs = {}
local chats = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('esx:playerLoaded', function(source)
	local identifier = GetPlayerIdentifier(source)
	for k,v in pairs(reqs) do
		if v.owner.identifier == identifier then
			v.owner.id = source
		end
	end
end)

RegisterCommand('reqs', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		TriggerClientEvent('mani_taxi:openreqs', source)
	end
end, false)

RegisterServerEvent("mani_taxi:addreq")
AddEventHandler("mani_taxi:addreq", function(reason)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local identifier = GetPlayerIdentifier(source)
		if doesHaveReq(identifier) then
			TriggerClientEvent("pNotify:SendNotification", source, {text = "Shoma Az Qabl Darkhast Darid Lotfan Shakiba Bashid!", type = "error", timeout = 4000, layout = "centerRight"})
			return
		end
		local name = string.gsub(xPlayer.name, "_", " ")
		reqs[tostring(rcount)] = {
			owner = {
			identifier = identifier,
			name = name,
			coord = GetEntityCoords(GetPlayerPed(source))
		},
		respond = {
			name = "none",
			identifier = "none"
		},
			reason = reason,
			status = "open",
			time = os.time()
		}
		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'taxi' then
				TriggerClientEvent("pNotify:SendNotification", xPlayer.source, {text = "DarKhast Jadid Taxi Sabt Shod!", type = "success", timeout = 4000, layout = "centerRight"})
			end
		end
		rcount = rcount + 1
		TriggerClientEvent("pNotify:SendNotification", source, {text = "Darkhast Shoma Baraye Taxi Ersal Shod!", type = "success", timeout = 4000, layout = "centerRight"})
	end
end)

RegisterServerEvent("mani_taxi:creqs")
AddEventHandler("mani_taxi:creqs", function(id)
	local reqid = id
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == "taxi" then
		if reqs[reqid] then
			local req = reqs[reqid]
			local identifier = GetPlayerIdentifier(source)
			local ridentifier = req.owner.identifier
			chats[identifier] = nil
			chats[ridentifier] = nil
			TriggerClientEvent("pNotify:SendNotification", source, {text = "Shoma Reqs Ra Bastid!", type = "success", timeout = 4000, layout = "centerRight"})
			xPlayer = ESX.GetPlayerFromIdentifier(req.owner.identifier)
			if xPlayer then
				TriggerClientEvent("pNotify:SendNotification", xPlayer.source, {text = "Reqs Shoma Baste Shod!", type = "success", timeout = 4000, layout = "centerRight"})
				TriggerClientEvent("mani_taxi:delblip", xPlayer.source)
			end
			reqs[reqid] = nil
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " Req Mored Nazar Vojod Nadarad!")
		end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Dastresi Kafi Baraye Estefade Az In Dastor Ra Nadarid")
	end
end)

RegisterServerEvent("mani_taxi:areqs")
AddEventHandler("mani_taxi:areqs", function(id)
	local reqid = id
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == "taxi" then
		local identifier = GetPlayerIdentifier(source)
		local coord = GetEntityCoords(GetPlayerPed(source))
		if not canRespond(identifier) then
			TriggerClientEvent("pNotify:SendNotification", source, {text = "Shoma Reqs Accept Shode Darid!", type = "error", timeout = 4000, layout = "centerRight"})
			return
		end
		if reqs[reqid] then
			if reqs[reqid].status == "open" then
				local req = reqs[reqid]
				local ridentifier = req.owner.identifier
				local name = string.gsub(xPlayer.name, "_", " ")
				req.status = "pending"
				req.respond.name = name
				req.respond.identifier = identifier
				chats[identifier] = ridentifier
				chats[ridentifier] = identifier
				TriggerClientEvent("pNotify:SendNotification", source, {text = "Shoma req " .. req.owner.name .. " Ra Ghabol Kardid!", type = "success", timeout = 4000, layout = "centerRight"})
				TriggerClientEvent("mani_taxi:acceptreq", source, req.owner.coord)
				xPlayer = ESX.GetPlayerFromIdentifier(req.owner.identifier)
				if xPlayer then
					TriggerClientEvent("pNotify:SendNotification", xPlayer.source, {text = "Darkhast Shoma Ghabool Shod, ba /tc mitavanid ba ranande chat konid!", type = "success", timeout = 4000, layout = "centerRight"})
					TriggerClientEvent("mani_taxi:addblip", xPlayer.source, source, coord)
				end
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " In Reqs Ghablan Tavasot Kasi Javab Dade Shode Ast!")
			end
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " Reqs Mored Nazar Vojod Nadarad!")
		end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Dastresi Kafi Baraye Estefade Az In Dastor Ra Nadarid")
	end
end)

RegisterCommand('tc', function(source, args)
	local identifier = GetPlayerIdentifier(source)
	if chats[identifier] then
		if not args[1] then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Nemitvanid Peygham Khali Befrestid")
			return
		end
		local message = table.concat(args, " ")
		local name = string.gsub(xPlayer.name, "_", " ")
		local xPlayer = ESX.GetPlayerFromIdentifier(chats[identifier])
		if xPlayer then
			TriggerClientEvent('chatMessage', source, "[ReQs]", {255, 0, 0}, " ^2" .. name .. ":^0 " .. message)
			TriggerClientEvent('chatMessage', xPlayer.source, "[ReQs]", {255, 0, 0}, " ^2" .. name .. ":^0 " .. message)
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Player Mored Nazar Online Nist")
		end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Hich Reqs Activi Nadarid!")
	end
end, false)

ESX.RegisterServerCallback('mani_taxi:getReqs', function(source, cb)
	local treqs = {}
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == "taxi" then
		local status
		if TableLength(reqs) > 0 then
			for k,v in pairs(reqs) do
				if v.status == "open" then
					status = "❌"
				else
					status = "✔️"
				end
				table.insert(treqs, {
					name		= v.owner.name,
					phone		= getNumberPhone(v.owner.identifier),
					coord		= v.owner.coord,
					reqid	    = k,
					reason		= v.reason,
					status		= status
				})
			end
			cb(treqs)
		else
			TriggerClientEvent("pNotify:SendNotification", source, {text = "DarKhasti Vojod nadarad!", type = "error", timeout = 4000, layout = "centerRight"})
		end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Dastresi Kafi Baraye Estefade Az In Dastor Ra Nadarid")
	end
end)

ESX.RegisterServerCallback('mani_taxi:getcoord', function(source, cb, id)
	local coord = GetEntityCoords(GetPlayerPed(id))
	cb(coord)
end)

function canRespond(identifier)
	for k,v in pairs(reqs) do
		if v.respond.identifier == identifier then
			return false
		end
	end

	return true
end

function doesHaveReq(identifier)
	for k,v in pairs(reqs) do
		if v.owner.identifier == identifier then
			return true
		end
	end

	return false
end

function TableLength(table)
	local count = 0
	for _ in pairs(table) do
		count = count + 1
	end
	return count
end

function CheckReqs()
	if TableLength(reqs) > 0 then
		for k,v in pairs(reqs) do
			if os.time() - v.time >= 600 and v.respond.name == "none" then
				local xPlayer = ESX.GetPlayerFromIdentifier(reqs[k].owner.identifier)
				if xPlayer then
					TriggerClientEvent("pNotify:SendNotification", xPlayer, {text = "DarKhast Taxi Shoma Bedalil Adam Pasokhgoyi Baste Shod!", type = "error", timeout = 4000, layout = "centerRight"})
				end
				reqs[k] = nil
			end
		end
	end
	SetTimeout(5000, CheckReqs)
end
CheckReqs()

function getNumberPhone(identifier)
    local result = MySQL.Sync.fetchAll("SELECT users.phone_number FROM users WHERE users.identifier = @identifier", {
        ['@identifier'] = identifier
    })
    if result[1] ~= nil then
        return result[1].phone_number
    end
    return nil
end