--[[
    Live shop catalog. Built-in listings are empty on purpose — admins add
    vehicles, weapons, extras, bundles, gangs, exclusives, and limited drops
    in-game from the Admin tab (stored in dj_envydonator_listings).
]]

function CatalogReset()
    Catalog = {
        vehicles = EmptyTierBuckets(),
        weapons = {},
        extras = {},
        bundles = {},
        pets = {},
        exclusives = {},
        limited = {},
        gangs = {},
    }
end

CatalogReset()

function CatalogPut(item)
    if not item or not item.id then
        return
    end
    local category = item.category or 'extras'
    if category == 'vehicles' then
        local tier = NormalizeTier(item.tier)
        item.tier = tier
        if not Catalog.vehicles[tier] then
            Catalog.vehicles[tier] = {}
        end
        Catalog.vehicles[tier][#Catalog.vehicles[tier] + 1] = item
        return
    end
    if category == 'weapons' then
        item.tier = nil
        Catalog.weapons = Catalog.weapons or {}
        Catalog.weapons[#Catalog.weapons + 1] = item
        return
    end
    if Catalog[category] then
        Catalog[category][#Catalog[category] + 1] = item
    else
        Catalog.extras[#Catalog.extras + 1] = item
    end
end

function CatalogAll()
    local out = {}
    local function take(list, category, tier)
        if not list then
            return
        end
        for i = 1, #list do
            local copy = {}
            for k, v in pairs(list[i]) do
                copy[k] = v
            end
            copy.category = copy.category or category
            copy.tier = copy.tier or tier
            out[#out + 1] = copy
        end
    end
    for _, tier in ipairs(Tiers.ids) do
        take(Catalog.vehicles[tier], 'vehicles', tier)
    end
    take(Catalog.weapons, 'weapons')
    take(Catalog.extras, 'extras')
    take(Catalog.bundles, 'bundles')
    take(Catalog.pets, 'pets')
    take(Catalog.exclusives, 'exclusives')
    take(Catalog.limited, 'limited')
    take(Catalog.gangs, 'gangs')
    return out
end

function GetCatalogItem(itemId)
    if not itemId then
        return nil
    end
    local all = CatalogAll()
    for i = 1, #all do
        if all[i].id == itemId then
            return all[i]
        end
    end
end
