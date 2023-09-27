-- Helper function to split strings
local function str_split(str, sep)
    local sep, res = sep or '%s', {}
    string.gsub(str, '[^' .. sep .. ']+', function(x)
        res[#res + 1] = x
    end)
    return res
end

-- Teleports the player to given coordinates
local function teleportPlayer(player, x, y, z)
    player:setX(x)
    player:setY(y)
    player:setZ(z)
    player:setLx(x)
    player:setLy(y)
    player:setLz(z)
end

-- Handle teleportation and inventory updates
local function teleport(player, teleportString, itemString, item)
    local coordinates = str_split(teleportString, '@')
    
    if #coordinates ~= 2 then
        print("Error, teleport coordinates not defined correctly!")
        return
    end

    local xyBounds = {}
    for _, v in ipairs(coordinates) do
        local xy = str_split(v, '-')
        if #xy ~= 3 then
            print("Error, teleport coordinates not defined correctly!")
            return
        end

        table.insert(xyBounds, {
            x = tonumber(xy[1]),
            y = tonumber(xy[2]),
            z = tonumber(xy[3]),
        })
    end

    local destX = ZombRand(xyBounds[1].x, xyBounds[2].x + 1)
    local destY = ZombRand(xyBounds[1].y, xyBounds[2].y + 1)
    local destZ = ZombRand(xyBounds[1].z, xyBounds[2].z + 1)

    teleportPlayer(player, destX, destY, destZ)

    local items = str_split(itemString, ';')
    for _, v in ipairs(items) do
        player:getInventory():AddItems(v, 1)
    end

    player:getInventory():Remove(item)
end

-- Add context menu options for the magic cookie
local function DoTeleporterMenu(player, context, items)
    if #items ~= 1 then return end

    local item = instanceof(items[1], "InventoryItem") and items[1] or items[1].items[1]
    if item:getFullType() ~= "Base.MagicCookie" then return end
    
    context:addOption(SandboxVars.Teleporter.TeleportLocation1Name, player, teleport, SandboxVars.Teleporter.TeleportLocation1, SandboxVars.Teleporter.TeleportItems, item)
    context:addOption(SandboxVars.Teleporter.TeleportLocation2Name, player, teleport, SandboxVars.Teleporter.TeleportLocation2, SandboxVars.Teleporter.TeleportItems, item)
    context:addOption(SandboxVars.Teleporter.TeleportLocation3Name, player, teleport, SandboxVars.Teleporter.TeleportLocation3, SandboxVars.Teleporter.TeleportItems, item)
end

---- INITIALISATION ----
Events.OnFillInventoryObjectContextMenu.Add(DoTeleporterMenu)