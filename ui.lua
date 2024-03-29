local Class = require "class"
local Ease = require "ease"
local Images = require "images"
local Input = require "input"

local UI = {deckHeight=60}

function UI.load()
	love.window.setFullscreen(true)
	local font = love.graphics.newFont("assets/fonts/Roboto-Regular.ttf", 48)
	love.graphics.setFont(font)
end

function UI.draw()
	UI.drawDeck(Characters[turnNum].deck)
	if turnState == "specifyCast" then
		UI.drawCastingUI()
	end
end

function UI.drawCastingUI()
	local c = Characters[turnNum].castingCard
	if c~=nil then
		if c.castInputType == "shoot" then
			local shootingRangeCriteria = {Board.isInShootingRange,Board.isInBounds}
			Board.drawHighlightsWhere(shootingRangeCriteria,"red")
			local charPos = Characters[turnNum].pos
			local selectedTile = Input.getSelectedTile()
			if Board.tileMeetsCriteria(selectedTile,shootingRangeCriteria) then
				Entities.drawGhost("fireball",charPos:add(selectedTile:take(charPos):normalise()))
				Board.drawHighlight(selectedTile,"green")
			end
		end
	end
end

function UI.drawDeck(deck)
	--TODO:
	--Card name becomes smaller as more cards are added
	--Cards expand left/right around a tab using a [quad?] to draw
	local cardWidth = love.graphics.getWidth()/#deck
	if #deck < 5 then cardWidth = love.graphics.getWidth()/5 end
	for i=1,#deck do
		local card = deck[i]
		local x = (i-1)*cardWidth
		local y = Ease.outQuad(card.popupLevel,love.graphics.getHeight()-UI.deckHeight,-card.fullHeight,1)
		local height = Ease.inExpo(card.popupLevel,UI.deckHeight,card.fullHeight,1)
		love.graphics.rectangle("line",x,y,cardWidth,height)
		love.graphics.setColor(1,1,1)
		love.graphics.printf(card.name,x,y,cardWidth,"center")
		love.graphics.draw(Images.ui.chiSticker.image,x+8,y+13)
		love.graphics.print(card.chiCost,x+17,y+15,0,0.5,0.5)
	end
end


function UI.update(dt)
	local deck =  Characters[turnNum].deck
	local selectedCard = UI.getSelectedCard(deck)
	if selectedCard~=nil then
		selectedCard.popupLevel = selectedCard.popupLevel + (dt*3)
	end
	for i=1,#Characters[turnNum].deck do
		local card = deck[i]
		if card~=selectedCard then
			card.popupLevel = card.popupLevel - (dt*3)
		end
		if card.popupLevel>1 then card.popupLevel=1 end
		if card.popupLevel<0 then card.popupLevel=0 end
	end
end

function UI.getSelectedCard(deck)
	local cardWidth = love.graphics.getWidth()/#Characters[turnNum].deck
	if #Characters[turnNum].deck < 5 then cardWidth = love.graphics.getWidth()/5 end
	local cardIntersectingWithX = Characters[turnNum].deck[math.floor(love.mouse.getX()/cardWidth)+1]
	if love.mouse.getY()>=cardIntersectingWithX:getTop() then
		return cardIntersectingWithX
	end
end

UI.arrow = Class:derive("UI_arrow")
	function UI.arrow:new(start,stop,resolution,deviation,size,headSize)
		self.start=start
		self.stop=stop
		self.resolution=resolution
		self.deviation=deviation
		self.size=size
		self.headSize=headSize

		self:update()
	end

	function UI.arrow:update()
		self.points = {}
		local middle = self.start:getAdverage(self.stop)
		local temp = self.start:take(self.stop)
		local gradient = temp[2]/temp[1]
		local normal = -1/gradient
		local distance = self.start:distance(self.stop)
		local xDeviation = math.sqrt((self.deviation^2)/(1+normal^2))*distance*0.01
		if (self.start[2]>self.stop[2]) or (self.start[1]>self.stop[1]) then xDeviation = xDeviation * -1 end
		if (self.stop[1]<self.start[1]) and (self.stop[2]<self.start[2]) then xDeviation = xDeviation * -1 end

		local e = middle:add(Vector(xDeviation,xDeviation*normal))
		local quadratic = Utility.getQuadratic(self.start,e,self.stop)
		local a,b,c = quadratic.a, quadratic.b, quadratic.c

		for i=1,self.resolution do --sample points spaced along the line
			local x = self.start[1]+(((self.stop[1]-self.start[1]-self.size)/self.resolution)*i)
			local y = a*x^2 + b*x + c
			self.points[#self.points+1] = x
			self.points[#self.points+1] = y
		end

		local point = Vector(self.points[#self.points-3],self.points[#self.points-2])
		local tangent = point:take(self.stop):normalise():scale(self.headSize)
		local point = point:add(tangent)
		local normal = tangent:getNormal()
		--go [10] pixels either way along that line to find 2 other points
		local p2 = point:add(normal)
		local p3 = point:take(normal) --test
		--points: p1, p2 and p3
		local p1 = self.stop
		self.triangle = {p1,p2,p3}
	end	

	function UI.arrow:draw()
		love.graphics.setLineWidth(self.size)
		love.graphics.line(self.points)
		love.graphics.setLineWidth(1)
		local t = self.triangle
		love.graphics.polygon('fill',t[1][1],t[1][2],t[2][1],t[2][2],t[3][1],t[3][2])
	end

return UI