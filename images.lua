local Class = require "class"

local Image = Class:derive("Image")

love.graphics.setDefaultFilter("nearest","nearest",10)

function Image:new(file)
	self.image=love.graphics.newImage("assets/images/"..file..".png")
	self.w=self.image:getWidth()
	self.h=self.image:getHeight()
end

---------------

local Images = {}

Images.player = Image("player")

Images.tiles = {}
Images.tiles.stoneBrick = Image("stoneBrick")

Images.ui = {}
Images.ui.chiSticker = Image("chiSticker")

Images.entities = {}
Images.entities.fireball = Image("entities/fireball")

return Images