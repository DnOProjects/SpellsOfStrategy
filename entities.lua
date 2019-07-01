local Class = require "class"
local Vector = require "vector"
local Sprite = require "sprite"
local Images = require "images"
local Utility = require "utility"

local Entity = Class:derive("Entity")

function Entity:derive(values)
    local cls = {}
    cls["__call"] = Class.__call
    cls.type = "Card"
    cls.__index = cls
    cls.super = self
    setmetatable(cls, self)

    --Default values:
        cls.name = values.name or "Untitled"
        cls.sprite = Sprite("entities.fireball",64,64,8,20) or values.sprite
        cls.sprite:addAnimation("normal","loop")
        cls.sprite:setAnimation("normal")

        --Optional, modular proporties
        cls.movesInSteps = values.movesInSteps or false --travels by a certain amount in its set direction every time it updates

    return cls
end

-------------------------
local Entities = {}

function Entities.drawGhost(name,x,y)
    love.graphics.setColor(1,1,1,0.5)
    local sprite = Entities[name].sprite
    sprite:update(0.1)
    love.graphics.draw(Utility.index(Images,sprite.imageName).image,sprite.frame,x,y,0,4,4)
end

Entities.fireball = Entity:derive({name="fireball",movesInSteps={speed=3}})

return Entities