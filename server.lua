RegisterServerEvent('trickortreat:spawnNPC', function(index)
    local src = source
    local house = Config.Houses[index]
    if not house then return end

    local random = math.random(1, 100)

    if random <= Config.AttackChance then
        TriggerClientEvent('trickortreat:attackPlayer', src, house.npcSpawn)
        return
    end

    -- keine "Bleohnung"
    if random <= Config.NoRewardChance + Config.AttackChance then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Keiner macht die Tür auf...',
            description = 'Heute gibt’s wohl nichts für dich!',
            type = 'error'
        })
        return
    end

    -- "Belohnung"
    TriggerClientEvent('trickortreat:spawnNPCClient', src, house.npcSpawn)

    Wait(2000)
    local item = Config.Rewards[math.random(1, #Config.Rewards)]
    exports.ox_inventory:AddItem(src, item, 1)
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Süßes oder Saures',
        description = ('Der Typ gibt dir ein(e) %s.'):format(item),
        type = 'success'
    })
end)

--[[RegisterServerEvent('trickortreat:spawnNPC', function(index)
    local src = source
    local house = Config.Houses[index]
    if not house then return end

    -- NPC clientseitig spawnen
    TriggerClientEvent('trickortreat:spawnNPCClient', src, house.npcSpawn)

    -- kurze Wartezeit, während NPC animiert
    Wait(2000)

    local random = math.random(1, 100)

    if random <= Config.AttackChance then
        Wait(500)
        TriggerClientEvent('trickortreat:attackPlayer', src)
        return
    end

    if random <= Config.NoRewardChance + Config.AttackChance then
        Wait(500)
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Der Typ schüttelt den Kopf...',
            description = 'Heute gibt’s wohl nichts für dich!',
            type = 'error'
        })
        return
    end

    -- Belohnung geben
    local item = Config.Rewards[math.random(1, #Config.Rewards)]
    exports.ox_inventory:AddItem(src, item, 1)

    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Süßes oder Saures',
        description = ('Der Typ gibt dir ein(e) %s.'):format(item),
        type = 'success'
    })
end)]]