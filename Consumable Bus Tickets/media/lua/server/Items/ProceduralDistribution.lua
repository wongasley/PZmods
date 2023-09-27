require "Items/Distributions.lua"
require "Items/ProceduralDistributions.lua"
require "Items/SuburbsDistributions.lua"
require "Vehicles/VehicleDistributions.lua"

local itemsToRemove = {
    ["MagicCookie"] = true,
}

local function RemoveLoot(zoneKey, zone)
    for i = #zone.items, 1, -1 do
        local y = zone.items[i]
        if itemsToRemove[y] then
            table.remove(zone.items, i)
        end
    end
end

local function loopOnTable(table)
    for zoneKey, zone in pairs(table) do
        if type(zone) == "table" then
            if zone and zone.items then
                RemoveLoot(zoneKey, zone)
                if zone.junk and zone.junk.items and zone.junk.items[1] then
                    RemoveLoot(zoneKey, zone.junk)
                end
            else
                if zone and not zone.procedural then
                    loopOnTable(zone)  -- Recursive call until we find zone.items or zone.procedural
                end
            end
        end
    end
end

local function modifyAllLootTables()
    ProceduralDistributions = ProceduralDistributions or {}
    VehicleDistributions = VehicleDistributions or {}
    SuburbsDistributions = SuburbsDistributions or {}
    Distributions = Distributions or {}
    loopOnTable(SuburbsDistributions)
    loopOnTable(Distributions)
    loopOnTable(ProceduralDistributions.list)
    loopOnTable(VehicleDistributions)
end

Events.OnPreDistributionMerge.Add(modifyAllLootTables)
