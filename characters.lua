local Class = require "class"
local Vector = require "vector"
local Ease = require "ease"
local Input = require "input"
local Images = require "images"

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
			love.graphics.draw(Images.player.image,self.pos[1]*board.tileSize,self.pos[2]*board.tileSize,0,self.size,self.size)
		else
			local neighbours = Utility.getNeighbours(self.pos)
			for i=1,#neighbours do
				if Board.isInBounds(neighbours[i]) then
					Board.drawHighlight(neighbours[i],"green")
				end
			end
			love.graphics.setColor(1,1,1,0.3)
			love.graphics.draw(Images.player.image,self.pos[1]*board.tileSize,self.pos[2]*board.tileSize,0,self.defealtSize,self.defealtSize)
			love.graphics.setColor(1,1,1,1)
			love.graphics.draw(Images.player.image,self.visualPos[1],self.visualPos[2],0,self.size,self.size)
		end
	end

	function Character:updateDragging(dt)
		if self.beingDragged==true then
			self.growTimer=Ease.stepTimer(self.growTimer,self.pickupSpeed,dt)
			self.visualPos=Input.getMouseCoords():take(Vector(1,1):scale(board.tileSize*self.size*0.5))
		else
			self.growTimer=Ease.stepTimer(self.growTimer,-self.pickupSpeed,dt)
			self.visualPos=self.pos
		end
		self.size = Ease.inCirc(self.growTimer,self.defealtSize,self.draggingSize-self.defealtSize,1)
	end

	function Character:updateDeck()
		local d = self.deck
		for i=#d,1,-1 do
			if d[i].toRemove then
				table.remove(d,i)
			end
		end
	end

	function Character:addCardToDeck(cardName)
		local card = Utility.findByTag(Cards,"name",cardName)
		local newObject = card()
		card.popupLevel = 0 --0=down; 1=up
		self.deck[#self.deck+1] = newObject
	end

local Characters = {}

	function Characters.load()
		Characters[1]=Character(1,1)
		Characters[2]=Character(8,1)
		for j=1,2 do
			for i=1,8 do
				Characters[j]:addCardToDeck("fireball")
			end
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
			local c = Characters[i]
			c:updateDragging(dt)
			c:updateDeck()
		end
	end

return Characters