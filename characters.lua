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

	function Character:draw()
		love.graphics.circle("fill",(self.pos[1]+0.5)*board.tileSize,(self.pos[2]+0.5)*board.tileSize,board.tileSize/2)
	end

	function Character:addCardToDeck(cardName)
		local card = Utility.findByTag(Cards,"name",cardName)()
		card.popupLevel = 0 --0=down; 1=up
		self.deck[#self.deck+1] = card
	end

local Characters = {}

	function Characters.load()
		Characters[1]=Character(1,1)
		for i=1,8 do
			Characters[1]:addCardToDeck("fireball")
		end
		Characters.test=12
	end

	function Characters.draw()
		for i=1,#Characters do
			Characters[i]:draw()
		end
	end


return Characters