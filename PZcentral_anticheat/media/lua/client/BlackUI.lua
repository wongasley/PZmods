require "ISUI/ISPanel"

BlackUI = ISPanel:derive("BlackUI");
local this = BlackUI

function BlackUI:initialise()
    ISPanel.initialise(self);
    self:create();
end

function BlackUI:prerender()
    ISPanel.prerender(self);
end

function BlackUI:destroy()
    UIManager.setShowPausedMessage(true)
end
function BlackUI:render()
    local w = getPlayerScreenWidth(1)
    local h = getPlayerScreenHeight(1)
    self:drawTextureScaled(nil, 0, 0, w, h, self.alpha, 0, 0, 0)
end

function BlackUI:create()

end

function BlackUI:new(x, y, width, height, player)
    local o = {};
    o = ISPanel:new(x, y, width, height);
    setmetatable(o, self);
    o.character = player;
    self.__index = self;
    this.instance = o
    o.anchorRight = true
    o.anchorBottom = true
    o.anchorTop = true
    o.teleportflag = false
    o.enter = false
    o.anchorLeft = true
    o.alpha = 1
    return o;
end

