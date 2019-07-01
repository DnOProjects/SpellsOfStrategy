local Class = require "class"

local Image = Class:derive("Image")

function Image:new(file)
	self.image=love.graphics.newImage("assets/images/"..file..".png")
	self.w=self.image:getWidth()
	self.h=self.image:getHeight()
end

---------------

local Images = {}

Images.entities = {}
Images.entities.fireball = Image("entities/fireball")

return Images