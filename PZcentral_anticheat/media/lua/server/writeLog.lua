local Commands = {};
Commands.AnTiCheat = {};

local function onClientCommand_AnTiCheat(module, command, player, args)
    if Commands[module] and Commands[module][command] then
        Commands[module][command](player, args);
    end
end

Events.OnClientCommand.Add(onClientCommand_AnTiCheat)

Commands.AnTiCheat.Print = function(player, args)
    print("AnTiCheat:Warn: " .. player:getUsername() .. args.Type)
end

