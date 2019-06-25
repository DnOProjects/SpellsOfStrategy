local Class = require "class"
local Vector = require "vector"
local Utility = require "utility"
local Cards = require "cards"

local Character = Class:derive("Character")

function Character:new(x,y)
	self.pos=Vector(x,y)
	self.health=100
	self.chi=0
	self.beingDragged=false
	self.deck={}
end

function Character:addToDeck(cardName)
	local card = Utility.findByTag(Cards,"name",cardName)()
	card.popupLevel = 0 --0=down; 1=up
	self.deck[#self.deck+1] = card
end

return Character