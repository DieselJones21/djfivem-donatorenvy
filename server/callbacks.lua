DonatorCB = {}

function RegisterDonatorCallback(name, fn)
    DonatorCB[name] = fn
end

RegisterNetEvent('djfivem-donatorenvy:server:cb', function(id, name, payload)
    local src = source
    local fn = DonatorCB[name]
    if not fn then
        TriggerClientEvent('djfivem-donatorenvy:client:cb', src, id, { ok = false, error = 'unknown_callback' })
        return
    end
    local ok, result = pcall(fn, src, payload or {})
    if not ok then
        print(('[djfivem-donatorenvy] callback %s failed: %s'):format(name, result))
        Webhooks.Error('Callback failed', ('%s: %s'):format(name, tostring(result)))
        TriggerClientEvent('djfivem-donatorenvy:client:cb', src, id, { ok = false, error = 'internal' })
        return
    end
    TriggerClientEvent('djfivem-donatorenvy:client:cb', src, id, result)
end)
