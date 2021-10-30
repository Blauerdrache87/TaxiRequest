-- How To use this script:

-- 1. start esx_taxireq
-- 2. add this code to where you want to send request:

TriggerServerEvent('mani_taxi:addreq', "your text")

-- For example I want to send request when I send message to taxi in gcphone

-- I add this code in esx_addons_gcphone (already have and you should update this)

RegisterNetEvent('esx_addons_gcphone:call')
AddEventHandler('esx_addons_gcphone:call', function(data)
  local playerPed   = GetPlayerPed(-1)
  local coords      = GetEntityCoords(playerPed)
  local message     = data.message
  local number      = data.number
  if number == "taxi" then
    if message == nil then
      DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 200)
      while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
      end
      if (GetOnscreenKeyboardResult()) then
        message =  GetOnscreenKeyboardResult()
      end
    end
    if message ~= nil and message ~= "" then
      TriggerServerEvent('mani_taxi:addreq', message)
    end
  else
    if message == nil then
      DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 200)
      while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
      end
      if (GetOnscreenKeyboardResult()) then
        message =  GetOnscreenKeyboardResult()
      end
    end
    if message ~= nil and message ~= "" then
      TriggerServerEvent('esx_addons_gcphone:startCall', number, message, {
        x = coords.x,
        y = coords.y,
        z = coords.z
      })
    end
  end
end)

--and for open requests list you should trigger this event "mani_taxi:openreqs"  (client side)
--For Example

RegisterCommand("openreqs", function()
  TriggerEvent("mani_taxi:openreqs")
end)
