local Vector = require "vector"
local Character = require "character"
local Cards = require "cards"
local Class = require "class"
local Ease = require "ease"

local board = {}
board.size = Vector(16,8)
board.tileSize = 100

local characters = {Character(1,1)}
local entities = {}
local ui = {}

local macroState = "inGame"
local turnNum = 1
local updateNum = 0 --is 0 when not updating
local animTimer = 0

local deckHeight=60

local font = love.graphics.newFont("assets/fonts/Roboto-Regular.ttf", 48)

function love.load()
	for i=1,8 do 
		characters[1]:addToDeck("fireball")
	end
	love.window.setFullscreen(true)
	love.graphics.setFont(font)
end

function love.draw()
	for x=1,board.size[1] do
		for y=1,board.size[2] do
			love.graphics.rectangle("line",x*board.tileSize,y*board.tileSize,board.tileSize,board.tileSize)
		end
	end
	for i=1,#characters do
		local c = characters[i]
		love.graphics.circle("fill",(c.pos[1]+0.5)*board.tileSize,(c.pos[2]+0.5)*board.tileSize,board.tileSize/2)
	end
	drawDeck(characters[turnNum].deck)

	drawArrow(Vector(500,500),Vector(love.mouse.getX(),love.mouse.getY()),100,40,8)
end

local mouseWasUp = true

function love.update(dt)
	local mx,my = love.mouse.getX(), love.mouse.getY()

	if love.mouse.isDown(1) then
		if mouseWasUp then
			local mapCoords = screenToMap(getMouseCoords())
			if mapCoords:matches(characters[turnNum].pos) then
				characters[turnNum].beingDragged = true
			end
		end
		mouseWasUp = false
	else
		if not mouseWasUp then
			local dest = screenToMap(getMouseCoords())
			if characters[turnNum].beingDragged and dest:distance(characters[turnNum].pos)==1 and isInBounds(dest) then
				characters[turnNum].pos = screenToMap(getMouseCoords())
				characters[turnNum].beingDragged = false
			end
		end
		mouseWasUp = true
	end

	local cardWidth = love.graphics.getWidth()/#characters[turnNum].deck
	local cardNum = math.floor(mx/cardWidth)+1
	for i=1,#characters[turnNum].deck do
		local card = characters[turnNum].deck[i]
		local cardTop = love.graphics.getHeight()-deckHeight
		if card.popupLevel>0 then cardTop = cardTop - card.fullHeight end
		if i==(cardNum) and (my>=cardTop) then
			card.popupLevel = card.popupLevel + (dt*3)
		else
			card.popupLevel = card.popupLevel - (dt*3)
		end
		if card.popupLevel>1 then card.popupLevel=1 end
		if card.popupLevel<0 then card.popupLevel=0 end
	end
end

function drawDeck(deck)
	--TODO:
	--Card name becomes smaller as more cards are added
	--Cards expand left/right around a tab using a [quad?] to draw
	local cardWidth = love.graphics.getWidth()/#deck
	if #deck < 5 then cardWidth = love.graphics.getWidth()/5 end
	for i=1,#deck do
		local card = deck[i]
		local x = (i-1)*cardWidth
		local y = Ease.outQuad(card.popupLevel,love.graphics.getHeight()-deckHeight,-card.fullHeight,1)
		local height = Ease.inExpo(card.popupLevel,deckHeight,card.fullHeight,1)
		love.graphics.rectangle("line",x,y,cardWidth,height)
		love.graphics.printf(card.name,x,y,cardWidth,"center")
	end
end

function getMouseCoords()
	return Vector(love.mouse.getX(),love.mouse.getY())
end

function screenToMap(point)
	return Vector(math.floor(point[1]/board.tileSize),math.floor(point[2]/board.tileSize))
end

function isInBounds(point) 
	if point[1]>0 and point[1]<=board.size[1] and point[2]>0 and point[2]<=board.size[2] then
		return true
	end
	return false
end

function makeMove(characterNum,moveData)
	if characterNum==turnNum then

	end
end

function drawArrow(start,stop,resolution,deviation,size)
	local points = {}

	local middle = start:getAdverage(stop)
	local temp = start:take(stop)
	local gradient = temp[2]/temp[1]
	local normal = -1/gradient
	local distance = start:distance(stop)
	local xDeviation = math.sqrt((deviation^2)/(1+normal^2))*distance*0.01
	if (start[2]>stop[2]) or (start[1]>stop[1]) then xDeviation = xDeviation * -1 end
	if (stop[1]<start[1]) and (stop[2]<start[2]) then xDeviation = xDeviation * -1 end

	local e = middle:add(Vector(xDeviation,xDeviation*normal))
	local quadratic = getQuadratic(start,e,stop)
	local a,b,c = quadratic.a, quadratic.b, quadratic.c

	for i=1,resolution do --sample points spaced along the line
		local x = start[1]+(((stop[1]-start[1])/resolution)*i)
		local y = a*x^2 + b*x + c
		points[#points+1] = x
		points[#points+1] = y
	end

	love.graphics.setLineWidth(size)
	love.graphics.line(points)
	love.graphics.setLineWidth(1)

	--go [20] pixels back along line
		local headSize = 20
		--find number of points back to go combining resolution, headSize and distance (arrowLength)
		local numPointsBack = math.floor(headSize/(distance/resolution))
	--find the normal line at that point
		local temp = #points-(numPointsBack*2)
		local point = Vector(points[temp-1],points[temp])
		local tangent = point:take(stop)
		local normal = tangent:getNormal()
	--go [10] pixels either way along that line to find 2 other points
		local p2 = point:add(normal)
		local p3 = point:take(normal) --test
	--points: p1, p2 and p3
		local p1 = stop

	love.graphics.polygon('fill',p1[1],p1[2],p2[1],p2[2],p3[1],p3[2])

	love.graphics.setColor(1,0,0)
	love.graphics.circle("fill",point[1],point[2],4)
	love.graphics.setColor(1,1,1)
end

function getQuadratic(d,e,f)
	--Inputs points d,e and f
	--Returns values a,b and c of quadratic formula
	local ma1 = (d[1]-e[1]) / ((e[1]^2)-(d[1]^2))
	local ca1 = (e[2]-d[2]) / ((e[1]^2)-(d[1]^2))

	local ma2 = (e[1]-f[1]) / ((f[1]^2)-(e[1]^2))
	local ca2 = (f[2]-e[2]) / ((f[1]^2)-(e[1]^2))

	local b = (ca2-ca1) / (ma1-ma2)
	local a = ma1*b + ca1
	local c = d[2]-a*d[1]^2-b*d[1]

	return {a=a,b=b,c=c}

end