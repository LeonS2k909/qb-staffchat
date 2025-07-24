local QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand("staff", function(source, args, rawCommand)
    local src = source
    local msg = table.concat(args, " ")

    -- ✅ Permission check (ACE group or QBCore permission)
    local allowed = false

    -- Check if user is in ACE group.admin (txAdmin style)
    if IsPlayerAceAllowed(src, "command") then
        allowed = true
    end

    -- Fallback to QBCore permissions
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        local perm = Player.PlayerData.permission
        if perm == "admin" or perm == "god" then
            allowed = true
        end
    end

    if not allowed then
        TriggerClientEvent('QBCore:Notify', src, "You don’t have permission to use this.", "error")
        return
    end

    -- Broadcast to all staff
    for _, id in pairs(QBCore.Functions.GetPlayers()) do
        local target = QBCore.Functions.GetPlayer(id)
        if target then
            local targetPerm = target.PlayerData.permission
            if targetPerm == "admin" or targetPerm == "god" or IsPlayerAceAllowed(id, "command") then
                TriggerClientEvent('chat:addMessage', id, {
                    color = { 255, 0, 128 },
                    multiline = true,
                    args = { "[STAFF] " .. GetPlayerName(src), msg }
                })
            end
        end
    end
end, false)
