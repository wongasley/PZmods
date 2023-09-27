local function str_split(str, sep)
    local sep, res = sep or '%s', {}
    string.gsub(str, '[^' .. sep .. ']+', function(x)
        res[#res + 1] = x
    end)
    return res
end

local function teleportPlayer(player, x,y,z)
    player:setX(x)
    player:setY(y)
    player:setZ(z)
    player:setLx(x)
    player:setLy(y)
    player:setLz(z)
end

local function teleport(player, teleportString, itemString, item)
    local coordinates = str_split(teleportString, '@')
    if #coordinates ~= 2 then
        print("Error, teleport coordinates not defined correctly!")
        return
    end

    local xyBounds = {}
    for i, v in ipairs(coordinates) do
        local xy = str_split(v, '-')

        if #xy ~= 3 then
            print("Error, teleport coordinates not defined correctly!")
            return
        end

        table.insert(xyBounds, {
            x = xy[1],
            y = xy[2],
            z = xy[3],
        })
    end

    local destX = ZombRand(tonumber(xyBounds[1].x), tonumber(xyBounds[2].x)+1)
    local destY = ZombRand(tonumber(xyBounds[1].y), tonumber(xyBounds[2].y)+1)
    local destZ = ZombRand(tonumber(xyBounds[1].z), tonumber(xyBounds[2].z)+1)

    teleportPlayer(getPlayer(), destX, destY, destZ)

    local items = str_split(itemString, ';')

    for i, v in ipairs(items) do
        getPlayer():getInventory():AddItems(v, 1)
    end

    getPlayer():getInventory():Remove(item)
end

local function deactivateRadio(p, radio)
    RadioUtils:SetActiveRadio(nil, true);
end

local function DoTeleporterMenu(player, context, items)
    local item

    if #items > 1 then
        return;
    end

	for i = 1, #items do
		if not instanceof(items[i], "InventoryItem") then
			item = items[i].items[1]
		else
			item = items[i]
		end

        if item:getFullType() ~= "Base.BusTicket" then
            return;
        end
	end
    
    context:addOption(SandboxVars.Teleporter.TeleportLocation1Name, player, teleport, SandboxVars.Teleporter.TeleportLocation1, SandboxVars.Teleporter.TeleportItems, item);
    context:addOption(SandboxVars.Teleporter.TeleportLocation2Name, player, teleport, SandboxVars.Teleporter.TeleportLocation2, SandboxVars.Teleporter.TeleportItems, item);
    context:addOption(SandboxVars.Teleporter.TeleportLocation3Name, player, teleport, SandboxVars.Teleporter.TeleportLocation3, SandboxVars.Teleporter.TeleportItems, item);
end

---- INITIALISATION ----

Events.OnFillInventoryObjectContextMenu.Add(DoTeleporterMenu);