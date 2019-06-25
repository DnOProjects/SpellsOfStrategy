local Class = require "class"
local Vector = require "vector"

local Entity = Class:derive("Entity")

function Entity:new(x,y)
	self.pos=Vector(x,y)
end

return Entity