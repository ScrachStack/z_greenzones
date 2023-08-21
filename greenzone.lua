local locations = {
    {
        coords = vector3(-410.3709, 1170.225, 325.8329),
        gangshitrzText = "Zaps Development",
        discordText = "discord.gg/cfxdev",
        range = 15.0 -- <-- Specific range for this location
    },
    {
        coords = vector3(219.45, -2547.156, 6.203),
        gangshitrzText = "Another Location",
        discordText = "discord.gg/cfxdev",
        range = 20.0 -- <-- Specific range for this location
    },
    {
        coords = vector3(-246.4827, -1610.57, 33.6316),
        gangshitrzText = "Another ",
        discordText = "Join our Discord: discord.gg/cfxdev",
        range = 25.0 -- <-- Specific range for this location
    },
}


local displayText = false
local inGreenZone = false
local playerPed = nil

function RemoveText()
    displayText = false
    SendNUIMessage({ type = "displayText", display = false })
end

function SetPlayerPvP(enabled)
    local player = PlayerId()
    NetworkSetFriendlyFireOption(enabled)
    SetCanAttackFriendly(playerPed, enabled, enabled)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        playerPed = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(playerPed)
        local nearestLocation = nil
        local nearestDistance = nil

        for _, location in ipairs(locations) do
            local distance = #(playerCoords - location.coords)
            if (not nearestDistance or distance < nearestDistance) and distance <= location.range then
                nearestDistance = distance
                nearestLocation = location
            end
        end

        if nearestLocation then
            displayText = true
            inGreenZone = true
            SetPlayerPvP(false)
        
            local message = {
                type = "displayText",
                display = true,
                gangshitrzText = nearestLocation.gangshitrzText,
                discordText = nearestLocation.discordText,
            }
            SendNUIMessage(message)
        else
            if inGreenZone then
                inGreenZone = false
                SetPlayerPvP(true)
            end
            RemoveText()
        end

    end 
end)
