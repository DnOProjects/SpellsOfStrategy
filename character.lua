local Class = require "class"
local Vector = require "vector"
local Utility = require "utility"
local Cards = require "cards"

local Character = Class:derive("Character")
local character = {}

function character.load()
	characters = {Character(1,1)}
	for i=1,8 do 
		characters[1]:addToDeck("fireball")
	end
end

function character.draw()
	for i=1,#characters do
		characters[i]:drawCharacter()
	end
end

function Character:new(x,y)
	self.pos=Vector(x,y)
	self.health=100
	self.chi=0
	self.beingDragged=false
	self.deck={}
end

function Character:drawCharacter()
	love.graphics.circle("fill",(self.pos[1]+0.5)*board.tileSize,(self.pos[2]+0.5)*board.tileSize,board.tileSize/2)
end

function Character:addToDeck(cardName)
	local card = Utility.findByTag(Cards,"name",cardName)()
	card.popupLevel = 0 --0=down; 1=up
	self.deck[#self.deck+1] = card
end

return character