local Class = require "class"
local Board = require "board"
local Vector = require "vector"
local Utility = require "utility"
local Cards = require "cards"
local Ease = require "ease"

local Character = Class:derive("Character")

	function Character:new(x,y)
		self.growTimer=0

		--Stats
		self.health=100
		self.chi=0
		self.deck={}

		--Position
		self.pos=Vector(x,y)
		self.visualPos=Vector(x,y)

		--Size
		self.size=1
		self.defealtSize=1

		--Dragging
		self.beingDragged=false
		self.draggingSize=1.5
		self.pickupSpeed=2
	end

	function Character:draw()
		if self.beingDragged==false then
			love.graphics.circle("fill",(self.visualPos[1]+0.5)*board.tileSize,(self.visualPos[2]+0.5)*board.tileSize,self.size*(board.tileSize/2))
		else
			local neighbours = Utility.getNeighbours(self.pos)
			for i=1,#neighbours do
				if Board.isInBounds(neighbours[i]) then
					Board.drawHighlight(neighbours[i],"green")
				end
			end
			love.graphics.setColor(1,1,1,0.3)
			love.graphics.circle("fill",(self.pos[1]+0.5)*board.tileSize,(self.pos[2]+0.5)*board.tileSize,self.defealtSize*(board.tileSize/2))
			love.graphics.setColor(1,1,1,1)
			love.graphics.circle("fill",(self.visualPos[1]+0.5),(self.visualPos[2]+0.5),self.size*(board.tileSize/2))
		end
	end

	function Character:updateDragging(dt)
		if self.beingDragged==true then
			self.growTimer=Ease.stepTimer(self.growTimer,self.pickupSpeed,dt)
			self.visualPos=Utility.getMouseCoords()
		else
			self.growTimer=Ease.stepTimer(self.growTimer,-self.pickupSpeed,dt)
			self.visualPos=self.pos
		end
		self.size = Ease.inCirc(self.growTimer,self.defealtSize,self.draggingSize-self.defealtSize,1)
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

	function Characters.update(dt)
		for i=1,#Characters do
			Characters[i]:updateDragging(dt)
		end
	end

return Characters