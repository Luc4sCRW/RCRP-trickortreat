local knocking = false
local houseCooldowns = {}

local friendlyPeds = {
    'a_m_m_fatlatin_01',
    'u_m_y_rsranger_01',
    'a_m_m_eastsa_01',
    'a_f_m_bevhills_01',
    'a_m_m_genfat_01',
    'a_m_y_business_03',
    'a_f_y_bevhills_04',
    'ig_mrs_thornhill',
    'u_m_y_gabriel',
    'a_m_y_stlat_01'
}

local evilPeds = {
    'u_m_y_zombie_01',
    'g_m_m_chicold_01',
    'g_f_m_undeadmage',
    'ig_zombie_dj_01',
    'g_m_m_zombie_05',
    'g_m_m_zombie_04',
}

CreateThread(function()
    for i, house in ipairs(Config.Houses) do
        local blip = AddBlipForCoord(house.blip)
        SetBlipSprite(blip, 40)
        SetBlipColour(blip, 17)
        SetBlipScale(blip, 0.4)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString('Trick or Treat')
        EndTextCommandSetBlipName(blip)

        exports.ox_target:addBoxZone({
            coords = house.blip,
            size = vec3(1, 1, 1),
            options = {
                {
                    name = 'trickortreat_' .. i,
                    icon = 'fa-solid fa-candy-cane',
                    label = 'Trick or Treat',
                    onSelect = function()
                        if knocking then return end
                        local now = GetGameTimer()
                        if houseCooldowns[i] and now < houseCooldowns[i] then
                            local remaining = math.floor((houseCooldowns[i] - now) / 1000)
                            lib.notify({
                                title = 'This house wont open its doors anymore...',
                                description = ('Wait for %d Seconds!'):format(remaining),
                                type = 'error'
                            })
                            return
                        end

                        houseCooldowns[i] = now + (120 * 1000) --  2min cooldown

                        knocking = true
                        local playerPed = PlayerPedId()
                                
                        RequestAnimDict("timetable@jimmy@doorknock@")
                        while not HasAnimDictLoaded("timetable@jimmy@doorknock@") do Wait(10) end
                        TaskPlayAnim(playerPed, "timetable@jimmy@doorknock@", "knockdoor_idle", 8.0, -8.0, 2000, 0, 0, false, false, false)
                        --lib.notify({ title = 'You're knocking on the door...', type = 'inform' })
                        Wait(2500)
                        ClearPedTasks(playerPed)
                                
                        TriggerServerEvent('trickortreat:spawnNPC', i)
                        knocking = false
                    end
                }
            }
        })
    end
end)

-- NPC
RegisterNetEvent('trickortreat:spawnNPCClient', function(coords)
    local model = GetHashKey(friendlyPeds[math.random(1, #friendlyPeds)])
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(10) end
        
    local ped = CreatePed(4, model, coords.x, coords.y, coords.z, coords.w, false, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    TaskLookAtEntity(ped, PlayerPedId(), -1, 2048, 3)
    Wait(1000)

    -- anim
    RequestAnimDict("mp_common")
    while not HasAnimDictLoaded("mp_common") do Wait(10) end
    TaskPlayAnim(ped, "mp_common", "givetake1_a", 8.0, -8.0, 1500, 0, 0, false, false, false)
    Wait(3000)
    DeletePed(ped)
end)

    -- angry npc
    RegisterNetEvent('trickortreat:attackPlayer', function(coords)
    local playerPed = PlayerPedId()
    local model = GetHashKey(evilPeds[math.random(1, #evilPeds)])
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(10) end

    -- weaponn
    local ped = CreatePed(4, model, coords.x, coords.y, coords.z, coords.w, true, true)
    GiveWeaponToPed(ped, GetHashKey('WEAPON_BATTLEAXE'), 1, false, true)
    SetCurrentPedWeapon(ped, GetHashKey('WEAPON_BATTLEAXE'), true)
    SetPedCombatAttributes(ped, 46, true) -- fight
    SetPedCombatRange(ped, 2)
    SetPedCombatMovement(ped, 2)
    SetPedAccuracy(ped, 60)
    SetPedArmour(ped, 100)
    SetEntityHealth(ped, 200)
    SetPedFleeAttributes(ped, 0, false)
    SetBlockingOfNonTemporaryEvents(ped, true)
    TaskCombatPed(ped, playerPed, 0, 16)

    -- thread for monitoring players and npc
    CreateThread(function()
        while DoesEntityExist(ped) do
            local playerDead = IsEntityDead(playerPed)
            local npcDead = IsPedDeadOrDying(ped, true)

            if npcDead or playerDead then
                Wait(3000)
                if DoesEntityExist(ped) then
                    DeletePed(ped)
                end
                break
            end

            Wait(1000)
        end
    end)
end)
