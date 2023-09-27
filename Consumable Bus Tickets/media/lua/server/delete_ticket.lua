-- delete_ticket.lua
local timer = require('lua_timers')

local function checkTicketExpiry(player, ticket)
    local currentTime = os.time()
    local ticketCreationTime = ticket:getModData().creationTime
    
    if (currentTime - ticketCreationTime) >= 360 then  -- 3600 seconds for 1 hour
        player:getInventory():Remove(ticket)
        print("Bus ticket has expired!")
    else
        timer:Simple(60, function() checkTicketExpiry(player, ticket) end)  -- Check again in 1 minute
    end
end

function spawnBusTicket(player)
    local ticket = player:getInventory():AddItem("Base.BusTicket")
    ticket:getModData().creationTime = os.time()
    timer:Simple(60, function() checkTicketExpiry(player, ticket) end)
end

return {
    spawnBusTicket = spawnBusTicket
}
