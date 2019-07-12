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
        cls.sprite = Sprite("entities.fireball",100,100,8,20) or values.sprite
        cls.pos = Vector(1,1)
        cls.updateTimer = 0

        --Optional, modular proporties
        cls.movesInSteps = values.movesInSteps or false --travels by a certain amount in its set direction every time it updates

    function cls:new(args)
        self.caster = args.caster
        self.pos = args.tile
        self.vel = self.pos:take(self.caster.pos)
    end

    function cls:startUpdating()
        self.startPos = Utility.deepCopy(self.pos)
    end

    function cls:update()
        self.pos = self.startPos:add(self.vel:scale(self.updateTimer))
    end

    function cls:finishUpdating()
        self.pos = self.pos:round(0)
    end

    return cls
end

-------------------------
local Entities = {}

function Entities.drawGhost(name,pos)
    love.graphics.setColor(1,1,1,0.5)
    local sprite = Entities[name].sprite
    local x,y = Board.mapToScreen(pos):unpack()
    love.graphics.draw(Utility.index(Images,sprite.imageName).image,sprite.frame,x,y)
    love.graphics.setColor(1,1,1)
end

function Entities.addEntity(name,args)
    Entities[#Entities+1] = Entities[name](args)
end

function Entities.draw()
    for i=1,#Entities do
        local e = Entities[i]
        local drawPos = Board.mapToScreen(e.pos)
        love.graphics.draw(Utility.index(Images,e.sprite.imageName).image,e.sprite.frame,drawPos[1],drawPos[2])
        love.graphics.print(i,drawPos[1],drawPos[2])
    end
end

function Entities.update(dt)
    if turnState == "updateEntities" then
        local e = Entities[entityUpdating]
        if e.updateTimer == 0 then
            e:startUpdating()
        end
        e:update()
        e.updateTimer = e.updateTimer + dt
        if e.updateTimer > 1 then
            e.updateTimer = 0 
            e:finishUpdating()
            entityUpdating = entityUpdating + 1
            if entityUpdating > #Entities then
                entityUpdating = 1
                turnState = "move"
                if turnNum == 1 then turnNum = 2
                else turnNum = 1 end
                return
            end
        end
    end
end

Entities.fireball = Entity:derive({name="fireball",movesInSteps={speed=3}})

return Entities