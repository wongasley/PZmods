local adminNames = {
    ["merry"] = true,
    ["santa"] = true,
    ["hamprey"] = true,
    -- ... more admin names ...
}

local adminsCache = {}

local function IsAdmin(playerObj)
    local playerName = playerObj:getUsername()

    if adminsCache[playerName] ~= nil then
        return adminsCache[playerName]
    end

    local isAdmin = adminNames[playerName] or false
    adminsCache[playerName] = isAdmin
    
    return isAdmin
end

local function KickPlayer(playerObj, actionType, cheatType)
    if IsAdmin(playerObj) then
        print("Admin detected. Bypassing kick.")
        return
    end

    -- The line sending a message to the chat was removed here.

    sendClientCommand("AnTiCheat", "Print", {Type = cheatType})

    if actionType == "Ban" then
        getCore():quitToDesktop()
        local BlackUI = BlackUI:new(0, 0, getPlayerScreenWidth(1), getPlayerScreenHeight(1), playerObj)
        BlackUI:initialise()
        BlackUI:addToUIManager()
    end
end

local function CheckPlayerAccess(playerObj)
    if IsAdmin(playerObj) then
        print("Admin detected. Bypassing access checks.")
        return
    end
    
    if playerObj:getAccessLevel() ~= "None" then
        local AdminList = SandboxVars.AnTi.AdminName
        local AdminTable = {}
        for sub in string.gmatch(AdminList, "([^;]+)") do
            table.insert(AdminTable, sub)
        end

        local Find = false
        for i = 1, #AdminTable do
            if playerObj:getUsername() == AdminTable[i] then
                Find = true
                break
            end
        end
        if not Find then
            playerObj:setAccessLevel("None")
            KickPlayer(playerObj, "Ban", "NotAdmin")
        end

    else
        local cheats = {
            {condition = function() return SandboxVars.AnTi.EnAbleGodModProtect and playerObj:isGodMod() end, 
             action = function() playerObj:setGodMod(false) end, cheatName = "GodMod"},
            {condition = function() return SandboxVars.AnTi.EnAbleGhostModProtect and playerObj:isGhostMode() end, 
             action = function() playerObj:setGhostMode(false) end, cheatName = "GhostMod"},
            {condition = function() return SandboxVars.AnTi.EnAbleInfiniteModProtect and getDebugOptions():getBoolean("Cheat.Player.UnlimitedAmmo") end, 
             action = function() getDebugOptions():setBoolean("Cheat.Player.UnlimitedAmmo", false) end, cheatName = "UnlimitedAmmo"},
            {condition = function() return SandboxVars.AnTi.EnAbleBuildProtect and playerObj:isBuildCheat() end, 
             action = function() playerObj:setBuildCheat(false) end, cheatName = "BuildCheat"},
            {condition = function() return SandboxVars.AnTi.EnAbleInfiniteCarryProtect and playerObj:isUnlimitedCarry() end, 
             action = function() playerObj:setUnlimitedCarry(false) end, cheatName = "UnlimitedCarry"},
            {condition = function() return SandboxVars.AnTi.EnAbleUnlimitedEnduranceProtect and playerObj:isUnlimitedEndurance() end, 
             action = function() playerObj:setUnlimitedEndurance(false) end, cheatName = "UnlimitedEndurance"},
            {condition = function() return SandboxVars.AnTi.EnAbleNoClipProtect and playerObj:isNoClip() end, 
             action = function() playerObj:setNoClip(false) end, cheatName = "NoClip"},
            {condition = function() return SandboxVars.AnTi.EnAbleFastMoveProtect and ISFastTeleportMove and ISFastTeleportMove.cheat end, 
             action = function() ISFastTeleportMove.cheat = false end, cheatName = "FastMove"},
            {condition = function() return SandboxVars.AnTi.EnAbleHealthCheatProtect and playerObj:isHealthCheat() end, 
             action = function() playerObj:setHealthCheat(false) end, cheatName = "HealthCheat"},
            {condition = function() return SandboxVars.AnTi.EnAbleMechanicsCheatProtect and playerObj:isMechanicsCheat() end, 
             action = function() playerObj:setMechanicsCheat(false) end, cheatName = "MechanicsCheat"},
            {condition = function() return SandboxVars.AnTi.EnAbleBrushToolProtect and BrushToolManager and BrushToolManager.instance end, 
             action = function() BrushToolManager.instance:close() end, cheatName = "BrushTool"},
            {condition = function() return SandboxVars.AnTi.EnAbleItemListProtect and ISItemsListViewer and ISItemsListViewer.instance end, 
             action = function() ISItemsListViewer.instance:close() end, cheatName = "ItemList"},
            {condition = function() return SandboxVars.AnTi.EnAbleCheatMenutProtect and ISCheatPanelUI and ISCheatPanelUI.instance end, 
             action = function() ISCheatPanelUI.instance:setVisible(false); ISCheatPanelUI.instance:removeFromUIManager() end, cheatName = "CheatMenu"},
            {condition = function() return SandboxVars.AnTi.EnAblePlayerMenuProtect and ISPlayerStatsUI and ISPlayerStatsUI.instance end, 
             action = function() ISPlayerStatsUI.instance:setVisible(false); ISPlayerStatsUI.instance:removeFromUIManager() end, cheatName = "PlayerMenu"}
        }
        

        for _, cheat in ipairs(cheats) do
            if cheat.condition() then
                cheat.action()
                KickPlayer(playerObj, "Warn", " is using " .. cheat.cheatName)
                print("AnTiCheat:Warn: " .. playerObj:getUsername() .. " is using " .. cheat.cheatName)
            end
        end
    end
end

local function AnTiCheatWorking(playerObj)
    if IsAdmin(playerObj) then
        print("Admin detected. Bypassing anti-cheat.")
        return
    end

    if EHMenu and EHMenu.instance then
        EHMenu.instance:setVisible(false)
        EHMenu.instance:removeFromUIManager()
        EHMenu.instance = nil
        KickPlayer(playerObj, "Ban")
    end
    CheckPlayerAccess(playerObj)
end

Events.OnPlayerUpdate.Add(AnTiCheatWorking)

local function CreatErrorLog()
    error("AntiCheat is working, please delete it and restart the game")
end

local function ClearHackClient()
    if EHMenu and EHMenu.API then
        EHMenu.API = nil
        Events.OnTick.Add(CreatErrorLog)
    end
end

Events.OnTick.Add(ClearHackClient)
