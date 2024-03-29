local Class = require "class"

local Card = Class:derive("Card")

function Card:derive(values)
    local cls = {}
    cls["__call"] = Class.__call
    cls.type = "Card"
    cls.__index = cls
    cls.super = self
    setmetatable(cls, self)

    --Default values:
    cls.name = values.name or "Untitled"
    cls.chiCost = values.chiCost or 5
    cls.fullHeight = values.fullHeight or 400
    cls.castInputType = values.castInputType or "shoot"
    cls.popupLevel = 0

    function cls:getTop()
        local top = love.graphics.getHeight()-UI.deckHeight
        if self.popupLevel>0 then top = top - self.fullHeight end
        return top
    end

    return cls
end

-------------------------

local fireball = Card:derive({name="fireball"})

local Cards = {fireball}

return Cards